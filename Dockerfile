FROM alpine:3.20

LABEL maintainer="javm"
LABEL description="A simple Docker hello-world example"

# Install basic tools
RUN apk add --no-cache bash

# Copy the entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
