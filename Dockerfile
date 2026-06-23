FROM debian:trixie

LABEL maintainer="javm"
LABEL description="JAVM Docker image with pre-installed Java 8/17/21/25"

# Set non-interactive mode and timezone
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Shanghai

# Install system packages
RUN apt-get update && apt-get install -y \
    wget \
    curl \
    vim \
    nano \
    p7zip-full \
    libcurl4 \
    ca-certificates

# Install javm (install script automatically configures .bashrc)
RUN curl -fsSL https://javm.dev/install.sh | bash

# Add javm binary to PATH for subsequent RUN commands
# (RUN uses /bin/sh which doesn't source .bashrc)
ENV PATH="/root/.local/bin:${PATH}"

# Pre-install Java versions using Temurin
RUN javm install temurin@8 && \
    javm install temurin@17 && \
    javm install temurin@21 && \
    javm install temurin@25

# Set Java 25 as default
RUN javm default temurin@25

# Generate non-interactive shell integration script (without auto-use default)
# This enables "javm use" in bash -c and scripts without resetting version in child shells
RUN javm init bash | grep -v '^javm use' > /etc/profile.d/javm.sh

# Enable javm function in non-interactive bash (bash -c, entrypoint scripts)
ENV BASH_ENV="/etc/profile.d/javm.sh"

# Create workspace
RUN mkdir -p /workspace
WORKDIR /workspace

CMD ["bash"]
