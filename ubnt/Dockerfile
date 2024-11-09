FROM ubuntu:jammy

# Update and install necessary packages
RUN apt-get update && \
    apt-get install -y curl vim && \
    apt-get clean

# Set the default working directory
WORKDIR /app

# Copy any files (if needed)
# COPY . /app

# Set a default command (you can override this in docker-compose.yml)
CMD ["bash"]
