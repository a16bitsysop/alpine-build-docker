#!/bin/sh
: "${NME:="builder"}"
: "${REPO_DESC:="modified_alpine_repo"}"

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

echo "Building for repo $REPO_DESC"
cd /alpine/aport
abuild -r -D "$REPO_DESC" -P /alpine/package
