$(call PKG_INIT_LIB, 1.3)
$(PKG)_LIB_VERSION:=1.3
$(PKG)_SOURCE:=argp-standalone-$($(PKG)_VERSION).tar.gz
$(PKG)_DIR:=$($(PKG)_SOURCE_DIR)/argp-standalone-$($(PKG)_VERSION)
$(PKG)_SOURCE_MD5:=720704bac078d067111b32444e24ba69
$(PKG)_SITE:=http://www.lysator.liu.se/~nisse/misc

$(PKG)_LIBNAMES_SHORT := libargp
$(PKG)_LIBNAMES_LONG := $($(PKG)_LIBNAMES_SHORT:%=%.a)
$(PKG)_LIBNAME=$($(PKG)_LIBNAMES_SHORT).a

$(PKG)_LIBS_BUILD_DIR :=$($(PKG)_LIBNAMES_LONG:%=$($(PKG)_DIR)/%)
$(PKG)_LIBS_STAGING_DIR := $($(PKG)_LIBNAMES_LONG:%=$(TARGET_TOOLCHAIN_STAGING_DIR)/usr/lib/%)
$(PKG)_LIBS_TARGET_DIR := $($(PKG)_LIBNAMES_LONG:%=$($(PKG)_TARGET_LIBDIR)/%)

$(PKG)_CONFIGURE_PRE_CMDS += $(call PKG_PREVENT_RPATH_HARDCODING,./configure)
$(PKG)_CONFIGURE_POST_CMDS += $(SED) -r -i 's/__THROW//g' ./argp-parse.c;

$(PKG)_EXTRA_CFLAGS  := 

$(PKG)_CONFIGURE_OPTIONS += --disable-nls

$(PKG)_CONFIGURE_ENV += ac_cv_prog_cc_c99=-std=gnu90
$(PKG)_CONFIGURE_ENV += ac_cv_prog_cc_stdc=-std=gnu90
$(PKG)_CONFIGURE_ENV += am_cv_prog_cc_stdc=-std=gnu90

$(PKG_SOURCE_DOWNLOAD)
$(PKG_UNPACKED)
$(PKG_CONFIGURED_CONFIGURE)

$($(PKG)_LIBS_BUILD_DIR): $($(PKG)_DIR)/.configured
	$(SUBMAKE) -C $(ARGP_DIR) \
	        CFLAGS="$(ARGP_EXTRA_CFLAGS)"

$($(PKG)_LIBS_STAGING_DIR): $($(PKG)_LIBS_BUILD_DIR)
#	 $(SUBMAKE) -C $(ARGP_DIR) \
#		DESTDIR="$(TARGET_TOOLCHAIN_STAGING_DIR)" \
#		install
	cp $(ARGP_DIR)/$(ARGP_LIBNAMES_LONG) $(TARGET_TOOLCHAIN_STAGING_DIR)/usr/lib
	cp $(ARGP_DIR)/argp.h $(TARGET_TOOLCHAIN_STAGING_DIR)/usr/include

$($(PKG)_LIBS_TARGET_DIR): $(TARGET_TOOLCHAIN_STAGING_DIR)/usr/lib/$(ARGP_LIBNAMES_LONG)
	[ -e $(@D) ] || mkdir -p $(@D)
	cp $< $@

$(pkg): $($(PKG)_LIBS_STAGING_DIR)

$(pkg)-precompiled: $($(PKG)_LIBS_TARGET_DIR)

$(pkg)-clean:
	-$(SUBMAKE) -C $(ARGP_DIR) clean
	$(RM) \
		$(TARGET_TOOLCHAIN_STAGING_DIR)/usr/lib/libargp* \
		$(TARGET_TOOLCHAIN_STAGING_DIR)/usr/include/argp*

$(pkg)-uninstall:
	$(RM) \
		$(ARGP-STANDALONE_TARGET_DIR)/libargp*.a*

$(call PKG_ADD_LIB,libargp)
$(PKG_FINISH)
