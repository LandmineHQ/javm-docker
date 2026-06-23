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

# Install javm
RUN curl -fsSL https://javm.dev/install.sh | bash

# Add javm to PATH and configure shell integration
ENV PATH="/root/.local/bin:${PATH}"
RUN echo 'eval "$(javm init bash)"' >> /root/.bashrc

# Pre-install Java versions using Temurin
RUN javm install temurin@8 && \
    javm install temurin@17 && \
    javm install temurin@21 && \
    javm install temurin@25

# Set Java 25 as default
RUN javm default temurin@25

# Create workspace
RUN mkdir -p /workspace
WORKDIR /workspace

CMD ["bash"]
