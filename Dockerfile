# Use Node 18 LTS
FROM node:18-alpine

WORKDIR /app

# Copy package.json only
COPY package.json ./

# Install global packages and dependencies
RUN npm install -g yarn forever --force && \
    yarn install --production --force

# Copy application code
COPY ./ ./

# Use non-root user
USER node

EXPOSE 8080

CMD ["forever", "server.js"]
