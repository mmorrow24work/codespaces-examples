#!/usr/bin/env bash
set -euo pipefail

echo "logs:/workspaces/.codespaces/.persistedshare" > netbox-only.txt
echo "eval '$(poetry env activate)'" >> netbox-only.txt
echo "invoke stop && invoke start" >> netbox-only.txt
echo "User=admin / Password=admin" >> netbox-only.txt
echo "docker exec -it nautobot_docker_compose-nautobot-1 nautobot-server createsuperuser" >> netbox-only.txt


# URLs (Codespaces auto-forwards)
echo "Netbox UI: http://localhost:8080"
echo "Netbox Login User=admin / Password=admin"
