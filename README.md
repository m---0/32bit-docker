# 32bit-docker
Scripts and Dockerfiles to build docker images

## Description of images

 * **build**: This is a sid/unstable base image, variant *buildd*: this
   includes `apt`, `build-essential` and their dependencies. It's suitable
   as a base image for building a Debian package, or the basis of a *buildd*.

 * **jessie**: a base debian installation of *jessie* (current *stable*).
   Approx. 218M in size.

 * **wheezy**: a base debian installation of *wheezy* (*oldstable*).
   Approx 163M in size.

 * **wheezy-i386**: a base debian installation of the i386-architecture
   version of *wheezy*. This could be used for anything requiring a 32-bit
   toolchain. Approx 166M in size.

## Getting started

To build your own images, clone this repo, cd to the local path and run

```
sudo make release=jessie prefix=massimos arch=i386 mirror=http://httpredir.debian.org/debian/
```

All the arguments above are optional. The values in the example above are
the defaults. The resulting image would be tagged `jmtd/debian:jessie-amd64`.

