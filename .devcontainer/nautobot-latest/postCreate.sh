#!/usr/bin/env bash
set -euo pipefail

sudo apt-get update
sudo apt-get install -y curl jq git htop btop eza
# Clone official repo
mkdir git && cd git 
git clone https://github.com/nautobot/nautobot-docker-compose.git
cd nautobot-docker-compose

# Copy env files
cp environments/creds.example.env environments/creds.env
cp environments/local.example.env environments/local.env

curl -sSL https://install.python-poetry.org | python3 -
export PATH="$HOME/.local/bin:$PATH"  # Ensure if needed
poetry install # Installed Nautobot + Invoke + 100+ dependencies
eval "$(poetry env activate)"  # Activates current shell (prints source command for eval)
invoke build
invoke start
