$(call PKG_INIT_BIN, 0.0.1.30)
$(PKG)_SOURCE:=linknx-$($(PKG)_VERSION).tar.gz
$(PKG)_SOURCE_MD5:=5e0bb20131d958ef18f49c9cd373e204
$(PKG)_SITE:=http://sourceforge.net/projects/$(pkg)/files
$(PKG)_BINARY:=$($(PKG)_DIR)/src/linknx
$(PKG)_TARGET_BINARY:=$($(PKG)_DEST_DIR)/usr/bin/linknx

# add EXTRA_(C|LD)FLAGS
$(PKG)_CONFIGURE_PRE_CMDS += find $(abspath $($(PKG)_DIR)) -name Makefile.in -type f -exec $(SED) -i -r -e 's,^(C|LD)FLAGS[ \t]*=[ \t]*@\1FLAGS@,& $$$$(EXTRA_\1FLAGS),' \{\} \+;
$(PKG)_EXTRA_CFLAGS  += -ffunction-sections -fdata-sections
$(PKG)_EXTRA_LDFLAGS += -Wl,--gc-sections -largp

$(PKG)_CONFIGURE_OPTIONS += --without-pth-test

$(PKG)_CONFIGURE_PRE_CMDS += $(call PKG_PREVENT_RPATH_HARDCODING,./configure)
$(PKG)_CONFIGURE_PRE_CMDS += find $(abspath $($(PKG)_DIR)) -name Makefile.in -exec $(SED) -r -i 's~@PTH_CFLAGS@~-I$(TARGET_TOOLCHAIN_STAGING_DIR)/usr/include~'   \{\} \+;
$(PKG)_CONFIGURE_PRE_CMDS += find $(abspath $($(PKG)_DIR)) -name Makefile.in -exec $(SED) -r -i 's~@PTH_CPPFLAGS@~-I$(TARGET_TOOLCHAIN_STAGING_DIR)/usr/include~' \{\} \+;
$(PKG)_CONFIGURE_PRE_CMDS += find $(abspath $($(PKG)_DIR)) -name Makefile.in -exec $(SED) -r -i 's~@PTH_LDFLAGS@~-I$(TARGET_TOOLCHAIN_STAGING_DIR)/usr/lib  -largp~'      \{\} \+;
$(PKG)_CONFIGURE_POST_CMDS += find $(abspath $($(PKG)_DIR)) -name Makefile -exec $(SED) -r -i -e 's~^CXX(.*)-wrapper~CXX\1~'      \{\} \+;
$(PKG)_CONFIGURE_POST_CMDS += find $(abspath $($(PKG)_DIR)) -name Makefile -exec $(SED) -r -i 's~(LIBS =.*)(true)~\1~'      \{\} \+;

$(PKG)_DEPENDS_ON += pthsem argp curl libstdcxx
$(PKG)_REBUILD_SUBOPTS += FREETZ_LIB_libpthsem FREETZ_LIB_libargp_WITH_STATIC FREETZ_LIB_libcurl FREETZ_LIB_libstdc__ 

$(PKG_SOURCE_DOWNLOAD)
$(PKG_UNPACKED)
$(PKG_CONFIGURED_CONFIGURE)

$($(PKG)_BINARY): $($(PKG)_DIR)/.configured
	$(SUBMAKE) -C $(LINKNX_DIR)  \
		EXTRA_CFLAGS="$(LINKNX_EXTRA_CFLAGS)" \
		EXTRA_LDFLAGS="$(LINKNX_EXTRA_LDFLAGS)"

$($(PKG)_TARGET_BINARY): $($(PKG)_BINARY)
	$(INSTALL_BINARY_STRIP)

$(pkg):

$(pkg)-precompiled: $($(PKG)_TARGET_BINARY)

$(pkg)-clean:
	-$(SUBMAKE) -C $(LINKNX_DIR) clean
	$(RM) $(LINKNX_DIR)/.configured

$(pkg)-uninstall:
	$(RM) $(LINKNX_TARGET_BINARY)

$(PKG_FINISH)
