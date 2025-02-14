FROM python:3.10-slim

WORKDIR /app

# Install system dependencies
RUN apt-get update && \
    apt-get install -y nginx supervisor gettext-base curl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /tmp/nginx

# Add configuration to preserve headers
RUN echo 'proxy_set_header Host $host;' >> /etc/nginx/proxy_params && \
    echo 'proxy_set_header X-Real-IP $remote_addr;' >> /etc/nginx/proxy_params && \
    echo 'proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;' >> /etc/nginx/proxy_params && \
    echo 'proxy_set_header X-Forwarded-Proto $scheme;' >> /etc/nginx/proxy_params

# Copy requirements and install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY . .

# Setup Nginx
COPY nginx.conf /etc/nginx/nginx.conf
COPY conf.d/default.template.conf /etc/nginx/conf.d/default.template.conf

# Setup Supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Copy and set permissions for entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Create required directories and set permissions
RUN mkdir -p /tmp/nginx && \
    chown -R www-data:www-data /tmp/nginx && \
    chown -R www-data:www-data /var/log/nginx && \
    chown -R www-data:www-data /var/lib/nginx

# Expose the port
EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:8080/healthcheck || exit 1

CMD ["/entrypoint.sh"]