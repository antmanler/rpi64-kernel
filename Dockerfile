FROM debian:stretch

WORKDIR /workdir
ENV LINUX=/workdir/rpi64-linux \
    TOOLS=/workdir/rpi64-tools \
    RPI_KERNEL_REPO=https://www.github.com/raspberrypi/linux \
    RPI_KERNEL_BRANCH=rpi-4.19.y \
    RPI_TOOLS_REPO=https://github.com/raspberrypi/tools.git \
    RPI_TOOLS_TAG=49719d5544cd33b8c146235e1420f68cd92420fe \
    TIMESTAMP_OUTPUT=true

# Install build dependencies
RUN apt-get update && \
  apt-get install -y bc build-essential curl git-core libncurses5-dev kmod flex bison libssl-dev

# Install crosscompile toolchain for ARM64/aarch64
RUN mkdir -p /opt/linaro && \
    curl -sSL https://releases.linaro.org/components/toolchain/binaries/latest-7/aarch64-linux-gnu/gcc-linaro-7.4.1-2019.02-x86_64_aarch64-linux-gnu.tar.xz | tar xfJ - -C /opt/linaro
ENV CROSS_COMPILE=/opt/linaro/gcc-linaro-7.4.1-2019.02-x86_64_aarch64-linux-gnu/bin/aarch64-linux-gnu-

# Get the Linux kernel 4.19 source
RUN git clone --single-branch --branch $RPI_KERNEL_BRANCH --depth 1 $RPI_KERNEL_REPO $LINUX

# Get the rpi tools
RUN git clone $RPI_TOOLS_REPO $TOOLS \
 && cd $TOOLS \
 && git checkout $RPI_TOOLS_TAG

COPY defconfigs/ /defconfigs/
COPY build-kernel.sh get-kernel-version.sh refresh-repo.sh /
CMD ["/build-kernel.sh"]
