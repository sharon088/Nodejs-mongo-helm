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
COPY --from=build /app/node_modules ./node_modules

# Copy application files
COPY --from=build /app/devops-assignment-index.html ./
COPY --from=build /app/docker-test.js ./
COPY --from=build /app/package*.json ./
COPY --from=build /app/k8s-test.js ./

# Copy script file
COPY --from=build /app/start.sh ./

#make executable and give permissions to appuser
RUN chmod +x start.sh
RUN chown appuser:appuser start.sh

# Switch to the created user
USER appuser

# Expose the port the app runs on
EXPOSE 8080

# Command to run the application
CMD ["/app/start.sh"]
