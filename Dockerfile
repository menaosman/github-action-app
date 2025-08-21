# --- Production-ready minimal Dockerfile (Node.js) ---
# Use an LTS, small base image
FROM node:20-alpine

# Create app directory
WORKDIR /app

# Install dependencies first (better layer caching)
COPY package*.json ./
# If you have a lockfile, npm ci is preferred; fallback to npm install for safety
RUN npm ci --only=production || npm install --only=production

# Copy the rest of the app
COPY . .

# Set default port (your app should respect the PORT env)
ENV PORT=3000
EXPOSE 3000

# If your package.json has "start", this will run it
CMD ["npm", "start"]
