# Use an official Python image
FROM python:3.12-slim

# Set the working directory
WORKDIR /app

# Copy dependency file
COPY requirements.txt .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy application files
COPY . .

# Expose application port
EXPOSE 5000

# Start the application
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app"]
