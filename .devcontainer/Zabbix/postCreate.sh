#!/usr/bin/env bash
set -euo pipefail

sudo apt-get update
sudo apt-get install -y curl jq git htop btop eza

# Clone zabbix repos
mkdir -p git
cd git
git clone https://github.com/zabbix/zabbix-docker.git
