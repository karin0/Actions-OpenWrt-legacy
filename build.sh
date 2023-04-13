#!/bin/bash
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# Description: Build OpenWrt using GitHub Actions
#

set -ex
umask 022

REPO_URL=https://github.com/coolsnowwolf/lede
REPO_BRANCH=master
FEEDS_CONF=feeds.conf.default
CONFIG_FILE=redmi_ax6.config
DIY_P1_SH=diy-part1.sh
DIY_P2_SH=diy-part2.sh
GITHUB_WORKSPACE="$PWD"

if [ "$(id -u)" = 0 ]; then
  echo "OpenWrt can't be built as root" >&2
  exit 1
fi

if [ -d openwrt ]; then
  git -C openwrt fetch --depth 1
  git -C openwrt checkout origin/$REPO_BRANCH
else
  git clone $REPO_URL -b $REPO_BRANCH --depth 1 openwrt
fi

cp -rf "$GITHUB_WORKSPACE"/ax6/generic.mk openwrt/target/linux/ipq807x/image/generic.mk

[ -e $FEEDS_CONF ] && cp $FEEDS_CONF openwrt/feeds.conf.default

cd openwrt
bash "$GITHUB_WORKSPACE"/$DIY_P1_SH

./scripts/feeds update -a
./scripts/feeds install -a

cd -
cp $CONFIG_FILE openwrt/.config

# https://github.com/openwrt/packages/issues/12793
if go="$(ls -d /usr/lib/go-*)"; then
  echo "CONFIG_GOLANG_EXTERNAL_BOOTSTRAP_ROOT=\"$go\"" >> openwrt/.config
fi

cd openwrt
bash "$GITHUB_WORKSPACE"/$DIY_P2_SH

make defconfig
make download -j8
find dl -size -1024c -exec ls -l {} \;
find dl -size -1024c -exec rm -f {} \;

n=$(nproc)
echo -n "$n threads starts at "; date
make -j"$n"
echo -n 'finished at '; date
