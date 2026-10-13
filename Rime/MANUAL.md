# 飞鹤快拼 — Quick manual

This is your modified [rime-fast-xhup](https://github.com/boomker/rime-fast-xhup) configuration.
Use Chinese mode (**中**) for the commands below. `Ctrl` means Control, not Command.
Prefixes are case-sensitive. For example, use `nL`, not `nl`.

## Basic use

Type Xiaohé double-pinyin, select a candidate, then push `Space`.
Example: `nihc` → **你好**. The menu shows five candidates per page.

## Keys

| Key | Action | When |
|---|---|---|
| `Space`, `1`–`5` | Insert the highlighted or numbered candidate | Candidate menu |
| `Up` / `Down` | Move the highlight | Candidate menu |
| `;` | Select candidate 2 | Candidate menu |
| `.` / `,` | Next / previous page | Previous page requires paging |
| `9` / `0` | Insert the word's first / last character | Normal Chinese input |
| `8` | Toggle short-code phrase priority | Menu with 3–6 lowercase code letters |
| `Esc` | Cancel input | During input |
| `Return`, `Ctrl+m` | Insert the raw code, not the candidate | During input |
| `Shift+Return` | Insert the displayed code | During input |
| `Ctrl+Shift+Return` | Insert the candidate comment | Candidate menu |
| `Backspace`, `Delete` | Delete before / at the cursor | During input |
| `Ctrl+Backspace` | Remove a syllable | During input |
| `Left` / `Right` | Move one code character | During input |
| `Shift+Left` / `Shift+Right`, `Shift+Tab` / `Tab` | Move by syllable | During input |
| `Ctrl+a` / `Ctrl+e` | Move to the start / end | During input |
| Left `Shift` alone | Temporary English mode | `Return` inserts text and returns to Chinese |
| `Ctrl+g` | Switch Chinese / English schemas | Non-empty input |
| `Ctrl+t` | Pin / unpin a candidate | Current code, candidate menu |
| `Ctrl+x` | Hide a candidate for this code | Candidate menu |
| `Ctrl+d` | Hide a candidate for all codes | Calculator mode uses it for Delete |
| `Ctrl+j` | Move a candidate behind three other candidates | Current code, candidate menu |
| `Ctrl+k`, `Shift+Delete` | Reduce learned candidate priority | Not a global frequency reset |
| `Ctrl+n` | Cycle shape hints, tone hints, and blank comments | Chinese candidate menu |
| `Ctrl+s` | Toggle character-first mode | Menu with 3–4 lowercase code letters |
| `Ctrl+;` | Toggle character-first mode | Any time |
| `Ctrl+.` / `Ctrl+,` | Toggle character width / punctuation language | Any time |
| `Ctrl+Shift+4` / `5` / `6` | Toggle emoji / Simplified conversion / Unicode-block hints | Candidate menu |
| `Ctrl+y` | Send the candidate to Easydict | macOS, Easydict installed |
| `Ctrl` + backtick | Open Rime's option menu | Any time |

For **你好**, `9` inserts **你**, and `0` inserts **好**.
Pins show `ᵀᴼᴾ`. Hide and priority records have no undo key.
`Ctrl+y` runs an external command. Avoid candidates with unusual shell characters.

## Chinese and English input

| Input | Function | Example |
|---|---|---|
| Pronunciation code | Double-pinyin | `nihc` → **你好** |
| Pronunciation + `/` + shape | Narrow character candidates | `ni/rx` → **你**, `uu/i` → **输** |
| Direct pronunciation + shape | Shape input without `/` | `nirx` → **你** |
| Four pronunciation keys + `/` + shape | Filter a two-character word | `nihc/nr` → **你好** |
| Pronunciation + `/I`, `/U`, `/N`, `/M` | Filter tones 1, 2, 3, 4 | `ni/N` → third-tone candidates |
| 2–7 lowercase letters | Short-code phrase search | Push `8` for priority with 3–6 letters |
| Backticks inside a code | Compose a phrase precisely | ``ni`rxhc`nz`` → **你好** |
| Phrase code + `` `= `` + new code | Save a custom phrase code | ``vsgovsyhdmuitd`=cctv`` → select **中国中央电视台** |
| `` `L `` + component codes | Find a character by its parts | `` `Lriyt `` includes **明** |
| `/ok` + sound or key | Double-pinyin / shape-key help | `/okian` offers `m` |
| English word + `'` | Show suppressed English completions | `beautiful'` |
| English start + `*` + end | Wildcard search | `ab*t` |
| Capital letters | Offer title case / uppercase | `Tool` / `TOol` |
| Word + `\` | Save a plain English word | `hermestest\`, then select and commit |
| `~` + text | Create English text, with commas as spaces | `~iPhone,28` → **iPhone 28** |

Two-character shape hints use the **second character first**: **你好** uses **好 = nz**, then **你 = rx**.
Unique slash-based character matches can insert automatically. Automatic word insertion is not active.
Backtick phrase composition alone does not save a phrase. Use `` `= `` for a saved custom code.
After you commit the `cctv` example, type `cctv` to get the saved phrase.
Plain English words become available immediately. Text with digits can require a later dictionary deployment.
The active space filter can change `VIP中P` to `VIP 中 P`. It does not space every separate commit.

For longer input ending in `'`, letter keys can select a matching syllable position.
Example: after `vsgovsyh'`, `v` moves to the first `vs`, and `Shift+V` moves to the last.

## Commands

| Input | Function or example |
|---|---|
| `/oh`, `oH` | Help reference. Entries do not run commands |
| `/so`, `sO` | Local display and input settings |
| `date`, `/wd`, `orq` | Date formats. Add `+2` or `-2` for a day offset |
| `time`, `/wt`, `osj` | Time formats. Add `'` for formats without a time-of-day prefix |
| `week`, `/wk`, `oxq` | Weekday in Chinese or English |
| `timestamp`, `/wts`, `/uts`, `ots` | Unix timestamp in seconds |
| `/now`, `/wjt` | Current date/time formats / today's date |
| `/wqt`, `/wzt`, `/wmt`, `/wht` | Two days ago / yesterday / tomorrow / in two days |
| `/wuz` or `/wlk`, `/wxz` or `/wnk` | Same weekday last / next week |
| `/wuy` or `/wlm`, `/wxy` or `/wnm` | Corresponding date last / next month |
| `/nl`, `nL`, `cL` | Lunar date. `nL20260217` → **丙午(马)年正月初一** |
| `/nn`, `nN`, `oN` | Chinese numbers. `nN123.45` → **壹佰贰拾叁元肆角伍分** |
| `=`, `cC` | Calculator. `=1+2` → `3`, `=sqrt(9)` → `3.0`, `=5!` → `120` |
| `cC/h`, `cC?h` | Calculator function reference |
| `lT` | LaTeX snippets. `lTff>>ooc` → `\phi\rangle\propto` |

**Lunar dates:** use exactly eight Gregorian date digits. Supported years: 1900–2099.
**Chinese numbers:** `s/d/f/j/m` select formal amount, ordinary amount, formal number, ordinary number, or digit-by-digit text.
The displayed `u/m` hints are wrong. For the grouped Arabic number, use `Page Down`, then select its candidate.
Financial output keeps at most four decimal places. Check integer-only output for an unwanted final `点`.

**Calculator:** supports `+ - * / ^`, parentheses, and factorials. `%` inserts `/100`.
`Shift+U/B/H/Q/K/W` insert `10/00/100/000/1000/0000`.
`Shift+J/I/O` select displayed candidates 3/4/5. Duplicate filtering can change their meaning.
Use the visible labels. `Shift+L` targets candidate 6, outside the five-item page.
Comma-separated function arguments are blocked. A bare `cC12` shows no result, and there is no saved `ans`.

## Symbols and punctuation

- `/vs` opens symbol categories. `Ctrl+p` returns from a category to `/vs`.
- `/jt` offers arrows. `;d` inserts **、**, and `;fdv` inserts **✅**.
- `;fe` offers common emoji. `;fs` offers common punctuation. `/wf` offers WeChat text codes.
- `/mba`, `/mbs`, `/mbc` offer Markdown code-fence starters, not complete blocks.
- `@` offers email-domain suffixes, such as `@gmail.com`.
- Opening brackets can enclose the next word: `[` + `nihc` + `Space` → **[你好]**.

**All symbol and emoji codes:** [symbols.custom.yaml](symbols.custom.yaml).
**All LaTeX replacement codes:** [lua/laTex.lua](lua/laTex.lua).

## Options and limits

The Rime option menu controls Chinese/English mode, punctuation, width, script conversion, emoji, prediction, character set, display, and hints.
Choose Hong Kong or Taiwan Traditional output there. `Ctrl+Shift+5` only toggles the Simplified-conversion flag.
Enable **联想** for next-word suggestions. Example: after **你好**, prediction can offer **吗**.
The grammar model and alternate pronunciation-key rules are disabled.

`/so` can change layout, labels, page size, line spacing, punctuation, character filters, and mixed-word spacing.
Its font-size, fuzzy-function, and automatic-word-insertion items do not work as labeled.
Its changes affect the generated configuration and can reset after deployment.

**Inactive:** `/jk`, `/kj`, history (`/hs`, `hH`, `uH`), `;ff`, and `Ctrl+r`.
Use `8`, not `Ctrl+q`. Use `9/0`, not `-/=`. Use `Ctrl+g`, not `Ctrl+Shift+E`.
Use `` `L `` for component lookup, not `rL`, `oL`, or `/fr`.
Use `lT`, not `/lt`, because `/lt` remains in the converted output.
Use `/oh`, not `/help`, and `/nl`, not `lunar`.
English-definition toggles and some date formats have known errors. Check their output.
