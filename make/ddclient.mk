###########################################################
#
# ddclient
#
###########################################################

DDCLIENT_SITE=http://$(SOURCEFORGE_MIRROR)/sourceforge/ddclient
DDCLIENT_VERSION=3.8.3
DDCLIENT_SOURCE=ddclient-$(DDCLIENT_VERSION).tar.gz
DDCLIENT_DIR=ddclient-$(DDCLIENT_VERSION)
DDCLIENT_UNZIP=zcat
DDCLIENT_MAINTAINER=NSLU2 Linux <nslu2-linux@yahoogroups.com>
DDCLIENT_DESCRIPTION=A client for updating dynamic DNS entries for accounts on a number of dynamic DNS providers.
DDCLIENT_SECTION=util
DDCLIENT_PRIORITY=optional
DDCLIENT_DEPENDS=perl, perl-file-pid
DDCLIENT_SUGGESTS=
DDCLIENT_CONFLICTS=

DDCLIENT_IPK_VERSION=3

DDCLIENT_CONFFILES=\
$(TARGET_PREFIX)/etc/ddclient/ddclient.conf \
$(TARGET_PREFIX)/etc/init.d/S95ddclient \

DDCLIENT_PATCHES=\
$(DDCLIENT_SOURCE_DIR)/ddclient_file_pid.patch \
$(DDCLIENT_SOURCE_DIR)/ddclient-opt.patch \

DDCLIENT_BUILD_DIR=$(BUILD_DIR)/ddclient
DDCLIENT_SOURCE_DIR=$(SOURCE_DIR)/ddclient
DDCLIENT_IPK_DIR=$(BUILD_DIR)/ddclient-$(DDCLIENT_VERSION)-ipk
DDCLIENT_IPK=$(BUILD_DIR)/ddclient_$(DDCLIENT_VERSION)-$(DDCLIENT_IPK_VERSION)_$(TARGET_ARCH).ipk

$(DL_DIR)/$(DDCLIENT_SOURCE):
	$(WGET) -P $(DL_DIR) $(DDCLIENT_SITE)/$(DDCLIENT_SOURCE)

ddclient-source: $(DL_DIR)/$(DDCLIENT_SOURCE) $(DDCLIENT_PATCHES)

$(DDCLIENT_BUILD_DIR)/.configured: $(DL_DIR)/$(DDCLIENT_SOURCE) $(DDCLIENT_PATCHES) make/ddclient.mk
	rm -rf $(BUILD_DIR)/$(DDCLIENT_DIR) $(DDCLIENT_BUILD_DIR)
	$(DDCLIENT_UNZIP) $(DL_DIR)/$(DDCLIENT_SOURCE) | tar -C $(BUILD_DIR) -xvf -
	cat $(DDCLIENT_PATCHES) | $(PATCH) -d $(BUILD_DIR)/$(DDCLIENT_DIR) -p1
	mv $(BUILD_DIR)/$(DDCLIENT_DIR) $(@D)
#	(cd $(DDCLIENT_BUILD_DIR); \
		$(TARGET_CONFIGURE_OPTS) \
		CPPFLAGS="$(STAGING_CPPFLAGS)" \
		LDFLAGS="$(STAGING_LDFLAGS)" \
		PERL5LIB="$(STAGING_LIB_DIR)/perl5/site_perl" \
		$(PERL_HOSTPERL) Makefile.PL \
		PREFIX=$(TARGET_PREFIX) \
	)
	touch $@

ddclient-unpack: $(DDCLIENT_BUILD_DIR)/.configured

$(DDCLIENT_BUILD_DIR)/.built: $(DDCLIENT_BUILD_DIR)/.configured
	rm -f $@
#	$(MAKE) -C $(DDCLIENT_BUILD_DIR) \
	PERL5LIB="$(STAGING_LIB_DIR)/perl5/site_perl"
	touch $@

ddclient: $(DDCLIENT_BUILD_DIR)/.built

$(DDCLIENT_BUILD_DIR)/.staged: $(DDCLIENT_BUILD_DIR)/.built
	rm -f $@
#	$(MAKE) -C $(DDCLIENT_BUILD_DIR) DESTDIR=$(STAGING_DIR) install
	touch $@

ddclient-stage: $(DDCLIENT_BUILD_DIR)/.staged

$(DDCLIENT_IPK_DIR)/CONTROL/control:
	@$(INSTALL) -d $(@D)
	@rm -f $@
	@echo "Package: ddclient" >>$@
	@echo "Architecture: $(TARGET_ARCH)" >>$@
	@echo "Priority: $(DDCLIENT_PRIORITY)" >>$@
	@echo "Section: $(DDCLIENT_SECTION)" >>$@
	@echo "Version: $(DDCLIENT_VERSION)-$(DDCLIENT_IPK_VERSION)" >>$@
	@echo "Maintainer: $(DDCLIENT_MAINTAINER)" >>$@
	@echo "Source: $(DDCLIENT_SITE)/$(DDCLIENT_SOURCE)" >>$@
	@echo "Description: $(DDCLIENT_DESCRIPTION)" >>$@
	@echo "Depends: $(DDCLIENT_DEPENDS)" >>$@
	@echo "Suggests: $(DDCLIENT_SUGGESTS)" >>$@
	@echo "Conflicts: $(DDCLIENT_CONFLICTS)" >>$@

$(DDCLIENT_IPK): $(DDCLIENT_BUILD_DIR)/.built
	rm -rf $(DDCLIENT_IPK_DIR) $(BUILD_DIR)/ddclient_*_$(TARGET_ARCH).ipk
#	$(MAKE) -C $(DDCLIENT_BUILD_DIR) DESTDIR=$(DDCLIENT_IPK_DIR) install
	$(INSTALL) -d $(DDCLIENT_IPK_DIR)$(TARGET_PREFIX)/sbin
	$(INSTALL) -m 755 $(DDCLIENT_BUILD_DIR)/ddclient $(DDCLIENT_IPK_DIR)$(TARGET_PREFIX)/sbin
	$(INSTALL) -d $(DDCLIENT_IPK_DIR)$(TARGET_PREFIX)/etc/ddclient
	$(INSTALL) -m 644 $(DDCLIENT_BUILD_DIR)/sample-etc_ddclient.conf $(DDCLIENT_IPK_DIR)$(TARGET_PREFIX)/etc/ddclient/ddclient.conf
	$(INSTALL) -d $(DDCLIENT_IPK_DIR)$(TARGET_PREFIX)/etc/init.d
	$(INSTALL) -m 755 $(DDCLIENT_SOURCE_DIR)/rc.ddclient $(DDCLIENT_IPK_DIR)$(TARGET_PREFIX)/etc/init.d/S95ddclient
	$(INSTALL) -d $(DDCLIENT_IPK_DIR)$(TARGET_PREFIX)/var/cache/ddclient
	$(INSTALL) -d $(DDCLIENT_IPK_DIR)$(TARGET_PREFIX)/var/run
	$(INSTALL) -d $(DDCLIENT_IPK_DIR)$(TARGET_PREFIX)/tmp
	$(INSTALL) -d $(DDCLIENT_IPK_DIR)$(TARGET_PREFIX)/share/doc/ddclient
	$(INSTALL) $(DDCLIENT_BUILD_DIR)/README* $(DDCLIENT_IPK_DIR)$(TARGET_PREFIX)/share/doc/ddclient
#	find $(DDCLIENT_IPK_DIR)$(TARGET_PREFIX) -name 'perllocal.pod' -exec rm -f {} \;
#	(cd $(DDCLIENT_IPK_DIR)$(TARGET_PREFIX)/lib/perl5 ; \
		find . -name '*.so' -exec chmod +w {} \; ; \
		find . -name '*.so' -exec $(STRIP_COMMAND) {} \; ; \
		find . -name '*.so' -exec chmod -w {} \; ; \
	)
#	find $(DDCLIENT_IPK_DIR)$(TARGET_PREFIX) -type d -exec chmod go+rx {} \;
	$(MAKE) $(DDCLIENT_IPK_DIR)/CONTROL/control
	echo $(DDCLIENT_CONFFILES) | sed -e 's/ /\n/g' > $(DDCLIENT_IPK_DIR)/CONTROL/conffiles
	cd $(BUILD_DIR); $(IPKG_BUILD) $(DDCLIENT_IPK_DIR)
	$(WHAT_TO_DO_WITH_IPK_DIR) $(DDCLIENT_IPK_DIR)

ddclient-ipk: $(DDCLIENT_IPK)

ddclient-clean:
	-$(MAKE) -C $(DDCLIENT_BUILD_DIR) clean

ddclient-dirclean:
	rm -rf $(BUILD_DIR)/$(DDCLIENT_DIR) $(DDCLIENT_BUILD_DIR) $(DDCLIENT_IPK_DIR) $(DDCLIENT_IPK)

ddclient-check: $(DDCLIENT_IPK)
	perl scripts/optware-check-package.pl --target=$(OPTWARE_TARGET) $^
