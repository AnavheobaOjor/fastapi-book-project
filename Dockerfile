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

   # Install Nginx
   RUN apt-get update && apt-get install -y nginx

   # Copy project files
   COPY . .

   # Copy Nginx configuration file
   COPY nginx.conf /etc/nginx/nginx.conf

   # Expose ports
   EXPOSE 80 8000

   # Start Nginx and the FastAPI application
   CMD service nginx start && uvicorn main:app --host 0.0.0.0 --port 8000