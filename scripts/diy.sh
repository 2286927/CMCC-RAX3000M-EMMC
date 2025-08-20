#!/bin/bash

#更改默认地址为192.168.6.1
#sed -i 's/192.168.1.1/172.16.7.1/g' package/base-files/files/bin/config_generate
sed -i '/case "$protocol" in/,/esac/ s/\b[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\b/172.16.7.1/g' package/base-files/files/bin/config_generate
# Hostname
sed -i 's/OpenWrt/CMCC-RAX3000M/g' package/base-files/files/bin/config_generate
sed -i 's/ImmortalWrt/CMCC-RAX3000M/g' package/base-files/files/bin/config_generate
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
# 移除有问题的包
#rm -rf package/openwrt-packages/luci-app-adguardhome || true
#rm -rf package/openwrt-packages/adguardhome
rm -rf package/openwrt-packages/luci-app-ddns-go
rm -rf package/openwrt-packages/ddns-go
rm -rf feeds/packages/net/adguardhome
rm -rf feeds/luci/luci-app-aliyundrive-webdav
rm -rf feeds/packages/aliyundrive-webdav
rm -rf package/small/luci-app-fchomo || true
rm -rf package/small/luci-app-homeproxy || true
rm -rf package/small/momo || true
rm -rf package/small/nikki || true
# 修改 luci-app-fchomo 依赖
sed -i 's/firewall4/firewall/g' package/feeds/small/luci-app-fchomo/Makefile
sed -i 's/kmod-nft-tproxy/kmod-ipt-tproxy/g' package/feeds/small/luci-app-fchomo/Makefile

# 修改 luci-app-homeproxy 依赖
sed -i 's/firewall4/firewall/g' package/feeds/small/luci-app-homeproxy/Makefile
sed -i 's/kmod-nft-tproxy/kmod-ipt-tproxy/g' package/feeds/small/luci-app-homeproxy/Makefile

# 修改 nikki 依赖
sed -i 's/firewall4/firewall/g' package/feeds/small/nikki/Makefile
sed -i 's/kmod-nft-socket/kmod-ipt-socket/g' package/feeds/small/nikki/Makefile
sed -i 's/kmod-nft-tproxy/kmod-ipt-tproxy/g' package/feeds/small/nikki/Makefile

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

#以下内容为修复 EEPROM 冲突脚本
# DIY script for ImmortalWrt MT798x build
# Fix EEPROM conflicts and other issues

set -e

echo "=== Starting DIY script ==="

cd openwrt

# 修复 EEPROM 文件冲突 (使用 kmod-mt_wifi 的 EEPROM)
echo "=== 修复 EEPROM 文件冲突 ==="

# 移除 base-files 中的 EEPROM 文件，避免冲突
if [ -f "target/linux/mediatek/mt7981/base-files/lib/firmware/MT7981_iPAiLNA_EEPROM.bin" ]; then
    echo "移除 base-files 中的 EEPROM 文件以避免冲突"
    rm -f target/linux/mediatek/mt7981/base-files/lib/firmware/MT7981_iPAiLNA_EEPROM.bin
fi

# 恢复原始的 EEPROM 提取代码
sed -i 's/# caldata_extract_mmc/caldata_extract_mmc/' target/linux/mediatek/mt7981/base-files/lib/preinit/90_extract_caldata

# 确保 kmod-mt_wifi 中的 EEPROM 安装代码存在
if ! grep -q "MT7981_iPAiLNA_EEPROM\.bin" package/mtk/drivers/mt_wifi/Makefile; then
    echo "恢复 kmod-mt_wifi 中的 EEPROM 安装代码"
    
    # 备份原始 Makefile
    cp package/mtk/drivers/mt_wifi/Makefile package/mtk/drivers/mt_wifi/Makefile.backup
    
    # 添加 EEPROM 安装代码
    if grep -q "define Package/.*/install" package/mtk/drivers/mt_wifi/Makefile; then
        # 在现有的 install 段中添加 EEPROM 安装
        sed -i '/define Package\/\$(PKG_NAME)\/install/a\\t$(INSTALL_DIR) $(1)/lib/firmware\n\t$(INSTALL_DATA) ./files/mt7981-default-eeprom/MT7981_iPAiLNA_EEPROM.bin $(1)/lib/firmware/' package/mtk/drivers/mt_wifi/Makefile
    else
        # 创建完整的 install 段
        cat >> package/mtk/drivers/mt_wifi/Makefile << 'EOF'

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/lib/firmware
	$(INSTALL_DATA) ./files/mt7981-default-eeprom/MT7981_iPAiLNA_EEPROM.bin $(1)/lib/firmware/
endef
EOF
    fi
fi

# 确保 EEPROM 文件存在
if [ ! -f "package/mtk/drivers/mt_wifi/files/mt7981-default-eeprom/MT7981_iPAiLNA_EEPROM.bin" ]; then
    echo "创建 EEPROM 文件目录"
    mkdir -p package/mtk/drivers/mt_wifi/files/mt7981-default-eeprom
    
    # 使用 NX30Pro 的 EEPROM（如果启用）
    if [ "$USE_NX30PRO_EEPROM" = "true" ] && [ -f "../eeprom/nx30pro_eeprom.bin" ]; then
        echo "使用 NX30Pro 的 EEPROM 文件"
        cp ../eeprom/nx30pro_eeprom.bin package/mtk/drivers/mt_wifi/files/mt7981-default-eeprom/MT7981_iPAiLNA_EEPROM.bin
    else
        echo "使用默认的 EEPROM 文件（需要后续从设备提取）"
        # 创建一个空的 EEPROM 文件占位
        touch package/mtk/drivers/mt_wifi/files/mt7981-default-eeprom/MT7981_iPAiLNA_EEPROM.bin
    fi
fi

# 配置使用 kmod-mt_wifi 的 EEPROM
echo "=== 配置使用 kmod-mt_wifi 的 EEPROM ==="

# 确保配置启用 kmod-mt_wifi
echo "CONFIG_PACKAGE_kmod-mt_wifi=y" >> .config

# 禁用 base-files 中的 EEPROM 提取功能
echo "# CONFIG_MTK_EEPROM_EXTRACT is not set" >> .config

# 确保相关的内核配置正确
echo "CONFIG_MTK_EEPROM_PREBUILT=y" >> .config

# 检查并修复其他可能的冲突配置
if grep -q "CONFIG_MTK_EEPROM_FROM_FLASH" .config; then
    sed -i 's/CONFIG_MTK_EEPROM_FROM_FLASH=y/# CONFIG_MTK_EEPROM_FROM_FLASH is not set/' .config
fi

# 修复 OpenSSL 冲突
echo "=== 修复 OpenSSL 冲突 ==="

# 禁用冲突的 OpenSSL 包
sed -i 's/CONFIG_PACKAGE_libopenssl-afalg_sync=y/# CONFIG_PACKAGE_libopenssl-afalg_sync is not set/' .config
sed -i 's/CONFIG_PACKAGE_libopenssl-afalg_sync=m/# CONFIG_PACKAGE_libopenssl-afalg_sync is not set/' .config

# 确保只启用一个 OpenSSL 引擎
echo "# CONFIG_PACKAGE_libopenssl-afalg_sync is not set" >> .config
echo "CONFIG_PACKAGE_libopenssl-devcrypto=y" >> .config

# 检查并修复其他可能的冲突
if grep -q "CONFIG_PACKAGE_libopenssl-afalg_sync" .config; then
    sed -i '/CONFIG_PACKAGE_libopenssl-afalg_sync/d' .config
    echo "# CONFIG_PACKAGE_libopenssl-afalg_sync is not set" >> .config
fi

# 验证修复
echo "=== 验证修复 ==="
echo "kmod-mt_wifi Makefile 内容:"
grep -n "install\|EEPROM\|firmware" package/mtk/drivers/mt_wifi/Makefile || true

echo "EEPROM 相关配置:"
grep -n "EEPROM\|mt_wifi\|firmware" .config || true

echo "OpenSSL 相关配置:"
grep -n "openssl\|afalg\|devcrypto" .config || true

echo "=== DIY 脚本执行完成 ==="
#以上修复 EEPROM 冲突脚本结束
