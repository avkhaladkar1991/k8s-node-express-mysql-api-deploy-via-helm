# Use a newer Node version (e.g., 18 LTS)
FROM node:18-alpine

# Set working directory
WORKDIR /app

# Copy package.json and yarn.lock first for caching
COPY package.json yarn.lock ./

# Install global packages and dependencies
RUN npm install -g yarn forever --force && \
    yarn install --production --force

# Copy application code
COPY ./ ./

# Use non-root user
USER node

# Expose port
EXPOSE 8080

# Start app with forever
CMD ["forever", "server.js"]
