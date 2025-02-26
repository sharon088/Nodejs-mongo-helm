# Stage 1: Build stage
FROM node:23-alpine AS build

# Set working directory
WORKDIR /app

# Copy package files
COPY package.json ./

# Install dependencies
RUN npm install

# Copy application files
COPY . ./

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

# Create app directory and set ownership
WORKDIR /app

# Set home directory
ENV HOME=/home/appuser

# Copy node_modules
COPY --from=builder /app/node_modules ./node_modules

# Copy application files
COPY --from=builder /app/devops-assignment-index.html ./
COPY --from=builder /app/docker-test.js ./
COPY --from=builder /app/package*.json ./

# Switch to the created user
USER appuser

COPY start.sh ./
RUN chmod +x start.sh

# Expose the port the app runs on
EXPOSE 8080

# Command to run the application
CMD ["/app/start.sh"]
