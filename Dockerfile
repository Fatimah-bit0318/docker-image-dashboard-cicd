# Use an official lightweight Python image
FROM python:3.12-slim

# Build-time metadata received from GitHub Actions
ARG APP_VERSION
ARG BUILD_NUMBER
ARG IMAGE_TAG
ARG GIT_COMMIT

# Store build metadata inside the image as runtime environment variables
ENV APP_VERSION=${APP_VERSION}
ENV BUILD_NUMBER=${BUILD_NUMBER}
ENV IMAGE_TAG=${IMAGE_TAG}
ENV GIT_COMMIT=${GIT_COMMIT}

# Set working directory
WORKDIR /app

# Copy dependency file first for Docker layer caching
COPY requirements.txt .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy application files
COPY . .

# Flask/Gunicorn application port
EXPOSE 5000

# Start application
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app"]
