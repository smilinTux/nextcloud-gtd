#!/bin/bash
# nextcloud-gtd skill install script
# Installs automated GTD file management for SKHub

set -e

echo "🐧 Installing nextcloud-gtd skill..."
echo "===================================="

# Check if running in openclaw context
if ! command -v openclaw &> /dev/null; then
    echo "❌ Error: openclaw not found. Is this an OpenClaw environment?"
    exit 1
fi

# Create config directory
CONFIG_DIR="$HOME/.openclaw/config"
mkdir -p "$CONFIG_DIR"

# Install skill reference
SKILL_DIR="$(dirname "$(realpath "$0")")"
echo "📁 Skill directory: $SKILL_DIR"

# Check for existing config
if [ -f "$CONFIG_DIR/nextcloud-gtd.json" ]; then
    echo "⚠️ Config already exists at $CONFIG_DIR/nextcloud-gtd.json"
    read -p "Overwrite? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "⏭️ Skipping config creation"
        exit 0
    fi
fi

# Create default config
echo "📝 Creating default configuration..."
cat > "$CONFIG_DIR/nextcloud-gtd.json" << 'EOF'
{
  "base_url": "https://skhub.skstack01.douno.it",
  "team_folder": "/AI-Agents-Shared",
  "credentials": {
    "username": "YOUR_USERNAME",
    "app_password": "GET_FROM_NEXTCLOUD_SETTINGS"
  },
  "agents": {
    "vesper": {
      "role": "triage",
      "permissions": ["read", "write", "move", "delete"],
      "auto_process": true
    }
  },
  "naming_conventions": {
    "date_format": "YYYY-MM-DD",
    "separator": "_",
    "status_tags": ["_DRAFT", "_REVIEW", "_FINAL", "_DONE"]
  },
  "triage_rules": {
    "keywords": {
      "trust": "03_PROJECTS/S&K_Holdings/",
      "SKGentis": "03_PROJECTS/SKGentis/",
      "legal": "04_REFERENCE/Legal_Docs/",
      "TODO": "02_ACTIONS/In_Progress/",
      "research": "04_REFERENCE/Research/"
    }
  }
}
EOF

echo "✅ Config created at: $CONFIG_DIR/nextcloud-gtd.json"
echo ""
echo "⚠️ IMPORTANT: Edit the config to add your Nextcloud credentials!"
echo ""
echo "To get your app password:"
echo "1. Login to https://skhub.skstack01.douno.it"
echo "2. Settings → Personal → Security"
echo "3. Create new app password"
echo "4. Copy to config file"
echo ""
echo "🎯 Next steps:"
echo "   openclaw config set skills.nextcloud-gtd.enabled true"
echo "   nc-gtd test-connection"
echo ""
echo "🐧 nextcloud-gtd installed! Ready for GTD magic."
