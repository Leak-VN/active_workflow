FROM docker.io/ruby:2.7.8-slim-bullseye

# Copy script to prepare the operating system
COPY docker/scripts/prepare_os /scripts/
RUN /scripts/prepare_os

# Install dependencies, including the V8 development headers
RUN apt-get update && apt-get install -y \
    build-essential \
    libv8-dev
    # Add any other dependencies here

# Create a volume for PostgreSQL data
VOLUME /var/lib/postgresql/11/main

# Set the working directory
WORKDIR /app

# Copy the application code into the container
COPY --chown=active_workflow ./ /app/

# Run the script to prepare the application
WORKDIR /app/docker/scripts
RUN  chmod +x prepare_app \
    && ./prepare_app

# Expose port 3000
WORKDIR /app
EXPOSE 3000

# Copy initialization script
COPY docker/scripts/init /scripts/

# Set the entry point for the container
ENTRYPOINT ["tini", "--", "/app/docker/scripts/entrypoint"]
