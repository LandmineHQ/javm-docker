FROM debian:trixie

LABEL maintainer="javm"
LABEL description="JAVM Docker image with pre-installed Java 8/17/21/25"

# Set non-interactive mode and timezone
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Shanghai

# 显式将默认 Shell 设置为 bash
SHELL ["/bin/bash", "-c"]

# 1. 安装系统依赖（使用 apt 且保留缓存）
RUN apt update && apt install -y --no-install-recommends \
    wget \
    curl \
    vim \
    nano \
    p7zip-full \
    libcurl4 \
    ca-certificates

# 2. 安装 javm
RUN curl -fsSL https://javm.dev/install.sh | bash

# 3. 将 javm 二进制文件加入 PATH
ENV PATH="/root/.local/bin:${PATH}"

# 4. 初始化 shell 环境（追加到 ~/.bashrc，供最终交互式使用）
RUN javm init bash >> ~/.bashrc

# 5. 安装各版本的 Java（依赖前面的 ENV PATH，直接调用 javm 即可）
RUN javm install temurin@8 && \
    javm install temurin@17 && \
    javm install temurin@21 && \
    javm install temurin@25

# 6. 设置默认 Java 版本
RUN javm default temurin@25

# 创建工作目录
RUN mkdir -p /workspace
WORKDIR /workspace

CMD ["bash"]