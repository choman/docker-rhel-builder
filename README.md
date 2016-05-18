# Docker RHEL Builder

This docker image builds a docker base image for
- CentOS 7.2 (DVD and Minimal)
- CentOS 6.7
- RHEL 7.2
- RHEL 6.7

In theory this should support all RHEL clones, including ScientificLinux and Fedora

## What happens
Run ./build.sh "<path to ISO>/centos.iso"
- sudo mounts the ISO to /mnt
- from the ubuntu base image
- installs yum and rpm
- fires a script to install from ISO to /rhel in the container
  - script builds a tarball that can be imported into docker
- sudo chown -R $LOGNAME:$LOGNAME output


## Notes
- Final base images are not as small as the official images
- This project was started as a need to obtain a RHEL base image since they are not available at dockerhub
- Updated username

