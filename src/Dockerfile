FROM python:3.13-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

# Copy legacy folder from project root to app folder
COPY ../legacy ../legacy

# Make startup script executable
RUN chmod +x start.sh

# Expose ports for both dev (5001) and prod (80)
EXPOSE 5001 80

CMD ["./start.sh"]
