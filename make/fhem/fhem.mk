$(call PKG_INIT_BIN, 16562)
#$(call PKG_INIT_BIN, 5.8)
#$(PKG)_SOURCE_MD5:=7d77cf7f8a93eb00fae494bafddf1546
#$(PKG)_SITE:=http://fhem.de
$(PKG)_SOURCE:=fhem-$($(PKG)_VERSION).tar.gz
$(PKG)_SITE:=svn@https://svn.fhem.de/fhem/trunk/fhem
$(PKG)_TARGET_BINARY:=$($(PKG)_DEST_DIR)/usr/lib/fhem

$(PKG_SOURCE_DOWNLOAD)
$(PKG_UNPACKED)
$(PKG_CONFIGURED_NOP)

$(PKG)_PATCH_POST_CMDS += $(SED) -r -i -e 's|/opt|/mod/etc|g'    contrib/configDB/configDB.conf;
$(PKG)_PATCH_POST_CMDS += $(SED) -r -i -e 's|XXX.XXX.XXX.XXX|$(shell echo $(FREETZ_PACKAGE_FHEM_WITH_STV_IP) | tr -d "")|g'    regapp.pl;


$($(PKG)_TARGET_BINARY): $($(PKG)_DIR)/.unpacked
	mkdir -p $(FHEM_DEST_DIR)/usr/lib/fhem; mkdir -p $(FHEM_DEST_DIR)/etc/default.fhem
	cd $(FHEM_DIR); $(FHEM_PATCH_POST_CMDS)
	cd $(FHEM_DIR); chmod a+x regapp.pl; cp -rp fhem.cfg.demo fhem.pl FHEM www contrib configDB.pm regapp.pl $(PWD)/$@; \
	cp -p fhem.cfg $(PWD)/$(FHEM_DEST_DIR)/etc/default.fhem/fhem.cfg.default; \
	cp -p contrib/configDB/configDB.conf $(PWD)/$(FHEM_DEST_DIR)/etc/default.fhem/configDB.conf; \
	cp -p contrib/configDB/configDB.db $(PWD)/$(FHEM_DEST_DIR)/etc/default.fhem/configDB.db; \
	rm -rf $(FHEM_DEST_DIR)/usr/lib/fhem/FHEM/firmware

$(pkg):

$(pkg)-precompiled: $($(PKG)_TARGET_BINARY)

$(pkg)-clean:
	$(RM) $(FHEM_DIR)/.configured

$(pkg)-distclean: $(pkg)-uninstall
	$(RM) -rf $(FHEM_DIR)

$(pkg)-uninstall:
	$(RM) -rf $(FHEM_TARGET_BINARY)

$(PKG_FINISH)
