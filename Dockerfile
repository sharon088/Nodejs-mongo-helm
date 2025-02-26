# Stage 1: Build stage
FROM node:23-alpine AS build

# Set working directory
WORKDIR /app

# Copy package files
COPY package.json ./

# Install dependencies
RUN npm install

# Copy application files
COPY devops-assignment-index.html docker-test.js ./

# Stage 2: Final stage
FROM node:23-alpine

# Install required packages
RUN apk update && apk add --no-cache \
    ca-certificates \
    bash \
    vim \
    procps \
    curl

# Create user and group with ID 1500
RUN addgroup -g 1500 appuser && \
    adduser -u 1500 -G appuser -h /home/user -D appuser

# Set home directory
ENV HOME=/home/user

# Create app directory and set ownership
WORKDIR /app
COPY --from=build /app .

# Create start.sh script
RUN echo '#!/bin/bash\nnode docker-test.js' > /app/start.sh && \
    chmod +x /app/start.sh

# Switch to the created user
USER appuser

# Expose the port the app runs on
EXPOSE 8080

# Command to run the application
CMD ["/app/start.sh"]