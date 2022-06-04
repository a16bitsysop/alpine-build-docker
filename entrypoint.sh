#!/bin/sh
: "${NME:="builder"}"
: "${REPO_DESC:="modified_alpine_repo"}"

die() {
  echo "$@"
  exit 1
}

[ -z "$ALPINE_PRIVATE_KEY" ] && die "Please put private key in the ALPINE_PRIVATE_KEY environment variable"
mkdir -p /home/"$NME"/.abuild
echo "$ALPINE_PRIVATE_KEY" >> /home/"$NME"/.abuild/privkey.rsa
echo "PACKAGER_PRIVKEY=\"/home/$NME/.abuild/privkey.rsa\"" > /home/"$NME"/.abuild/abuild.conf

sudo apk -U upgrade -a

cd /alpine/aport || die "Please mount aport to build into /alpine/aport"
echo "Building for repo $REPO_DESC"
abuild -r -D "$REPO_DESC" -P /alpine/package
