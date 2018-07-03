FROM ubuntu:latest

RUN apt-get update && \
    apt-get install \
    --yes \
    binutils \
    curl \
    wget \
    zip

# Install the Raspberry Pi toolchain.
ARG RASPBERRY_PI_TOOLS_COMMIT_ID=5caa7046982f0539cf5380f94da04b31129ed521
RUN wget https://github.com/raspberrypi/tools/archive/$RASPBERRY_PI_TOOLS_COMMIT_ID.zip -O /root/pi-tools.zip
RUN unzip /root/pi-tools.zip -d /root
RUN mv /root/tools-$RASPBERRY_PI_TOOLS_COMMIT_ID /root/pi-tools
# Need to set both these in the PATH.
ENV PATH=/root/pi-tools/arm-bcm2708/arm-linux-gnueabihf/bin:$PATH
ENV PATH=/root/pi-tools/arm-bcm2708/arm-linux-gnueabihf/libexec/gcc/arm-linux-gnueabihf/4.8.3:$PATH

# Install Rust.
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y --verbose
ENV PATH=/root/.cargo/bin:$PATH

# Install the arm target for Rust.
RUN rustup target add arm-unknown-linux-gnueabihf
# Configure the linker for the arm target.
RUN echo '[target.arm-unknown-linux-gnueabihf]\nlinker = "arm-linux-gnueabihf-gcc"' >> /root/.cargo/config

ENV USER=root
RUN cargo new /src
WORKDIR /src
RUN cargo build --target=arm-unknown-linux-gnueabihf
# Verify that the output file is for armv6
RUN readelf --arch-specific ./target/arm-unknown-linux-gnueabihf/debug/src
