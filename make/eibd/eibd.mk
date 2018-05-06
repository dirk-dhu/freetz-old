$(call PKG_INIT_BIN, 0.0.5)
$(PKG)_SOURCE:=bcusdk_$($(PKG)_VERSION).tar.gz
$(PKG)_SOURCE_MD5:=5f81bc4e6bb53564573d573e795a9a5f
$(PKG)_SITE:=http://www.auto.tuwien.ac.at/~mkoegler/eib
$(PKG)_DIR:=$($(PKG)_SOURCE_DIR)/bcusdk-$($(PKG)_VERSION)
$(PKG)_BINARY:=$($(PKG)_DIR)/eibd/server/eibd
$(PKG)_TARGET_BINARY:=$($(PKG)_DEST_DIR)/usr/bin/eibd

$(PKG)_CONFIGURE_OPTIONS += --without-pth-test
$(PKG)_CONFIGURE_OPTIONS += --enable-onlyeibd
$(PKG)_CONFIGURE_OPTIONS += --enable-eibnetiptunnel
$(PKG)_CONFIGURE_OPTIONS += --enable-eibnetipserver

# add EXTRA_(C|LD)FLAGS
$(PKG)_CONFIGURE_PRE_CMDS += find $(abspath $($(PKG)_DIR)) -name Makefile.in -type f -exec $(SED) -i -r -e 's,^(C|LD)FLAGS[ \t]*=[ \t]*@\1FLAGS@,& $$$$(EXTRA_\1FLAGS),' \{\} \+;
$(PKG)_EXTRA_CFLAGS  := -ffunction-sections -fdata-sections
$(PKG)_EXTRA_LDFLAGS := -Wl,--gc-sections -largp

$(PKG)_CONFIGURE_PRE_CMDS += $(call PKG_PREVENT_RPATH_HARDCODING,./configure)
$(PKG)_CONFIGURE_PRE_CMDS += find $(abspath $($(PKG)_DIR)) -name Makefile.in -exec $(SED) -r -i 's~@PTH_CFLAGS@~-I$(TARGET_TOOLCHAIN_STAGING_DIR)/usr/include~'   \{\} \+;
$(PKG)_CONFIGURE_PRE_CMDS += find $(abspath $($(PKG)_DIR)) -name Makefile.in -exec $(SED) -r -i 's~@PTH_CPPFLAGS@~-I$(TARGET_TOOLCHAIN_STAGING_DIR)/usr/include~' \{\} \+;
$(PKG)_CONFIGURE_PRE_CMDS += find $(abspath $($(PKG)_DIR)) -name Makefile.in -exec $(SED) -r -i 's~@PTH_LDFLAGS@~-I$(TARGET_TOOLCHAIN_STAGING_DIR)/usr/lib~'      \{\} \+;
$(PKG)_CONFIGURE_POST_CMDS += $(SED) -r -i 's/SUBDIRS = def c.*/SUBDIRS = def c \./' $(abspath $($(PKG)_DIR))/eibd/client/Makefile;
$(PKG)_CONFIGURE_POST_CMDS += find $(abspath $($(PKG)_DIR)) -name Makefile -exec $(SED) -r -i 's~(LIBS =.*)(true)~\1~'      \{\} \+;

$(PKG)_DEPENDS_ON += pthsem argp
$(PKG)_REBUILD_SUBOPTS += FREETZ_LIB_libpthsem FREETZ_LIB_libargp_WITH_STATIC

$(PKG_SOURCE_DOWNLOAD)
$(PKG_UNPACKED)
$(PKG_CONFIGURED_CONFIGURE)

$($(PKG)_BINARY): $($(PKG)_DIR)/.configured
	$(SUBMAKE) -C $(EIBD_DIR)  \
		EXTRA_CFLAGS="$(EIBD_EXTRA_CFLAGS)" \
		EXTRA_CPPFLAGS="$(EIBD_EXTRA_CFLAGS)" \
		EXTRA_LDFLAGS="$(EIBD_EXTRA_LDFLAGS)"

$($(PKG)_TARGET_BINARY): $($(PKG)_BINARY)
	$(INSTALL_BINARY_STRIP)

$(pkg):

$(pkg)-precompiled: $($(PKG)_TARGET_BINARY)

$(pkg)-clean:
	-$(SUBMAKE) -C $(EIBD_DIR) clean
	$(RM) $(EIBD_DIR)/.configured

$(pkg)-uninstall:
	$(RM) $(EIBD_TARGET_BINARY)

$(PKG_FINISH)
