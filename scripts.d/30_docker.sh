#!/bin/bash

source lib.sh

_pip3_install docker-compose --no-cache-dir

exit 0

ln -sr /var/run/docker.sock mnt/img_root/var/run/docker.sock
_op _chroot docker version

IMAGES=(
    portainer/portainer:linux-arm
    #pihole/pihole:4.3.1-4_armhf
    #firehol/netdata:armv7hf
)

MULTIS=(
    treehouses/couchdb:2.3.1
    treehouses/planet:latest
    treehouses/planet:db-init
)

#OLD=$(pwd -P)
#cd /var/lib || die "ERROR: /var/lib folder doesn't exist, exiting"

#service docker stop
#mv docker docker.temp
#mkdir -p "$OLD/mnt/img_root/var/lib/docker"
#ln -s "$OLD/mnt/img_root/var/lib/docker" docker
#service docker start

for image in "${IMAGES[@]}" ; do
    _op _chroot docker pull "$image"
done

mkdir -p mnt/img_root/root/.docker
#touch mnt/img_root/root/.docker/config.json
echo '{"experimental": "enabled"}' > mnt/img_root/root/.docker/config.json

#mkdir -p "$OLD/mnt/img_root/root/.docker"
#cp ~/.docker/config.json "$OLD/mnt/img_root/root/.docker/."

for multi in "${MULTIS[@]}" ; do
    _op _chroot docker manifest inspect "$multi"
    name=$(echo "$multi" | cut -d ":" -f 1)
    tag=$(echo "$multi" | cut -d ":" -f 2)
    hash=$(_op _chroot docker manifest inspect "$multi" | jq '.manifests' | jq -c 'map(select(.platform.architecture | contains("arm")))' | jq '.[0]' | jq '.digest' | sed -e 's/^"//' -e 's/"$//')
    _op _chroot docker pull "$name@$hash"
    _op _chroot docker tag "$name@$hash" "$name:$tag" 
done

_op _chroot docker tag treehouses/planet:db-init treehouses/planet:db-init-local
_op _chroot docker tag treehouses/planet:latest treehouses/planet:local

_op _chroot sync; _op _chroot sync; _op _chroot sync

_op _chroot docker images

#_op _chroot service docker stop
#unlink docker
unlink mnt/img_root/var/run/docker.sock
#mv docker.temp docker
#service docker start

#cd "$OLD" || die "ERROR: $OLD folder doesn't exist, exiting"

_op _chroot adduser pi docker

# installs docker-compose using pip3
_pip3_install docker-compose --no-cache-dir
