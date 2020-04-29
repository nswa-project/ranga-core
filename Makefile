include $(TOPDIR)/rules.mk

DEP_DISABLE_FAILSAFE:=+@IMAGEOPT +@PREINITOPT +@TARGET_PREINIT_DISABLE_FAILSAFE
DEP_BUSYBOX:=+@BUSYBOX_CUSTOM +@BUSYBOX_CONFIG_TELNETD +@BUSYBOX_CONFIG_FEATURE_TELNETD_STANDALONE +@BUSYBOX_CONFIG_BASE64
DEP_KMODS:=+kmod-macvlan

PKG_NAME:=ranga
PKG_VERSION:=4.0
PKG_RELEASE:=9

include $(INCLUDE_DIR)/package.mk

define Package/ranga
  SECTION:=ranga
  CATEGORY:=NSWA Ranga
  DEPENDS:=+base-files +lua +luasocket +libmbedtls +rp-pppoe-server +mwan3 +unzip +uhttpd +libustream-mbedtls $(DEP_KMODS) $(DEP_BUSYBOX) $(DEP_DISABLE_FAILSAFE)
  TITLE:=NSWA Ranga System
endef

define Package/ranga/description
  NSWA 4.0 (Ranga) System over OpenWrt Distro. (Open-source version)
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
	cp -r ./src $(PKG_BUILD_DIR)/src
	$(Build/Patch)
endef

define Build/Compile
	$(MAKE) -C $(PKG_BUILD_DIR)/src CC="$(TARGET_CC)" CFLAGS="$(TARGET_CFLAGS)" LDFLAGS="$(TARGET_LDFLAGS)"
endef

define Package/ranga/install
	cp -r ./files/* $(1)/
	cp -r ./cgi/files/* $(1)/
	cp -r ./misc/files/* $(1)/
	mkdir -p ../../files
	cp -r ./files-override/* ../../files
	$(MAKE) -C $(PKG_BUILD_DIR)/src INSTALL_DIR="$(INSTALL_DIR)" INSTALL_BIN="$(INSTALL_BIN)" PREFIX="$(1)" install
endef

$(eval $(call BuildPackage,ranga))
