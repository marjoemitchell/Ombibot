FROM ruby:3.2-slim

WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    && rm -rf /var/lib/apt/lists/*

# Copy Gemfile and Gemfile.lock
COPY Gemfile Gemfile.lock ./

# Install gems
RUN gem install bundler && bundle install

# Copy application code
COPY . .

# Set permissions for Unraid's 'nobody' user (100:99)
RUN chown -R nobody:users /app

USER nobody

# Expose default port
EXPOSE 3000

# Start the application directly with Puma so container respects the PORT env variable.
# Foreman injects its own PORT mappings (starting at 5000) which can conflict with Docker/Unraid.
# Use a shell form so ${PORT:-3000} is expanded from the container environment.
CMD ["sh", "-lc", "bundle exec puma -p ${PORT:-3000}"]
