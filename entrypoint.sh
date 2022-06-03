#!/bin/sh
: "${NME:="builder"}"
: "${REPO_DESC:="modified  alpine repo"}"

die() {
  echo "$@"
  exit 1
}

[ -z "${ALPINE_PRIVATE_KEY}" ] && die "Please put private key in the ALPINE_PRIVATE_KEY environment variable"
mkdir -p /home/"$NME"/.abuild
echo "${ALPINE_PRIVATE_KEY" >> /home/"$NME"/.abuild/privkey.rsa
echo "PACKAGER_PRIVKEY=\"/home/$NME/.abuild/privkey.rsa\"" > /home/"$NME"/.abuild/abuild.conf

sudo apk -U upgrade -a

mkdir -p /alpine/package
cd /alpine/aport
abuild -r -D "${REPO_DESC}" -P /alpine/package
