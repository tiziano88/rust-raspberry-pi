# How to cross-compile Rust for Raspberry Pi 1 / Zero (armv6)

This repository contains a single Dockerfile with the steps necessary to cross compile a Rust binary for Raspberry Pi 1 / Zero (with armv6 core).

To build the docker image, run the following command from the repository root:

```
docker build .
```

More generally, use the Dockerfile as a guide to figure out what commands to run on your own systems to get things up and running.

See https://github.com/japaric/rust-cross for a more comprehensive guide on how to cross compile for Raspberry Pi, though that only deals with armv7 cores.
