#!/bin/bash

die() {
    echo "$1" >&2
    exit 1
}

get_release() {
    # Does this commit have an associated release tag?
    git tag --points-at HEAD | tail -n1 2>/dev/null |
        sed -e 's/^release-//'
}

release_is_number() {
    get_release | grep -Eqx "[0-9]+"
}

make_name() {
    release=$(get_release)
    if uname -m | grep "aarch64"; then
      arch=arm64
    else
      arch=armhf
    fi

    if [ -z "$release" ]; then
        die "No release tag found; quitting"
    fi

    name=$prefix-$release-$arch
} 

checksum() {
    echo "computing SHA1"
    sha1sum "$image_gz" > "$image_sha1"
}

bell() {
    while true; do
        sleep 60
        echo -e "\\a"
    done
}

prefix=treehouse
image=$(find images/*.img | head -1) # XXX
test -n "$image" || die "image not found"
make_name
if [ ! -d "build" ]; then
  mkdir build/
fi
image_gz="build/$name.img.gz"
image_sha1=$image_gz.sha1
set -e
chmod 600 .drone/id_deploy