FROM ubuntu:24.04

LABEL maintainer="javm"
LABEL description="JAVM Docker image with pre-installed Java 8/17/21/25 on Ubuntu 24.04"

# Set non-interactive mode, timezone, and locale (fixes htop character display issues)
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Shanghai
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8

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
    ca-certificates \
    ncurses-term

# 2. 安装 javm
RUN curl -fsSL https://javm.dev/install.sh | bash

# 3. 将 javm 二进制文件加入 PATH
ENV PATH="/root/.local/bin:${PATH}"

# 4. 生成非交互式 shell 集成脚本（仅定义 javm 函数，不自动切换默认版本）
#    交互式 shell（docker run -it）：由安装脚本自动写入的 ~/.bashrc 负责
#    非交互式 shell（bash -c）：由 BASH_ENV 指向此脚本负责
RUN javm init bash | grep -v '^javm use' > /etc/profile.d/javm.sh
ENV BASH_ENV="/etc/profile.d/javm.sh"

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