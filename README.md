# mk-docker-images
Scripts and Dockerfiles to build docker images

## Description of images

 * **debian-jessie**: This is a debian jessie base image. Approx. 275MB in size.

 * **centos-6.8**: A Centos based installation image. Approx. 580MB in size.
   Approx. 218M in size.

 * **debian-wheezy-i386**: a base debian installation of the i386-architecture
   version of *wheezy*. This could be used for anything requiring a 32-bit
   toolchain. Approx 166M in size.

## Getting started

To build your own images, clone this repo, cd to the local path and run

```
sudo make release=jessie prefix=<dockerhub-user> arch=i386 mirror=http://httpredir.debian.org/debian/
```

All the arguments above are optional. The values in the example above are
the defaults. The resulting image would be tagged `<dockerhub-user>/debian:jessie-amd64`.

