$(call PKG_INIT_BIN, 0.8.2+svn953)
#$(call PKG_INIT_BIN, 0.8.2+svn973)
$(PKG)_SOURCE:=wfrog_$($(PKG)_VERSION).orig.tar.gz
$(PKG)_SOURCE_MD5:d634bd20e5870d99b98e8772a11dc493
$(PKG)_SITE:=http://archive.tanglu.org/tanglu/pool/main/w/wfrog
#$(PKG)_SITE:=http://ftp.debian.org/debian/pool/main/w/wfrog
$(PKG)_BINARY:=$($(PKG)_DIR)/wf*
$(PKG)_TARGET_BINARY:=$($(PKG)_DEST_DIR)/usr/lib/wfrog

$(PKG_SOURCE_DOWNLOAD)
$(PKG_UNPACKED)
$(PKG_CONFIGURED_NOP)

$($(PKG)_BINARY): $($(PKG)_DIR)/.configured
	

$($(PKG)_TARGET_BINARY): $($(PKG)_BINARY)
	mkdir -p $(WFROG_DEST_DIR)/usr/lib/wfrog/database
	cp -R $(WFROG_DIR)/database/csv* $(WFROG_DEST_DIR)/usr/lib/wfrog/database
	cp -R $(WFROG_DIR)/database/sql* $(WFROG_DEST_DIR)/usr/lib/wfrog/database
	cp -R $(WFROG_DIR)/wf* $(WFROG_DEST_DIR)/usr/lib/wfrog
	cp -R $(WFROG_DIR)/bin $(WFROG_DEST_DIR)/usr/lib/wfrog
	$(if $(FREETZ_PACKAGE_WFROG_WS28XX),cd $(WFROG_DEST_DIR)/usr/lib/wfrog/wfdriver/station; rm ws28xx.py; ln -s /usr/lib/wfrog/ws-28xx/wfrog/station/ws28xx.py,;:)

$(pkg):

$(pkg)-precompiled: $($(PKG)_TARGET_BINARY)

$(pkg)-clean:
	$(RM) $(WFROG_DIR)/.configured

$(pkg)-uninstall:
	$(RM) $(WFROG_TARGET_BINARY)

$(PKG_FINISH)
