$(call PKG_INIT_BIN, 76440258eb5e)
$(PKG)_SOURCE:=$($(PKG)_VERSION).zip
$(PKG)_SOURCE_MD5:=59eecddc5d981cbbd7206f6dd7a3b4d7
$(PKG)_SITE:=https://bitbucket.org/brandon/backports.ssl_match_hostname/get

$(PKG)_DIR:=$($(PKG)_SOURCE_DIR)/backports.ssl_match_hostname-$($(PKG)_VERSION)

$(PKG)_TARGET_BINARY:=$($(PKG)_DEST_DIR)$(PYTHON_SITE_PKG_DIR)/backports

$(PKG)_DEPENDS_ON += python

$(PKG)_REBUILD_SUBOPTS += FREETZ_PACKAGE_PYTHON_STATIC

$(PKG_SOURCE_DOWNLOAD)
$(PKG_UNPACKED)
$(PKG_CONFIGURED_NOP)

$($(PKG)_TARGET_BINARY): $($(PKG)_DIR)/.configured
	$(call Build/PyMod/PKG, PYTHON_BACKPORTS_SSL_MATCH_HOSTNAME) && \
	touch $@

$(pkg):

$(pkg)-precompiled: $($(PKG)_TARGET_BINARY)

$(pkg)-clean:
	$(RM) -r $(PYTHON_BACKPORTS_SSL_MATCH_HOSTNAME_DIR)/build

$(pkg)-uninstall:
	$(RM) -r \
		$(PYTHON_BACKPORTS_SSL_MATCH_HOSTNAME_DEST_DIR)$(PYTHON_SITE_PKG_DIR)/backports \
		$(PYTHON_BACKPORTS_SSL_MATCH_HOSTNAME_DEST_DIR)$(PYTHON_SITE_PKG_DIR)/backports.ssl_match_hostname-*.egg-info

$(PKG_FINISH)
