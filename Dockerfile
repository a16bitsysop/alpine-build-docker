ARG ALPINE_VER=3.16
ARG NME=builder

##################################################################################################
FROM alpine:${ALPINE_VER}
ARG NME

RUN apk update
# install abuild and deps
RUN apk add --no-cache -u \
  alpine-conf \
  alpine-sdk \
  atools \
  doas-sudo-shim \
  findutils \
  gdb \
  git \
  pax-utils

# setup build user
RUN adduser -D ${NME} && addgroup ${NME} abuild \
&&  echo "permit nopass ${NME}" >> /etc/doas.d/doas.conf

WORKDIR /usr/local/bin
COPY --chmod=755 entrypoint.sh ./

# switch to build user
USER ${NME}
