#!/bin/bash
#===============================================
# File name: diy-part1.sh
# Description: OpenWrt DIY script part 1 (Before Update feeds)
#===============================================

#==============添加feed源地址===================
#Kenzok's常用软件包
#echo 'src-git kenzo https://github.com/kenzok8/openwrt-packages.git;master' >>feeds.conf.default
#echo 'src-git small https://github.com/kenzok8/small.git;master' >>feeds.conf.default
#灵缇游戏加速器(feeds.conf.default中istore-packages.git已经包含luci-app-LingTiGameAcc,但不包含依赖项LingTiGameAcc)
#git clone https://github.com/esirplayground/luci-app-LingTiGameAcc.git feeds/third_party/luci-app-LingTiGameAcc
git clone https://github.com/esirplayground/LingTiGameAcc.git feeds/third_party/LingTiGameAcc

#==============删除重复feed源===================
#rm -rf feeds/third_party/luci-app-LingTiGameAcc
