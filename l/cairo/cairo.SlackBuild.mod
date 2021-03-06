#!/bin/sh
# deps: pixman, fontconfig, freetype

# Copyright 2008, 2009  Patrick J. Volkerding, Sebeka, MN, USA
# All rights reserved.
#
# Redistribution and use of this script, with or without modification, is
# permitted provided that the following conditions are met:
#
# 1. Redistributions of this script must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
#
#  THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR IMPLIED
#  WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
#  MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO
#  EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
#  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
#  PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
#  OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
#  WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
#  OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
#  ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


VERSION=1.8.6
ARCH=${ARCH:-x86_64}
BUILD=${BUILD:-3}
AUTOR='sty'

NUMJOBS=${NUMJOBS:-" -j7 "}

if [ "$ARCH" = "i486" ]; then
  SLKCFLAGS="-O2 -march=i486 -mtune=i686"
  LIBDIRSUFFIX=""
elif [ "$ARCH" = "s390" ]; then
  SLKCFLAGS="-O2"
  LIBDIRSUFFIX=""
elif [ "$ARCH" = "x86_64" ]; then
  SLKCFLAGS="-O2 -fPIC"
  LIBDIRSUFFIX="64"
fi

CWD=$(pwd)
TMP=${TMP:-/tmp}
PKG=$TMP/package-cairo
rm -rf $PKG
mkdir -p $TMP $PKG

cd $TMP
rm -rf cairo-$VERSION
tar xvf $CWD/cairo-$VERSION.tar.bz2 || exit 1
cd cairo-$VERSION
chown -R root:root .
find . \
  \( -perm 777 -o -perm 775 -o -perm 711 -o -perm 555 -o -perm 511 \) \
  -exec chmod 755 {} \; -o \
  \( -perm 666 -o -perm 664 -o -perm 600 -o -perm 444 -o -perm 440 -o -perm 400 \) \
  -exec chmod 644 {} \;

# Time to try leaving this out again?
#  --disable-xcb

CFLAGS="$SLKCFLAGS" \
./configure \
  --prefix=/usr \
  --libdir=/usr/lib${LIBDIRSUFFIX} \
  --mandir=/usr/man \
  --sysconfdir=/etc \
  --disable-gtk-doc \
  --disable-glitz \
  --disable-quartz \
  --disable-static \
  --disable-win32 \
  --without-x \
&& make $NUMJOBS || make || exit 1
make install DESTDIR=$PKG

find $PKG | xargs file | grep -e "executable" -e "shared object" \
  | grep ELF | cut -f 1 -d : | xargs strip --strip-unneeded 2> /dev/null

mkdir -p $PKG/usr/doc/cairo-$VERSION
cp -a \
  AUTHORS COPYING* NEWS README TODO \
  $PKG/usr/doc/cairo-$VERSION
( cd $PKG/usr/doc/cairo-$VERSION ; ln -sf /usr/share/gtk-doc/html/cairo html )

mkdir -p $PKG/install
cat $CWD/slack-desc > $PKG/install/slack-desc
cat $CWD/slack-desc > $TMP/cairo-$VERSION-$ARCH-${AUTOR}-$BUILD.txt

cd $PKG
/sbin/makepkg -l y -c n $TMP/cairo-$VERSION-$ARCH-${AUTOR}-$BUILD.txz

