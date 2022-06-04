#!/bin/sh
: "${NME:="builder"}"
: "${REPO_DESC:="modified_alpine_repo"}"
ALPINE_VER="$(cat /etc/alpine-release)"
ALPINE_VER="${ALPINE_VER%.*}"

die() {
  echo "$@"
  exit 1
}

if [ -z "$ALPINE_PRIVATE_KEY" ]; then
  echo "ALPINE_PRIVATE_KEY empty"
  echo "Creating new key"
  abuild-keygen -a -i -n
else
  echo "Using private key in ALPINE_PRIVATE_KEY"
  mkdir -p /home/"$NME"/.abuild
  echo "$ALPINE_PRIVATE_KEY" >> /home/"$NME"/.abuild/privkey.rsa
  echo "PACKAGER_PRIVKEY=\"/home/$NME/.abuild/privkey.rsa\"" > /home/"$NME"/.abuild/abuild.conf
fi

doas apk -U upgrade -a

[ ! -f /alpine/aport/APKBUILD ] && die "Please mount aport to build into /alpine/aport"

ADIR=/tmp/v"$ALPINE_VER"/aport
mkdir -p "$ADIR"
cp /alpine/aport/* "$ADIR"
cd "$ADIR"

echo "Building for repo $REPO_DESC"
abuild -r -D "$REPO_DESC" -P /alpine/package
