# How to cross-compile Rust for Raspberry Pi 1 / Zero (armv6)

This repository contains a single Dockerfile with the steps necessary to cross compile a Rust binary for Raspberry Pi 1 / Zero (with armv6 core).

Together with the docker-compose-configuration you can use the Dockerfile to cross-compile rust-projects with a single command.

## Example

```
$ cargo new rust_helloworld
$ cd rust_helloworld

# copy .dockeignore, Dockerfile and docker-compose.yml into the directory

# simply start the container to compile. Rerun this command to recompile
$ docker-compose up

# Verify that the output file is for armv6
$ readelf --arch-specific ./target/arm-unknown-linux-gnueabihf/release/rust_helloworld

# "deploy"
$ scp ./target/arm-unknown-linux-gnueabihf/release/rust_helloworld pi@raspberry:

# run
$ ssh pi@raspberry ./rust_helloworld

```

More generally, use the Dockerfile as a guide to figure out what commands to run on your own systems to get things up and running.

See https://github.com/japaric/rust-cross for a more comprehensive guide on how to cross compile for Raspberry Pi, though that only deals with armv7 cores.
