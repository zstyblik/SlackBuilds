export ARCH=$(uname -m | cut -d'_' -f1)
( cd usr/include ; rm -rf asm )
( cd usr/include ; ln -sf "asm-${ARCH}" asm )
