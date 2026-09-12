#!/usr/bin/env python3
"""Preview expired skill backups; pass --delete to remove recognized expired files."""
from __future__ import annotations

import argparse
import calendar
import hashlib
import json
import os
import re
import stat
import sys
from datetime import datetime, timezone
from pathlib import Path
from typing import Any

KIND = "anki-cloze-context-backup/v1"
NAME = re.compile(r"backup-\d{8}T\d{6}(?:\d{1,6})?Z\.json\Z")


def expires_at(created: datetime) -> datetime:
    """One calendar month in UTC; clamp the day to the destination month."""
    utc = created.astimezone(timezone.utc)
    year, month = (utc.year + 1, 1) if utc.month == 12 else (utc.year, utc.month + 1)
    return utc.replace(year=year, month=month, day=min(utc.day, calendar.monthrange(year, month)[1]))


def parse_timestamp(value: object) -> datetime | str:
    if not isinstance(value, str):
        return "Timestamp must be an ISO string with a timezone"
    try:
        parsed = datetime.fromisoformat(value.replace("Z", "+00:00"))
        if parsed.tzinfo is None:
            return "Timestamp has no timezone"
        return parsed.astimezone(timezone.utc)
    except (ValueError, OverflowError):
        return "Invalid timestamp"


def backup_expiry(value: object) -> datetime | str:
    if not isinstance(value, dict) or value.get("kind") != KIND:
        return "Unrecognized backup format"
    created, expiry = parse_timestamp(value.get("createdAt")), parse_timestamp(value.get("expiresAt"))
    if isinstance(created, str) or isinstance(expiry, str):
        return "Missing or invalid backup timestamps"
    if created.year == 9999:
        return "Creation date is out of range"
    if expiry != expires_at(created):
        return "Expiry must be exactly one calendar month after creation"
    return expiry


def read_regular_file(path: Path) -> bytes:
    """Do not follow a file symlink, including one swapped in during the read."""
    descriptor = os.open(path, os.O_RDONLY | os.O_NOFOLLOW | os.O_NONBLOCK)
    with os.fdopen(descriptor, "rb") as stream:
        if not stat.S_ISREG(os.fstat(stream.fileno()).st_mode):
            raise ValueError("Not a regular file")
        return stream.read()


def collect(directory: Path, now: datetime, delete: bool) -> dict[str, Any]:
    report: dict[str, Any] = {"directory": str(directory.absolute()), "mode": "delete" if delete else "preview",
                              "checkedAt": now.isoformat(), "expired": [], "retained": [], "skipped": [], "deleted": [], "errors": []}
    if directory.is_symlink():
        raise ValueError("Backup directory must be a real directory, not a symlink")
    if not directory.exists():
        return report
    if not directory.is_dir():
        raise ValueError("Backup path is not a directory")
    # Filesystem operations are sequenced; no recursion or wildcard deletion.
    for path in sorted(directory.iterdir()):
        if path.is_symlink() or not NAME.fullmatch(path.name) or not path.is_file():
            report["skipped"].append({"file": path.name, "reason": "not_a_managed_backup"})
            continue
        try:
            raw = read_regular_file(path)
            expiry = backup_expiry(json.loads(raw))
            if isinstance(expiry, str):
                report["skipped"].append({"file": path.name, "reason": expiry})
                continue
            if now < expiry:
                report["retained"].append(path.name)
                continue
            report["expired"].append({"file": path.name, "expiresAt": expiry.isoformat()})
            if delete:
                if hashlib.sha256(read_regular_file(path)).digest() != hashlib.sha256(raw).digest():
                    report["errors"].append({"file": path.name, "reason": "changed_since_inspection"})
                    continue
                path.unlink()
                report["deleted"].append(path.name)
        except (OSError, ValueError) as error:
            report["errors"].append({"file": path.name, "reason": str(error)})
    return report


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    # Keep the invoked path: Stow links scripts individually; resolve() would
    # redirect runtime backups into the source repository.
    parser.add_argument("--backup-dir", type=Path, default=Path(__file__).absolute().parent.parent / "backups")
    parser.add_argument("--delete", action="store_true", help="Delete only recognized backups that have expired")
    args = parser.parse_args()
    try:
        report = collect(args.backup_dir, datetime.now(timezone.utc), args.delete)
        print(json.dumps(report, ensure_ascii=False, indent=2))
        return 1 if report["errors"] else 0
    except (OSError, ValueError) as error:
        print(f"Error: {error}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
