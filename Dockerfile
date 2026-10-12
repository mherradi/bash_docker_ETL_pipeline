FROM alpine:3.22

# Install Bash and utilities used by our script without caching the index to reduce image size
RUN apk add --no-cache bash coreutils grep gawk

WORKDIR /app

# Copy our Bash script into the image 
COPY processing.sh /app/processing.sh

# Make the script executable under Linux Bash environment
RUN chmod +x /app/processing.sh

# Run the script in a loop to keep the container running
CMD ["sh" , "-c" , "while true; do /app/processing.sh; sleep 10; done"]
