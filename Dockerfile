# Stage 1: Builder
FROM node:20-alpine AS builder

# Update global npm to fix vulnerabilities
RUN npm install -g npm@latest

WORKDIR /app

# Copy package definition first for better cache utilization
COPY package*.json ./

# Install dependencies (including dev deps for testing if needed during build, 
# though usually we only want prod deps for the final image. 
# Here we install all to run tests in build stage if we wanted, but we'll prune later)
# Install dependencies
RUN npm install

# Copy source code
COPY . .

# (Optional) Run build scripts if this were a frontend app
# RUN npm run build

# Stage 2: Production Runner
FROM node:20-alpine AS runner

# Update global npm to fix vulnerabilities
RUN npm install -g npm@latest

WORKDIR /app

# Set production environment
ENV NODE_ENV=production

# Create a non-root user for security
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Copy only production dependencies from builder
COPY --from=builder /app/package*.json ./
RUN npm install --only=production && npm cache clean --force

# Copy application source code
COPY --from=builder /app/app.js ./
# COPY --from=builder /app/public ./public  <-- if we had static assets

# Chown files to non-root user
RUN chown -R appuser:appgroup /app

# Switch to non-root user
USER appuser

# Expose the application port
EXPOSE 3000

# Start the application
CMD ["node", "app.js"]
