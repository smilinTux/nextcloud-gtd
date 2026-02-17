# nextcloud-gtd - GTD File & Folder Management for SKHub

Automated Getting Things Done workflow for Nextcloud on GentisTrust SKHub.

## Overview

This skill provides agents with automated file organization, triage, and GTD workflow management for team collaboration on Nextcloud.

## Installation

```bash
openclaw skill add nextcloud-gtd
```

## Configuration

Edit `~/.openclaw/config/nextcloud-gtd.json`:

```json
{
  "base_url": "https://skhub.skstack01.douno.it",
  "team_folder": "/AI-Agents-Shared",
  "credentials": {
    "username": "lumina",
    "app_password": "from_nextcloud_settings"
  },
  "agents": {
    "vesper": {
      "role": "triage",
      "permissions": ["read", "write", "move", "delete"],
      "auto_process": true
    },
    "piper": {
      "role": "marketing",
      "permissions": ["read", "write"],
      "auto_process": false
    }
  },
  "naming_conventions": {
    "date_format": "YYYY-MM-DD",
    "separator": "_",
    "status_tags": ["_DRAFT", "_REVIEW", "_FINAL", "_DONE"]
  }
}
```

## Usage

### Manual Commands

```bash
# Sort all files in INBOX
nc-gtd triage --source 01_INBOX --auto-classify

# Move completed items to archive
nc-gtd archive --older-than 7d --status _DONE

# Generate weekly summary report
nc-gtd report --type weekly --to telegram:#ai-agents-shared

# Sync with SKVector for semantic search
nc-gtd sync --index-all --verbose
```

### Automated Workflows (Vesper)

```bash
# Run as cron - daily INBOX processing
nc-gtd triage --source 01_INBOX --auto-classify --notify-admins

# Weekly archive sweep
nc-gtd archive --status _DONE --older-than 7d --move-to 05_ARCHIVE

# Monthly compliance report
nc-gtd report --type monthly --format markdown --save-to 99_ADMIN/
```

## Triage Logic

Vesper auto-sorts based on:

| Document Type | Keywords | Destination |
|--------------|----------|-------------|
| Trust docs | "trust", "UCC", "affidavit", "VSOF" | 03_PROJECTS/S&K_Holdings/ |
| Business | "SKGentis", "revenue", "DeFi", "trade" | 03_PROJECTS/SKGentis/ |
| Legal | "contract", "agreement", "signature" | 04_REFERENCE/Legal_Docs/ |
| Personal | "family", "birthday", "health" | (private Chef folder) |
| Action items | "TODO", "URGENT", "deadline" | 02_ACTIONS/In_Progress/ |
| Research | "article", "paper", "study" | 04_REFERENCE/Research/ |

## Agent-Specific Behaviors

### Vesper (Legal/Admin)
- Daily INBOX scan
- Auto-classification
- Legal document routing
- Weekly summary reports
- Compliance tracking

### Piper (Marketing)
- Monitor 03_PROJECTS for public content
- Draft marketing materials in relevant folders
- Tag completed work _REVIEW
- Never touches sensitive/legal docs

### Dev-Beta (Technical)
- Ingest all docs to SKVector
- Maintain search index
- Sync SKGraph relationships
- Archive old versions

## Status Tag Meanings

| Tag | Meaning | Next Action |
|-----|---------|-------------|
| `_DRAFT` | Work in progress | Continue editing |
| `_REVIEW` | Ready for team | Wait for feedback |
| `_FINAL` | Approved | Archive when complete |
| `_DONE` | Complete | Archive now |

## Requirements

- Nextcloud app password (not regular password!)
- WebDAV access enabled
- SKVector (Qdrant) for semantic search
- SKGraph (FalkorDB) for relationship mapping

## Troubleshooting

```bash
# Test connection
nc-gtd test-connection

# Check folder permissions
nc-gtd verify-permissions --user vesper

# Manual sync if auto fails
nc-gtd sync --force --verbose
```

## Related Skills

- `ez-google` - Google Workspace integration
- `agent-browser` - Web automation
- `skmemory-sync` - Vector database sync

## Credits

- GTD methodology by David Allen
- Adapted for AI-Agent teams by Lumina
- For Chef, JZ, Luna — the sovereign stack

"Getting Things Done — with penguins!" 🐧✨
