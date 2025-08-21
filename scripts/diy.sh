#!/bin/bash

# DIY script for ImmortalWrt MT798x build
# Fix all dependencies and conflicts for OpenWrt 21.02

set -e

echo "=== Starting DIY script ==="

# 获取脚本参数，判断执行阶段
PHASE="${1:-all}"

if [ "$PHASE" = "pre-feeds" ] || [ "$PHASE" = "all" ]; then
    echo "=== 执行 feeds 安装前的修复 ==="
    
    # 更改默认地址为192.168.6.1
    sed -i '/case "$protocol" in/,/esac/ s/\b[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\b/172.16.7.1/g' package/base-files/files/bin/config_generate

    # Hostname
    sed -i 's/OpenWrt/CMCC-RAX3000M/g' package/base-files/files/bin/config_generate
    sed -i 's/ImmortalWrt/CMCC-RAX3000M/g' package/base-files/files/bin/config_generate

    ####### Modify the version number
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

    # cpufreq (只在文件存在时修改)
    if [ -f "feeds/luci/applications/luci-app-cpufreq/Makefile" ]; then
        sed -i 's/LUCI_DEPENDS.*/LUCI_DEPENDS:=\@\(arm\|\|aarch64\)/g' feeds/luci/applications/luci-app-cpufreq/Makefile
    fi

    if [ -f "feeds/luci/applications/luci-app-cpufreq/luasrc/controller/cpufreq.lua" ]; then
        sed -i 's/services/system/g' feeds/luci/applications/luci-app-cpufreq/luasrc/controller/cpufreq.lua
    fi

# Change default theme
#sed -i 's#luci-theme-bootstrap#luci-theme-opentomcat#g' feeds/luci/collections/luci/Makefile
#sed -i '/set luci.main.mediaurlbase=\/luci-static\/bootstrap/d' feeds/luci/themes/luci-theme-bootstrap/root/etc/uci-defaults/30_luci-theme-bootstrap

    # Add additional packages
    echo "=== 添加额外包 ==="
## git clone --depth=1 https://github.com/fw876/helloworld.git package/helloworld
## git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall.git package/openwrt-passwall
## git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall2.git package/openwrt-passwall2
## git clone --depth=1 -b luci https://github.com/xiaorouji/openwrt-passwall.git package/luci-app-passwall
## git clone --depth=1 https://github.com/Leo-Jo-My/luci-theme-opentomcat.git package/luci-theme-opentomcat
    git clone https://github.com/kenzok8/openwrt-packages.git package/openwrt-packages
    git clone https://github.com/kenzok8/small.git package/small

    # 移除有问题的包
    echo "=== 移除有问题的包 ==="
    rm -rf package/openwrt-packages/luci-app-ddns-go 2>/dev/null || true
    rm -rf package/openwrt-packages/ddns-go 2>/dev/null || true
    rm -rf feeds/packages/net/adguardhome 2>/dev/null || true
    rm -rf feeds/luci/luci-app-aliyundrive-webdav 2>/dev/null || true
    rm -rf feeds/packages/aliyundrive-webdav 2>/dev/null || true
    rm -rf package/small/luci-app-fchomo 2>/dev/null || true
    rm -rf package/small/luci-app-homeproxy 2>/dev/null || true
    rm -rf package/small/momo 2>/dev/null || true
    rm -rf package/small/nikki 2>/dev/null || true

    # dockerd去版本验证
    if [ -f "feeds/packages/utils/dockerd/Makefile" ]; then
        sed -i 's/^\s*$[(]call\sEnsureVendoredVersion/#&/' feeds/packages/utils/dockerd/Makefile
    fi

    # containerd Hash验证
    if [ -f "feeds/packages/utils/containerd/Makefile" ]; then
        sed -i 's/PKG_HASH:=.*/PKG_HASH:=skip/g' feeds/packages/utils/containerd/Makefile
    fi
fi

if [ "$PHASE" = "post-feeds" ] || [ "$PHASE" = "all" ]; then
    echo "=== 执行 feeds 安装后的修复 ==="
    
    # 修复 feeds/small 中的依赖问题（在 feeds 安装后执行）
    echo "=== 修复 feeds 依赖问题 ==="
    
    if [ -f "feeds/small/luci-app-fchomo/Makefile" ]; then
        echo "修复 luci-app-fchomo 依赖"
        sed -i 's/firewall4/firewall/g; s/kmod-nft-tproxy/kmod-ipt-tproxy/g' feeds/small/luci-app-fchomo/Makefile
    fi

    if [ -f "feeds/small/luci-app-homeproxy/Makefile" ]; then
        echo "修复 luci-app-homeproxy 依赖"
        sed -i 's/firewall4/firewall/g; s/kmod-nft-tproxy/kmod-ipt-tproxy/g' feeds/small/luci-app-homeproxy/Makefile
    fi

    if [ -f "feeds/small/nikki/Makefile" ]; then
        echo "修复 nikki 依赖"
        sed -i 's/firewall4/firewall/g; s/kmod-nft-socket/kmod-ipt-socket/g; s/kmod-nft-tproxy/kmod-ipt-tproxy/g' feeds/small/nikki/Makefile
    fi

    # 修复 kenzo 源中的依赖问题
    if [ -d "feeds/kenzo" ]; then
        echo "检查 kenzo 源中的依赖问题"
        find feeds/kenzo -name "Makefile" -exec grep -l "firewall4\|kmod-nft-" {} \; | while read file; do
            echo "修复 $file"
            sed -i 's/firewall4/firewall/g; s/kmod-nft-tproxy/kmod-ipt-tproxy/g; s/kmod-nft-socket/kmod-ipt-socket/g' "$file"
        done
    fi

    echo "=== EEPROM 和 OpenSSL 修复 ==="
    
    # 修复 EEPROM 文件冲突 (使用 kmod-mt_wifi 的 EEPROM)
    if [ -f "target/linux/mediatek/mt7981/base-files/lib/firmware/MT7981_iPAiLNA_EEPROM.bin" ]; then
        echo "移除 base-files 中的 EEPROM 文件以避免冲突"
        rm -f target/linux/mediatek/mt7981/base-files/lib/firmware/MT7981_iPAiLNA_EEPROM.bin
    fi

    # 恢复原始的 EEPROM 提取代码
    if [ -f "target/linux/mediatek/mt7981/base-files/lib/preinit/90_extract_caldata" ]; then
        sed -i 's/# caldata_extract_mmc/caldata_extract_mmc/' target/linux/mediatek/mt7981/base-files/lib/preinit/90_extract_caldata
    fi

    # 确保 kmod-mt_wifi 中的 EEPROM 安装代码存在
    if [ -f "package/mtk/drivers/mt_wifi/Makefile" ]; then
        if ! grep -q "MT7981_iPAiLNA_EEPROM\.bin" package/mtk/drivers/mt_wifi/Makefile; then
            echo "恢复 kmod-mt_wifi 中的 EEPROM 安装代码"
            
            # 备份原始 Makefile
            cp package/mtk/drivers/mt_wifi/Makefile package/mtk/drivers/mt_wifi/Makefile.backup
            
            # 添加 EEPROM 安装代码
            if grep -q "define Package/.*/install" package/mtk/drivers/mt_wifi/Makefile; then
                sed -i '/define Package\/\$(PKG_NAME)\/install/a\\t$(INSTALL_DIR) $(1)/lib/firmware\n\t$(INSTALL_DATA) ./files/mt7981-default-eeprom/MT7981_iPAiLNA_EEPROM.bin $(1)/lib/firmware/' package/mtk/drivers/mt_wifi/Makefile
            else
                cat >> package/mtk/drivers/mt_wifi/Makefile << 'EOF'

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/lib/firmware
	$(INSTALL_DATA) ./files/mt7981-default-eeprom/MT7981_iPAiLNA_EEPROM.bin $(1)/lib/firmware/
endef
EOF
            fi
        fi
    fi

    # 确保 EEPROM 文件存在
    if [ ! -f "package/mtk/drivers/mt_wifi/files/mt7981-default-eeprom/MT7981_iPAiLNA_EEPROM.bin" ]; then
        echo "创建 EEPROM 文件目录"
        mkdir -p package/mtk/drivers/mt_wifi/files/mt7981-default-eeprom
        
        # 使用 NX30Pro 的 EEPROM（如果启用）
        if [ "$USE_NX30PRO_EEPROM" = "true" ] && [ -f "eeprom/nx30pro_eeprom.bin" ]; then
            echo "使用 NX30Pro 的 EEPROM 文件"
            cp eeprom/nx30pro_eeprom.bin package/mtk/drivers/mt_wifi/files/mt7981-default-eeprom/MT7981_iPAiLNA_EEPROM.bin
        else
            echo "使用默认的 EEPROM 文件（需要后续从设备提取）"
            touch package/mtk/drivers/mt_wifi/files/mt7981-default-eeprom/MT7981_iPAiLNA_EEPROM.bin
        fi
    fi

    # 配置使用 kmod-mt_wifi 的 EEPROM
    echo "CONFIG_PACKAGE_kmod-mt_wifi=y" >> .config
    echo "# CONFIG_MTK_EEPROM_EXTRACT is not set" >> .config
    echo "CONFIG_MTK_EEPROM_PREBUILT=y" >> .config

    # 修复 OpenSSL 冲突
    echo "=== 修复 OpenSSL 冲突 ==="
    sed -i 's/CONFIG_PACKAGE_libopenssl-afalg_sync=y/# CONFIG_PACKAGE_libopenssl-afalg_sync is not set/' .config 2>/dev/null || true
    sed -i 's/CONFIG_PACKAGE_libopenssl-afalg_sync=m/# CONFIG_PACKAGE_libopenssl-afalg_sync is not set/' .config 2>/dev/null || true
    echo "# CONFIG_PACKAGE_libopenssl-afalg_sync is not set" >> .config
    echo "CONFIG_PACKAGE_libopenssl-devcrypto=y" >> .config
fi

echo "=== DIY 脚本执行完成 ==="
