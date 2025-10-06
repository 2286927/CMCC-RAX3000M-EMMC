#!/bin/bash
#===============================================
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#===============================================

# 修改版本为编译日期，数字类型。
date_version=$(date +"%Y%m%d%H")
echo $date_version > version

# 为固件版本加上编译作者
author="OpenWrt"
sed -i "s/DISTRIB_DESCRIPTION.*/DISTRIB_DESCRIPTION='%D %V ${date_version} by ${author}'/g" package/base-files/files/etc/openwrt_release
sed -i "s/OPENWRT_RELEASE.*/OPENWRT_RELEASE=\"%D %V ${date_version} by ${author}\"/g" package/base-files/files/usr/lib/os-release

# 修改默认登录IP
#sed -i 's/192.168.1.1/192.168.6.1/g' package/base-files/files/bin/config_generate

# 修改默认wifi名称ssid为 旧版本修改
#sed -i 's/ssid='ImmortalWrt'/ssid='ChinaUnicom'/g' ./package/kernel/mac80211/files/lib/wifi/mac80211.sh
# 修改默认wifi名称ssid为 hanwckf源码修改 ssid=ImmortalWrt-2.4G/ImmortalWrt-5G
#sed -i 's/ssid='ImmortalWrt'/ssid='ChinaUnicom'/g' ./package/mtk/applications/mtwifi-cfg/files/mtwifi.sh

# 修改默认wifi密码key为password
#sed -i 's/encryption=none/encryption=psk2/g' package/kernel/mac80211/files/lib/wifi/mac80211.sh
#sed -i '/set wireless.default_radio${devidx}.encryption=psk2/a\set wireless.default_radio${devidx}.key=password' package/kernel/mac80211/files/lib/wifi/mac80211.sh

#取消原主题luci-theme-bootstrap为默认主题
sed -i '/set luci.main.mediaurlbase=\/luci-static\/bootstrap/d' feeds/luci/themes/luci-theme-bootstrap/root/etc/uci-defaults/30_luci-theme-bootstrap

# 修改默认主题
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile
sed -i 's/config internal themes/config internal themes\n    option Argon  \"\/luci-static\/argon\"/g' feeds/luci/modules/luci-base/root/etc/config/luci

#修改默认语言
sed -i 's/auto/zh_cn/g' openwrt/feeds/luci/modules/luci-base/root/etc/config/luci

# 修改默认主机名（不能纯数字或者使用中文）
#sed -i 's/OpenWrt/OpenWrt/g' package/base-files/files/bin/config_generate

# 删除DDNS's示例
sed -i '/myddns_ipv4/,$d' feeds/packages/net/ddns-scripts/files/etc/config/ddns

# 重新设置CPU主频 for MT7981B
sed -i '/"mediatek"\/\*|\"mvebu"\/\*/{n; s/.*/\tcpu_freq="1.3GHz" ;;/}' package/emortal/autocore/files/generic/cpuinfo
