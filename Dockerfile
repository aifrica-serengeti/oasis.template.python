# Use the official lightweight Python 3.11 image
# https://hub.docker.com/_/python
FROM python:3.11-slim

# Allow statements and log messages to immediately appear in the Knative logs
ENV PYTHONUNBUFFERED True

# Install necessary system packages
RUN apt-get update && apt-get install -y \
    build-essential \
    libffi-dev \
    gcc \
    --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory in container
ENV APP_HOME /app
WORKDIR $APP_HOME

# Copy local code to the container image.
COPY . ./

# Install Python dependencies using a PyPI mirror or with extended timeout
RUN pip install --no-cache-dir -r requirements.txt

# Run the web service on container startup using gunicorn
CMD exec gunicorn --bind :$PORT --workers 1 --threads 8 --timeout 0 app:app
