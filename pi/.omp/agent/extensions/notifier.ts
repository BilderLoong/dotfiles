import type { ExtensionAPI } from "@oh-my-pi/pi-coding-agent";
import { existsSync, readFileSync } from "node:fs";
import { join } from "node:path";

// omp notifier — adapted from @mohak34/opencode-notifier (MIT).
// Events: agent_end (complete, skipped while auto-continuing), ask tool (question),
// tool_approval_requested (permission).
// Config: optional ~/.omp/notifier.json, merged over DEFAULTS.

// ── Config ───────────────────────────────────────────────────────────────────

type EventKind = "complete" | "permission" | "question";

interface EventConfig {
	notification: boolean;
	sound: boolean;
	bell: boolean;
}

interface NotifierConfig {
	suppressWhenFocused: boolean;
	minDurationMs: number;
	sounds: Record<EventKind, string>;
	events: Record<EventKind, EventConfig>;
}

const DEFAULTS: NotifierConfig = {
	suppressWhenFocused: true,
	minDurationMs: 0,
	sounds: {
		complete: "/System/Library/Sounds/Glass.aiff",
		permission: "/System/Library/Sounds/Sosumi.aiff",
		question: "/System/Library/Sounds/Ping.aiff",
	},
	events: {
		complete: { notification: true, sound: true, bell: false },
		permission: { notification: true, sound: true, bell: false },
		question: { notification: true, sound: true, bell: false },
	},
};

const CONFIG_PATH = join(process.env.HOME ?? "", ".omp", "notifier.json");

function mergeConfig(user: Partial<NotifierConfig>): NotifierConfig {
	return {
		...DEFAULTS,
		...user,
		sounds: { ...DEFAULTS.sounds, ...(user.sounds ?? {}) },
		events: {
			complete: { ...DEFAULTS.events.complete, ...(user.events?.complete ?? {}) },
			permission: { ...DEFAULTS.events.permission, ...(user.events?.permission ?? {}) },
			question: { ...DEFAULTS.events.question, ...(user.events?.question ?? {}) },
		},
	};
}

function loadConfig(pi: ExtensionAPI): NotifierConfig {
	try {
		if (existsSync(CONFIG_PATH)) {
			const user = JSON.parse(readFileSync(CONFIG_PATH, "utf8")) as Partial<NotifierConfig>;
			return mergeConfig(user);
		}
	} catch (error) {
		pi.logger.warn(`notifier: bad config ${CONFIG_PATH}: ${String(error)}`);
	}
	return DEFAULTS;
}

// ── Focus detection (ported from opencode-notifier focus.ts) ─────────────────

const MAC_TERMINAL_APPS: Record<string, true> = {
	terminal: true,
	iterm2: true,
	ghostty: true,
	"wezterm-gui": true,
	alacritty: true,
	kitty: true,
	hyper: true,
	warp: true,
	tabby: true,
	cursor: true,
	"visual studio code": true,
	code: true,
	"code insiders": true,
	zed: true,
	rio: true,
};

export function normalizeAppName(name: string): string {
	return name.trim().toLowerCase().replace(/\.app$/, "").replace(/\s+/g, " ");
}

function allTerminalApps(): Set<string> {
	return new Set(Object.keys(MAC_TERMINAL_APPS));
}

export function expectedTerminalApps(): Set<string> {
	const term = (process.env.TERM_PROGRAM ?? "").trim().toLowerCase();
	// Inside tmux/screen with an opaque TERM_PROGRAM, any terminal counts.
	if (process.env.TMUX && (term === "" || term === "tmux" || term === "screen")) {
		return allTerminalApps();
	}
	if (term === "apple_terminal") return new Set(["terminal"]);
	if (term === "iterm" || term === "iterm2") return new Set(["iterm2"]);
	if (term === "vscode") return new Set(["visual studio code", "code", "code insiders"]);
	if (term === "warpterminal") return new Set(["warp"]);
	if (term === "wezterm") return new Set(["wezterm-gui"]);
	if (term) return new Set([term]);
	return allTerminalApps();
}

async function frontmostAppName(pi: ExtensionAPI): Promise<string | null> {
	const front = await pi.exec("lsappinfo", ["front"], { timeout: 1000 });
	if (front.code === 0) {
		const id = front.stdout.trim();
		if (id) {
			const info = await pi.exec("lsappinfo", ["info", "-only", "name", id], { timeout: 1000 });
			if (info.code === 0) {
				const match = info.stdout.match(/="([^"]*)"/);
				if (match) return match[1];
			}
		}
	}
	// Fallback: Accessibility-free System Events query.
	const fallback = await pi.exec(
		"osascript",
		[
			"-e",
			'tell application "System Events" to return name of first application process whose frontmost is true',
		],
		{ timeout: 2000 },
	);
	return fallback.code === 0 ? fallback.stdout.trim() : null;
}

async function suppressed(pi: ExtensionAPI, cfg: NotifierConfig): Promise<boolean> {
	if (!cfg.suppressWhenFocused) return false;
	const name = await frontmostAppName(pi);
	if (!name) return false;
	if (expectedTerminalApps().has(normalizeAppName(name))) {
		pi.logger.debug(`notifier: suppressed — terminal focused (${name})`);
		return true;
	}
	return false;
}

// ── Alert plumbing ───────────────────────────────────────────────────────────

const lastFiredAt: Record<string, number> = {};
let lastBellAt = 0;

function debounced(key: string, ms: number): boolean {
	const now = Date.now();
	if (now - (lastFiredAt[key] ?? 0) < ms) return true;
	lastFiredAt[key] = now;
	return false;
}

export function textPreview(content: unknown, max = 80): string {
	if (typeof content === "string") return content.slice(0, max);
	if (!Array.isArray(content)) return "";
	return content
		.filter(
			(block): block is { type: "text"; text: string } =>
				!!block && typeof block === "object" && (block as { type?: string }).type === "text",
		)
		.map((block) => block.text)
		.join(" ")
		.trim()
		.slice(0, max);
}

async function alert(pi: ExtensionAPI, cfg: NotifierConfig, kind: EventKind, title: string, message: string): Promise<void> {
	if (debounced(kind, 1000)) return;
	const ev = cfg.events[kind];

	if (ev.notification) {
		const result = await pi.exec(
			"osascript",
			["-e", `display notification ${JSON.stringify(message)} with title ${JSON.stringify(title)}`],
		);
		if (result.code !== 0) {
			pi.logger.warn(`notifier: osascript failed (${result.code}): ${result.stderr.trim()}`);
		}
	}

	if (ev.sound) {
		const result = await pi.exec("afplay", [cfg.sounds[kind]]);
		if (result.code !== 0) {
			pi.logger.warn(`notifier: afplay failed (${result.code}) for ${cfg.sounds[kind]}`);
		}
	}

	if (ev.bell && process.stdout.isTTY && Date.now() - lastBellAt > 500) {
		lastBellAt = Date.now();
		process.stdout.write("\x07");
	}
}

export default function notifier(pi: ExtensionAPI): void {
	const cfg = loadConfig(pi);
	const title = () => {
		const name = pi.getSessionName();
		return name ? `omp: ${name}` : "omp";
	};
	pi.logger.info(
		`notifier: loaded (suppressWhenFocused=${cfg.suppressWhenFocused}, minDurationMs=${cfg.minDurationMs})`,
	);

	let turnStartedAt = 0;

	pi.on("turn_start", (event) => {
		turnStartedAt = event.timestamp;
	});

	pi.on("agent_end", async (event) => {
		if (event.willContinue) return;
		const duration = Date.now() - (turnStartedAt || Date.now());
		if (cfg.minDurationMs > 0 && duration < cfg.minDurationMs) return;
		if (await suppressed(pi, cfg)) return;
		const lastAssistant = event.messages.findLast((message) => message.role === "assistant");
		const preview = lastAssistant ? textPreview(lastAssistant.content) : "";
		const body = preview ? `Done: ${preview}` : "Agent finished";
		await alert(pi, cfg, "complete", title(), body);
	});

	pi.on("tool_call", async (event) => {
		if (event.toolName !== "ask") return;
		if (await suppressed(pi, cfg)) return;
		const question = (event.input as { question?: string } | undefined)?.question ?? "";
		await alert(pi, cfg, "question", title(), `Asking: ${question.slice(0, 80)}`);
	});

	pi.on("tool_approval_requested", async (event) => {
		if (await suppressed(pi, cfg)) return;
		await alert(pi, cfg, "permission", title(), `${event.toolName} needs approval`);
	});
}
