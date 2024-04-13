#!/bin/bash

#更改默认地址为192.168.6.1
sed -i 's/192.168.1.1/172.16.1.1/g' package/base-files/files/bin/config_generate
# Hostname
sed -i 's/OpenWrt/CMccRAX3000M/g' package/base-files/files/bin/config_generate
sed -i 's/ImmortalWrt/CMccRAX3000M/g' package/base-files/files/bin/config_generate
####### Modify the version number
# sed -i '/DISTRIB_DESCRIPTION/d' package/base-files/files/etc/openwrt_release
# echo "DISTRIB_DESCRIPTION='ImmortalWrt $('%V')'" >> package/base-files/files/etc/openwrt_release
# sed -i "s/ImmortalWrt /\洲\·\C\y \build $(TZ=UTC-8 date "+%Y.%m.%d") @ ImmortalWrt /g" package/base-files/files/etc/openwrt_release
###
sed -i '/DISTRIB_DESCRIPTION/d' package/base-files/files/etc/openwrt_release
echo "DISTRIB_DESCRIPTION='ImmortalWrt $('%V')'" >> package/base-files/files/etc/openwrt_release
sed -i "s/ImmortalWrt /\洲\·\C\y \build $(TZ=UTC-8 date "+%Y.%m.%d") @ ImmortalWrt /g" package/base-files/files/etc/openwrt_release
###
# sed -i 's/os.date()/os.date("%Y-%m-%d %H:%M:%S")/g' package/lean/autocore/files/arm/index.htm

# Enable AAAA
sed -i 's/filter_aaaa	1/filter_aaaa	0/g' package/network/services/dnsmasq/files/dhcp.conf

# Timezone
sed -i "s/'UTC'/'CST-8'\n   set system.@system[-1].zonename='Asia\/Shanghai'/g" package/base-files/files/bin/config_generate
sed -i 's/time1\.apple\.com/ntp\.ntsc\.ac\.cn/g' package/base-files/files/bin/config_generate
sed -i 's/time1\.google\.com/ntp\.tencent\.com/g' package/base-files/files/bin/config_generate
sed -i 's/time\.cloudflare\.com/ntp1\.aliyun\.com/g' package/base-files/files/bin/config_generate

# cpufreq
sed -i 's/LUCI_DEPENDS.*/LUCI_DEPENDS:=\@\(arm\|\|aarch64\)/g' feeds/luci/applications/luci-app-cpufreq/Makefile
sed -i 's/services/system/g' feeds/luci/applications/luci-app-cpufreq/luasrc/controller/cpufreq.lua

# Change default theme
#sed -i 's#luci-theme-bootstrap#luci-theme-opentomcat#g' feeds/luci/collections/luci/Makefile
#sed -i '/set luci.main.mediaurlbase=\/luci-static\/bootstrap/d' feeds/luci/themes/luci-theme-bootstrap/root/etc/uci-defaults/30_luci-theme-bootstrap

# Add additional packages
## git clone --depth=1 https://github.com/fw876/helloworld.git package/helloworld
## git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall.git package/openwrt-passwall
## git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall2.git package/openwrt-passwall2
## git clone --depth=1 -b luci https://github.com/xiaorouji/openwrt-passwall.git package/luci-app-passwall
## git clone --depth=1 https://github.com/Leo-Jo-My/luci-theme-opentomcat.git package/luci-theme-opentomcat
git clone https://github.com/kenzok8/openwrt-packages.git package/openwrt-packages
git clone https://github.com/kenzok8/small.git package/small
#rm -rf package/openwrt-packages/luci-app-adguardhome
rm -rf package/openwrt-packages/adguardhome
rm -rf package/openwrt-packages/luci-app-ddns-go
rm -rf package/openwrt-packages/ddns-go
rm -rf feeds/packages/net/adguardhome
rm -rf feeds/luci/luci-app-aliyundrive-webdav
rm -rf feeds/packages/aliyundrive-webdav

#git clone -b 18.06 https://github.com/jerrykuku/luci-theme-argon.git package/luci-theme-argon
#git clone https://github.com/jerrykuku/luci-app-argon-config.git package/luci-app-argon-config

# dockerd去版本验证
sed -i 's/^\s*$[(]call\sEnsureVendoredVersion/#&/' feeds/packages/utils/dockerd/Makefile

# containerd Has验证
sed -i 's/PKG_HASH:=.*/PKG_HASH:=skip/g' feeds/packages/utils/containerd/Makefile

#sed -i '741a\
#                <tr><td width="33%">&#32534;&#35793;&#32773;&#58;&#32;&#27954;&#183;&#67;&#121;</td><td><a href="https://github.com/2286927/CMCC-RAX3000M-EMMC" style="color: black;" target="_blank">&#32534;&#35793;&#22320;&#22336;</a></td></tr>\
#                <tr><td width="33%">&#28304;&#30721;&#58;&#32;&#108;&#101;&#100;&#101;</td><td><a href="https://github.com/immortalwrt/immortalwrt" style="color: black;" target="_blank">&#28304;&#30721;&#38142;&#25509;</a></td></tr>
#' package/lean/autocore/files/arm/index.htm
