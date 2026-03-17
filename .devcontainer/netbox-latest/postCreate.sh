#!/usr/bin/env bash
set -euo pipefail

# Update package index and install linux useful Linix packages
sudo apt-get update
sudo apt-get install -y curl jq git htop btop eza

# Clone official nautobot repo
mkdir git && cd git 
git clone https://github.com/netbox-community/netbox-docker.git
cd netbox-docker

# Modify docker files
cat > docker-compose.override.yml << 'EOF'
services:
  netbox:
    image: netbox:latest-plugins
    pull_policy: never
    ports:
      - "8000:8080"
    # If you want the Nginx unit status page visible from the
    # outside of the container add the following port mapping:
    # - "8001:8081"
    build:
      context: .
      dockerfile: Dockerfile-Plugins
  netbox-worker:
    image: netbox:latest-plugins
    pull_policy: never
    healthcheck:
      # Time for which the health check can fail after the container is started.
      # This depends mostly on the performance of your database. On the first start,
      # when all tables need to be created the start_period should be higher than on
      # subsequent starts. For the first start after major version upgrades of NetBox
      # the start_period might also need to be set higher.
      # Default value in our docker-compose.yml is 60s
      start_period: 300s
    environment:
      SKIP_SUPERUSER: "false"
      SUPERUSER_API_TOKEN: "aaa"
      SUPERUSER_EMAIL: "netbox@local.com"
      SUPERUSER_NAME: "netbox"
      SUPERUSER_PASSWORD: "pdEpsCzU9K8D!"
      
EOF

cat > Dockerfile-Plugins << 'EOF'
FROM netboxcommunity/netbox:latest

COPY ./plugin_requirements.txt /opt/netbox/
RUN /usr/local/bin/uv pip install -r /opt/netbox/plugin_requirements.txt

# These lines are only required if your plugin has its own static files.
COPY configuration/configuration.py /etc/netbox/config/configuration.py
COPY configuration/plugins.py /etc/netbox/config/plugins.py
RUN DEBUG="true" SECRET_KEY="dummydummydummydummydummydummydummydummydummydummy" \
    /opt/netbox/venv/bin/python /opt/netbox/netbox/manage.py collectstatic --no-input
EOF

cat > /plugin_requirements.txt << 'EOF'
netbox-secrets
netboxlabs-netbox-branching
netbox-documents
netbox-attachments
netbox-topology-views
nb-service
netbox-floorplan-plugin
netbox-config-diff

EOF

cat > configuration/plugins.py << 'EOF'
# Add your plugins and plugin settings here.
# Of course uncomment this file out.

# To learn how to build images with your required plugins
# See https://github.com/netbox-community/netbox-docker/wiki/Using-Netbox-Plugins

# PLUGINS = ["netbox_bgp"]

# PLUGINS_CONFIG = {
#   "netbox_bgp": {
#     ADD YOUR SETTINGS HERE
#   }
# }
PLUGINS = ["netbox_secrets"]
PLUGINS = ["netbox_branching"]
PLUGINS = ["netbox_documents"]
PLUGINS = ['netbox_attachments']
PLUGINS = ["netbox_topology_views"]
PLUGINS = ['nb_service']
PLUGINS = ['netbox_floorplan']
PLUGINS = ["netbox_config_diff"]

PLUGINS_CONFIG = {
  "netbox_config_diff": {
    "USERNAME": "foo",
    "PASSWORD": "bar",
    "AUTH_SECONDARY": "foobar",        # (optional)
    "PATH_TO_SSH_CONFIG_FILE": "/home/.ssh/config"  # (optional)
  }
}

EOF

cat >> configuration/configuration.py << 'EOF'

from netbox_branching.utilities import DynamicSchemaDict

DATABASES = DynamicSchemaDict({
    'default': {
        'ENGINE': 'django.db.backends.postgresql',
        'NAME': 'netbox',               # Database name
        'USER': 'netbox',               # PostgreSQL username
        'PASSWORD': 'J5brHrAXFLQSif0K', # PostgreSQL password
        'HOST': 'postgres',             # Database server
        'PORT': '',                     # Database port (leave blank for default)
        'CONN_MAX_AGE': 300,            # Max database connection age
    }
})

DATABASE_ROUTERS = [
    'netbox_branching.database.BranchAwareRouter',
]

EOF

docker compose up -d
docker ps
echo "sleep 60..."
sleep 60
docker ps
echo "sleep 60..."
sleep 60
docker ps
echo "sleep 60..."
sleep 60
docker ps
