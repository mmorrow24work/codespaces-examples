#!/usr/bin/env bash
set -euo pipefail

# Update package index and install linux useful Linix packages
sudo apt-get update
sudo apt-get install -y curl jq git htop btop eza

# Clone official nautobot repo
mkdir git && cd git 
git clone https://github.com/nautobot/nautobot-docker-compose.git
cd nautobot-docker-compose

# Modify env files
cat > environments/creds.env << 'EOF'
NAUTOBOT_CREATE_SUPERUSER=true
NAUTOBOT_DB_PASSWORD=nautobot123
NAUTOBOT_NAPALM_USERNAME=''
NAUTOBOT_NAPALM_PASSWORD=''
NAUTOBOT_REDIS_PASSWORD=redis123
NAUTOBOT_SECRET_KEY=012345678901234567890123456789012345678901234567890123456789
NAUTOBOT_SUPERUSER_NAME=admin
NAUTOBOT_SUPERUSER_EMAIL=admin@example.com
NAUTOBOT_SUPERUSER_PASSWORD=admin
# API token length must be exactly 40 characters
NAUTOBOT_SUPERUSER_API_TOKEN=0123456789abcdef0123456789abcdef01234567

NAUTOBOT_CACHEOPS_REDIS=redis://:${NAUTOBOT_REDIS_PASSWORD}@redis:6379/1

# Postgres
POSTGRES_PASSWORD=${NAUTOBOT_DB_PASSWORD}
PGPASSWORD=${NAUTOBOT_DB_PASSWORD}

# MySQL
MYSQL_PASSWORD=${NAUTOBOT_DB_PASSWORD}
MYSQL_ROOT_PASSWORD=${NAUTOBOT_DB_PASSWORD}

# REDIS
REDIS_PASSWORD=${NAUTOBOT_REDIS_PASSWORD}
EOF

cat > environments/local.env << 'EOF'
# This should be limited to the hosts that are going to be the web app.
# https://docs.djangoproject.com/en/3.2/ref/settings/#allowed-hosts
NAUTOBOT_ALLOWED_HOSTS=*
NAUTOBOT_BANNER_TOP="Local"
NAUTOBOT_CHANGELOG_RETENTION=0
NAUTOBOT_CONFIG=/opt/nautobot/nautobot_config.py
NAUTOBOT_DB_HOST=db
NAUTOBOT_DB_NAME=nautobot
NAUTOBOT_DB_USER=nautobot
NAUTOBOT_DEBUG=True
NAUTOBOT_DJANGO_EXTENSIONS_ENABLED=False
NAUTOBOT_DJANGO_TOOLBAR_ENABLED=False
NAUTOBOT_HIDE_RESTRICTED_UI=True
NAUTOBOT_LOG_LEVEL=WARNING
NAUTOBOT_METRICS_ENABLED=True
NAUTOBOT_NAPALM_TIMEOUT=5
NAUTOBOT_MAX_PAGE_SIZE=0

# Postgres Container
POSTGRES_USER=${NAUTOBOT_DB_USER}
POSTGRES_DB=${NAUTOBOT_DB_NAME}

# NAUTOBOT REDIS SETTINGS
# When updating NAUTOBOT_REDIS_PASSWORD, make sure to update the password in
# the NAUTOBOT_CACHEOPS_REDIS line as well!
#
NAUTOBOT_REDIS_HOST=redis
NAUTOBOT_REDIS_PORT=6379
# Uncomment REDIS_SSL if using SSL
# NAUTOBOT_REDIS_SSL=True

# Needed for MySQL, should match the values for Nautobot above
MYSQL_USER=nautobot
MYSQL_DATABASE=nautobot

# LDAP environment variables
NAUTOBOT_AUTH_LDAP_SERVER_URI="changeme"
NAUTOBOT_AUTH_LDAP_BIND_DN="changeme"
NAUTOBOT_AUTH_LDAP_BIND_PASSWORD="changeme"
EOF

# Install NAUTOBOT 
curl -sSL https://install.python-poetry.org | python3 -
export PATH="$HOME/.local/bin:$PATH"  # Ensure if needed
poetry install # Installed Nautobot + Invoke + 100+ dependencies
eval "$(poetry env activate)"  # Activates current shell (prints source command for eval)
invoke build
invoke start
