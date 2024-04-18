# Use the official Redis image as the base image
FROM redis:latest

# Use the official Python 3 image as a secondary stage
FROM python:3

# Copy Python dependencies from the Python stage to the current stage
COPY --from=0 /usr/local/bin/redis* /usr/local/bin/
COPY --from=0 /usr/local/lib/python3.*/dist-packages/ /usr/local/lib/python3.*/dist-packages/

# Set the working directory
WORKDIR /app

# Copy your Python code into the container
COPY . /app

# Install Python dependencies
RUN pip install redis

# Expose the Redis port
EXPOSE 6379

