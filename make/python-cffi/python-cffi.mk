$(call PKG_INIT_BIN, 1.8)
$(PKG)_SOURCE:=release-$($(PKG)_VERSION).tar.gz
$(PKG)_SOURCE_MD5:=200d99032199e0e54b466f073cb7830d
$(PKG)_SOURCE_COMMIT:=20e7bc5ffd1e
$(PKG)_SITE:=https://bitbucket.org/cffi/cffi/get

$(PKG)_DIR:=$($(PKG)_SOURCE_DIR)/cffi-cffi-$($(PKG)_SOURCE_COMMIT)

$(PKG)_TARGET_BINARY:=$($(PKG)_DEST_DIR)$(PYTHON_SITE_PKG_DIR)/_cffi_backend.so

$(PKG)_DEPENDS_ON += python

$(PKG)_REBUILD_SUBOPTS += FREETZ_PACKAGE_PYTHON_STATIC

$(PKG_SOURCE_DOWNLOAD)
$(PKG_UNPACKED)
$(PKG_CONFIGURED_NOP)

$($(PKG)_TARGET_BINARY): $($(PKG)_DIR)/.configured
	if [ ! -e /usr/bin/wget  -a  ! -e /usr/bin/curl ]; then \
	echo "You need either native wget or curl to build python-mock, do: sudo apt install curl wget"; exit -1; \
	fi; \
	$(call Build/PyMod/PKG, PYTHON_CFFI); \
	cd $(FREETZ_BASE_DIR); \
	cp -fa $(dir $@)/cffi-*egg-info $(TARGET_TOOLCHAIN_STAGING_DIR)/lib/python2.7/site-packages; \
	cp -Rfa $(dir $@)/cffi $(TARGET_TOOLCHAIN_STAGING_DIR)/lib/python2.7/site-packages; \

$(pkg):

$(pkg)-precompiled: $($(PKG)_TARGET_BINARY)

$(pkg)-clean:
	$(RM) -r $(PYTHON_CFFI_DIR)/build

$(pkg)-uninstall:
	$(RM) -r \
		$(PYTHON_CFFI_DEST_DIR)$(PYTHON_SITE_PKG_DIR)/cffi \
		$(PYTHON_CFFI_DEST_DIR)$(PYTHON_SITE_PKG_DIR)/cffi-*.egg-info

$(PKG_FINISH)
