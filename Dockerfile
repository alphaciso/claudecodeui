# Build stage
FROM node:20-alpine AS builder

# Install build dependencies for native modules
RUN apk add --no-cache python3 make g++ gcc libc-dev

# Set working directory
WORKDIR /app

# Copy package files
COPY package*.json ./

# Install all dependencies using npm
RUN npm ci || npm install

# Copy source files
COPY . .

# Build the frontend
RUN npm run build

# Production stage
FROM node:20-alpine

# Install runtime dependencies for native modules
RUN apk add --no-cache python3 make g++ gcc libc-dev

# Set working directory
WORKDIR /app

# Copy package files
COPY package*.json ./

# Install production dependencies and rebuild native modules
RUN npm ci --omit=dev || npm install --omit=dev
RUN npm rebuild bcrypt
RUN npm rebuild better-sqlite3
RUN npm rebuild node-pty

# Copy built frontend from builder stage
COPY --from=builder /app/dist ./dist

# Copy server files
COPY server ./server
COPY .env* ./

# Create necessary directories
RUN mkdir -p /app/data /app/uploads

# Set environment variables
ENV NODE_ENV=production
ENV PORT=3000

# Expose the port
EXPOSE 3000

# Start the server
CMD ["node", "server/index.js"]