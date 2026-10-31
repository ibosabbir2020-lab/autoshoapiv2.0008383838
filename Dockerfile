FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Install system dependencies for curl_cffi (gcc, make, libcurl-dev)
RUN apt-get update && apt-get install -y \
    gcc \
    g++ \
    make \
    libcurl4-openssl-dev \
    pkg-config \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements first to leverage Docker cache
COPY requirements.txt .

# Install Python dependencies
# --no-cache-dir saves space in the final image
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application code
COPY . .

# Expose the port your app runs on
EXPOSE 8080

# Command to start the server
# Using uvicorn directly as it's lighter than wrapping in a script for containers
CMD ["uvicorn", "api:app", "--host", "0.0.0.0", "--port", "8080"]