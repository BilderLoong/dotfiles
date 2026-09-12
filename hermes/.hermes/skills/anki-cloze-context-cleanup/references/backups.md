# Backup storage and expiry

Use the installed skill folder, normally `~/.hermes/skills/anki-cloze-context-cleanup/backups/`. Create it with owner-only access (`0700`); create each backup as a new file with `0600` permissions. Never overwrite a backup. Keep private backups out of Git. Do not move or expire older backups elsewhere without a separate request.

Name new files `backup-YYYYMMDDTHHMMSSffffffZ.json` using the UTC creation time (microseconds are optional). Add these top-level metadata fields to the full backup:

```json
{
  "kind": "anki-cloze-context-backup/v1",
  "createdAt": "2026-01-31T10:00:00Z",
  "expiresAt": "2026-02-28T10:00:00Z"
}
```

This example is metadata only. The full file must also include the profile, query or explicit selection, every intended note ID, all original fields and tags, note type, card IDs, available card/scheduling data, and proposed edits. Reopen and verify the full backup before any Anki update.

Compute expiry with `expires_at(created_datetime)` from `scripts/backup_gc.py`. Use a timezone-aware UTC creation time. Expiry is one calendar month later, clamped to the last day when necessary. January 31 expires on February 28 (February 29 in a leap year), at the same UTC time. Expiry is reached at `now >= expiresAt`.

## Garbage collection

From the installed skill folder:

```sh
python3 -B scripts/backup_gc.py          # Preview only.
python3 -B scripts/backup_gc.py --delete # Remove recognized expired backups.
```

The default folder is `backups/` beside the invoked script's parent folder. Invoke the installed path to use the installed folder; `--backup-dir /exact/path` is available for a deliberate override.

The script checks only direct children with the managed filename, matching `kind`, and valid one-month timestamps. It skips unrelated files, symlinks, unknown formats and invalid expiry metadata; unreadable or malformed JSON files are reported as errors and retained. It does not recurse. In delete mode it rereads each expired file and leaves it alone if its contents changed. It reports every removed file and exits unsuccessfully on errors. Investigate errors before continuing the cleanup workflow.

Run collection when starting a skill cleanup session. There is no scheduled job; an expired file remains on disk until the collector next runs. Do not use a broad age-based `find -delete` command.
