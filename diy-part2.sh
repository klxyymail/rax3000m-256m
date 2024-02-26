#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#

# Modify default IP
sed -i 's/192.168.1.1/192.168.5.1/g' package/base-files/files/bin/config_generate

#预置OpenClash内核和数据
if [ -d *"OpenClash"* ]; then
	CORE_VER="https://raw.githubusercontent.com/vernesong/OpenClash/core/dev/core_version"
	CORE_TYPE=$(echo $WRT_TARGET | egrep -iq "64|86" && echo "amd64" || echo "arm64")
	CORE_TUN_VER=$(curl -sfL $CORE_VER | sed -n "2{s/\r$//;p;q}")

	CORE_DEV="https://github.com/vernesong/OpenClash/raw/core/dev/dev/clash-linux-$CORE_TYPE.tar.gz"
	CORE_MATE="https://github.com/vernesong/OpenClash/raw/core/dev/meta/clash-linux-$CORE_TYPE.tar.gz"
	CORE_TUN="https://github.com/vernesong/OpenClash/raw/core/dev/premium/clash-linux-$CORE_TYPE-$CORE_TUN_VER.gz"

	GEO_MMDB="https://github.com/alecthw/mmdb_china_ip_list/raw/release/lite/Country.mmdb"
	GEO_SITE="https://github.com/Loyalsoldier/v2ray-rules-dat/raw/release/geosite.dat"
	GEO_IP="https://github.com/Loyalsoldier/v2ray-rules-dat/raw/release/geoip.dat"
	GEO_META="https://github.com/MetaCubeX/meta-rules-dat/raw/release/geoip.metadb"

	cd ./OpenClash/luci-app-openclash/root/etc/openclash/

	curl -sfL -o Country.mmdb $GEO_MMDB
	curl -sfL -o GeoSite.dat $GEO_SITE
	curl -sfL -o GeoIP.dat $GEO_IP
	curl -sfL -o GeoIP.metadb $GEO_META

	mkdir ./core/ && cd ./core/

	curl -sfL -o meta.tar.gz $CORE_MATE && tar -zxf meta.tar.gz && mv -f clash clash_meta
	curl -sfL -o tun.gz $CORE_TUN && gzip -d tun.gz && mv -f tun clash_tun
	curl -sfL -o dev.tar.gz $CORE_DEV && tar -zxf dev.tar.gz

	chmod +x ./clash* && rm -rf ./*.gz

	echo "openclash date has been updated!"
fi
