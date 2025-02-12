   # Use an official lightweight Python image
   FROM python:3.10-slim

   # Set environment variables
   ENV PYTHONDONTWRITEBYTECODE=1
   ENV PYTHONUNBUFFERED=1

   # Set working directory
   WORKDIR /app

   # Install dependencies
   COPY requirements.txt .
   RUN pip install --upgrade pip
   RUN pip install -r requirements.txt

   # Install Nginx and Supervisor
   RUN apt-get update && apt-get install -y nginx supervisor

   # Copy project files
   COPY . .

   # Copy Nginx configuration file
   COPY nginx.conf /etc/nginx/nginx.conf

   # Copy Supervisor configuration file
   COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

   # Expose ports
   EXPOSE 80 8000

   # Start Supervisor
   CMD ["supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]