#!/usr/bin/env bash
set -euo pipefail

# Pre-fix for Containerlab: ensure sshd_config exists and skip SSH mods

echo "logs:/workspaces/.codespaces/.persistedshare" >> zabbix.txt
echo "Zabbix Login User=Admin / Password=zabbix" >> zabbix.txt

# Start Zabbix stack
echo "*** Start Zabbix stack ***********************************************************************************************************"
cd git/zabbix-docker
docker compose \
  -f docker-compose_v3_alpine_mysql_snmptraps_latest.yaml \
  -f docker-compose.override.yml \
  up -d
echo "*** Complete Zabbix stack ***********************************************************************************************************"

# URLs (Codespaces auto-forwards)
echo "Zabbix UI: http://localhost:80 (or forwarded port)"
echo "Zabbix Login User=Admin / Password=zabbix"
