FROM ubuntu:latest

RUN apt-get update && \
    apt-get install \
    --yes \
    binutils \
    curl \
    zip

# Install the Raspberry Pi toolchain.
#
# Note that Ubuntu offers a package called `gcc-arm-linux-gnueabihf`; despite the name, that
# compiles only for armv7 and is not suitable for armv6 cross compilation. If you have that
# installed on your machine, please uninstall it first, and then install the one from the official
# raspberry pi tool repository as described here.
#
# There is also a `gcc-arm-linux-gnueabi` package (note the missing `hf`), which does not use the
# FPU and instead relies on software emulation for floating point instructions. In my experience
# this is both slower and also produces some very weird behaviours in some cases where floating
# point computations are required, probably due to bugs in the compiler.
#
# In particular, if you compile with that and try to run the resulting executable on an armv6 core,
# you will get an `illegal instruction` error almost immediately. You can also use the `readelf
# --arch-specific <bin>` command in order to verify for which architecture a binary is compiled for
# (the output will contain either `v6` or `v7` as `Tag_CPU_arch`).
ARG RASPBERRY_PI_TOOLS_COMMIT_ID=5caa7046982f0539cf5380f94da04b31129ed521
RUN curl -sL https://github.com/raspberrypi/tools/archive/$RASPBERRY_PI_TOOLS_COMMIT_ID.tar.gz \
    | tar xzf - -C /usr/local --strip-components=1 tools-${RASPBERRY_PI_TOOLS_COMMIT_ID}/arm-bcm2708

# Need to add both these to PATH.
ENV PATH=/usr/local/arm-bcm2708/arm-linux-gnueabihf/bin:$PATH
ENV PATH=/usr/local/arm-bcm2708/arm-linux-gnueabihf/libexec/gcc/arm-linux-gnueabihf/4.8.3:$PATH

# Install Rust.
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y --verbose
ENV PATH=/root/.cargo/bin:$PATH

# Install the arm target for Rust.
RUN rustup target add arm-unknown-linux-gnueabihf
# Configure the linker for the arm target.
RUN echo '[target.arm-unknown-linux-gnueabihf]\nlinker = "arm-linux-gnueabihf-gcc"' >> /root/.cargo/config

ENV USER=root
WORKDIR /usr/src