#!/usr/bin/env bash
set -euo pipefail

echo "logs:/workspaces/.codespaces/.persistedshare" > nautobot-only.txt
echo "eval "$(poetry env activate)"" >> nautobot-only.txt
echo "invoke stop && invoke start" >> nautobot-only.txt
echo "User=admin / Password=admin" >> nautobot-only.txt
echo "docker exec -it nautobot_docker_compose-nautobot-1 nautobot-server createsuperuser" >> nautobot-only.txt


# URLs (Codespaces auto-forwards)
echo "Nautobot UI: http://localhost:8082"
echo "Nautobot Login User=admin / Password=admin"
