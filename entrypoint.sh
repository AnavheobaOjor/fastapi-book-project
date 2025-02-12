#!/bin/sh

# Ensure PORT is set
PORT="${PORT:-8080}"
echo "PORT is set to $PORT"

# Create nginx configuration from template
envsubst '$PORT' < /etc/nginx/conf.d/default.template.conf > /etc/nginx/conf.d/default.conf

# Remove the template to prevent Nginx from including it
rm /etc/nginx/conf.d/default.template.conf

# Display the generated configs for debugging
echo "Generated default.conf:"
cat /etc/nginx/conf.d/default.conf

# Test nginx configuration
nginx -t

# Start supervisord
exec supervisord -c /etc/supervisor/conf.d/supervisord.conf