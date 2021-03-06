###########################################################
#
# py-silvercity
#
###########################################################

#
# PY-SILVERCITY_VERSION, PY-SILVERCITY_SITE and PY-SILVERCITY_SOURCE define
# the upstream location of the source code for the package.
# PY-SILVERCITY_DIR is the directory which is created when the source
# archive is unpacked.
# PY-SILVERCITY_UNZIP is the command used to unzip the source.
# It is usually "zcat" (for .gz) or "bzcat" (for .bz2)
#
# You should change all these variables to suit your package.
# Please make sure that you add a description, and that you
# list all your packages' dependencies, seperated by commas.
# 
# If you list yourself as MAINTAINER, please give a valid email
# address, and indicate your irc nick if it cannot be easily deduced
# from your name or email address.  If you leave MAINTAINER set to
# "NSLU2 Linux" other developers will feel free to edit.
#
PY-SILVERCITY_VERSION=0.9.7
PY-SILVERCITY_SITE=http://$(SOURCEFORGE_MIRROR)/sourceforge/silvercity
PY-SILVERCITY_SOURCE=SilverCity-$(PY-SILVERCITY_VERSION).tar.gz
PY-SILVERCITY_DIR=SilverCity-$(PY-SILVERCITY_VERSION)
PY-SILVERCITY_UNZIP=zcat
PY-SILVERCITY_MAINTAINER=NSLU2 Linux <nslu2-linux@yahoogroups.com>
PY-SILVERCITY_DESCRIPTION=SilverCity is a lexing package, based on Scintilla, that can provide lexical analysis for over 20 programming and markup langauges.
PY-SILVERCITY_SECTION=misc
PY-SILVERCITY_PRIORITY=optional
PY24-SILVERCITY_DEPENDS=python24
PY25-SILVERCITY_DEPENDS=python25
PY-SILVERCITY_CONFLICTS=

#
# PY-SILVERCITY_IPK_VERSION should be incremented when the ipk changes.
#
PY-SILVERCITY_IPK_VERSION=1

#
# PY-SILVERCITY_CONFFILES should be a list of user-editable files
#PY-SILVERCITY_CONFFILES=$(TARGET_PREFIX)/etc/py-silvercity.conf $(TARGET_PREFIX)/etc/init.d/SXXpy-silvercity

#
# PY-SILVERCITY_PATCHES should list any patches, in the the order in
# which they should be applied to the source code.
#
#PY-SILVERCITY_PATCHES=$(PY-SILVERCITY_SOURCE_DIR)/configure.patch

#
# If the compilation of the package requires additional
# compilation or linking flags, then list them here.
#
PY-SILVERCITY_CPPFLAGS=
PY-SILVERCITY_LDFLAGS=

#
# PY-SILVERCITY_BUILD_DIR is the directory in which the build is done.
# PY-SILVERCITY_SOURCE_DIR is the directory which holds all the
# patches and ipkg control files.
# PY-SILVERCITY_IPK_DIR is the directory in which the ipk is built.
# PY-SILVERCITY_IPK is the name of the resulting ipk files.
#
# You should not change any of these variables.
#
PY-SILVERCITY_BUILD_DIR=$(BUILD_DIR)/py-silvercity
PY-SILVERCITY_SOURCE_DIR=$(SOURCE_DIR)/py-silvercity

PY24-SILVERCITY_IPK_DIR=$(BUILD_DIR)/py-silvercity-$(PY-SILVERCITY_VERSION)-ipk
PY24-SILVERCITY_IPK=$(BUILD_DIR)/py-silvercity_$(PY-SILVERCITY_VERSION)-$(PY-SILVERCITY_IPK_VERSION)_$(TARGET_ARCH).ipk

PY25-SILVERCITY_IPK_DIR=$(BUILD_DIR)/py25-silvercity-$(PY-SILVERCITY_VERSION)-ipk
PY25-SILVERCITY_IPK=$(BUILD_DIR)/py25-silvercity_$(PY-SILVERCITY_VERSION)-$(PY-SILVERCITY_IPK_VERSION)_$(TARGET_ARCH).ipk

.PHONY: py-silvercity-source py-silvercity-unpack py-silvercity py-silvercity-stage py-silvercity-ipk py-silvercity-clean py-silvercity-dirclean py-silvercity-check

#
# This is the dependency on the source code.  If the source is missing,
# then it will be fetched from the site using wget.
#
$(DL_DIR)/$(PY-SILVERCITY_SOURCE):
	$(WGET) -P $(DL_DIR) $(PY-SILVERCITY_SITE)/$(PY-SILVERCITY_SOURCE)

#
# The source code depends on it existing within the download directory.
# This target will be called by the top level Makefile to download the
# source code's archive (.tar.gz, .bz2, etc.)
#
py-silvercity-source: $(DL_DIR)/$(PY-SILVERCITY_SOURCE) $(PY-SILVERCITY_PATCHES)

#
# This target unpacks the source code in the build directory.
# If the source archive is not .tar.gz or .tar.bz2, then you will need
# to change the commands here.  Patches to the source code are also
# applied in this target as required.
#
# This target also configures the build within the build directory.
# Flags such as LDFLAGS and CPPFLAGS should be passed into configure
# and NOT $(MAKE) below.  Passing it to configure causes configure to
# correctly BUILD the Makefile with the right paths, where passing it
# to Make causes it to override the default search paths of the compiler.
#
# If the compilation of the package requires other packages to be staged
# first, then do that first (e.g. "$(MAKE) <bar>-stage <baz>-stage").
#
$(PY-SILVERCITY_BUILD_DIR)/.configured: $(DL_DIR)/$(PY-SILVERCITY_SOURCE) $(PY-SILVERCITY_PATCHES)
	$(MAKE) py-setuptools-stage
	rm -rf $(BUILD_DIR)/$(PY-SILVERCITY_DIR) $(PY-SILVERCITY_BUILD_DIR)
	mkdir -p $(PY-SILVERCITY_BUILD_DIR)
	# 2.4
	$(PY-SILVERCITY_UNZIP) $(DL_DIR)/$(PY-SILVERCITY_SOURCE) | tar -C $(BUILD_DIR) -xvf -
#	cat $(PY-SILVERCITY_PATCHES) | $(PATCH) -d $(BUILD_DIR)/$(PY-SILVERCITY_DIR) -p1
	mv $(BUILD_DIR)/$(PY-SILVERCITY_DIR) $(PY-SILVERCITY_BUILD_DIR)/2.4
	(cd $(PY-SILVERCITY_BUILD_DIR)/2.4; \
	    ( \
		echo "[build_ext]"; \
	        echo "include-dirs=$(STAGING_INCLUDE_DIR):$(STAGING_INCLUDE_DIR)/python2.4"; \
	        echo "library-dirs=$(STAGING_LIB_DIR)"; \
	        echo "rpath=$(TARGET_PREFIX)/lib"; \
		echo "[build_scripts]"; \
		echo "executable=$(TARGET_PREFIX)/bin/python2.4"; \
		echo "[install]"; \
		echo "install_scripts=$(TARGET_PREFIX)/bin"; \
	    ) >> setup.cfg; \
	)
	# 2.5
	$(PY-SILVERCITY_UNZIP) $(DL_DIR)/$(PY-SILVERCITY_SOURCE) | tar -C $(BUILD_DIR) -xvf -
#	cat $(PY-SILVERCITY_PATCHES) | $(PATCH) -d $(BUILD_DIR)/$(PY-SILVERCITY_DIR) -p1
	mv $(BUILD_DIR)/$(PY-SILVERCITY_DIR) $(PY-SILVERCITY_BUILD_DIR)/2.5
	(cd $(PY-SILVERCITY_BUILD_DIR)/2.5; \
	    ( \
		echo "[build_ext]"; \
	        echo "include-dirs=$(STAGING_INCLUDE_DIR):$(STAGING_INCLUDE_DIR)/python2.5"; \
	        echo "library-dirs=$(STAGING_LIB_DIR)"; \
	        echo "rpath=$(TARGET_PREFIX)/lib"; \
		echo "[build_scripts]"; \
		echo "executable=$(TARGET_PREFIX)/bin/python2.5"; \
		echo "[install]"; \
		echo "install_scripts=$(TARGET_PREFIX)/bin"; \
	    ) >> setup.cfg; \
	)
	touch $(PY-SILVERCITY_BUILD_DIR)/.configured

py-silvercity-unpack: $(PY-SILVERCITY_BUILD_DIR)/.configured

#
# This builds the actual binary.
#
$(PY-SILVERCITY_BUILD_DIR)/.built: $(PY-SILVERCITY_BUILD_DIR)/.configured
	rm -f $(PY-SILVERCITY_BUILD_DIR)/.built
	cd $(PY-SILVERCITY_BUILD_DIR)/2.4; \
	    $(TARGET_CONFIGURE_OPTS) LDSHARED='$(TARGET_CC) -shared' \
	    $(HOST_STAGING_PREFIX)/bin/python2.4 setup.py build
	cd $(PY-SILVERCITY_BUILD_DIR)/2.5; \
	    $(TARGET_CONFIGURE_OPTS) LDSHARED='$(TARGET_CC) -shared' \
	    $(HOST_STAGING_PREFIX)/bin/python2.5 setup.py build
	touch $(PY-SILVERCITY_BUILD_DIR)/.built

#
# This is the build convenience target.
#
py-silvercity: $(PY-SILVERCITY_BUILD_DIR)/.built

#
# If you are building a library, then you need to stage it too.
#
$(PY-SILVERCITY_BUILD_DIR)/.staged: $(PY-SILVERCITY_BUILD_DIR)/.built
	rm -f $(PY-SILVERCITY_BUILD_DIR)/.staged
#	$(MAKE) -C $(PY-SILVERCITY_BUILD_DIR) DESTDIR=$(STAGING_DIR) install
	touch $(PY-SILVERCITY_BUILD_DIR)/.staged

py-silvercity-stage: $(PY-SILVERCITY_BUILD_DIR)/.staged

#
# This rule creates a control file for ipkg.  It is no longer
# necessary to create a seperate control file under sources/py-silvercity
#
$(PY24-SILVERCITY_IPK_DIR)/CONTROL/control:
	@$(INSTALL) -d $(@D)
	@rm -f $@
	@echo "Package: py-silvercity" >>$@
	@echo "Architecture: $(TARGET_ARCH)" >>$@
	@echo "Priority: $(PY-SILVERCITY_PRIORITY)" >>$@
	@echo "Section: $(PY-SILVERCITY_SECTION)" >>$@
	@echo "Version: $(PY-SILVERCITY_VERSION)-$(PY-SILVERCITY_IPK_VERSION)" >>$@
	@echo "Maintainer: $(PY-SILVERCITY_MAINTAINER)" >>$@
	@echo "Source: $(PY-SILVERCITY_SITE)/$(PY-SILVERCITY_SOURCE)" >>$@
	@echo "Description: $(PY-SILVERCITY_DESCRIPTION)" >>$@
	@echo "Depends: $(PY24-SILVERCITY_DEPENDS)" >>$@
	@echo "Conflicts: $(PY-SILVERCITY_CONFLICTS)" >>$@

$(PY25-SILVERCITY_IPK_DIR)/CONTROL/control:
	@$(INSTALL) -d $(@D)
	@rm -f $@
	@echo "Package: py25-silvercity" >>$@
	@echo "Architecture: $(TARGET_ARCH)" >>$@
	@echo "Priority: $(PY-SILVERCITY_PRIORITY)" >>$@
	@echo "Section: $(PY-SILVERCITY_SECTION)" >>$@
	@echo "Version: $(PY-SILVERCITY_VERSION)-$(PY-SILVERCITY_IPK_VERSION)" >>$@
	@echo "Maintainer: $(PY-SILVERCITY_MAINTAINER)" >>$@
	@echo "Source: $(PY-SILVERCITY_SITE)/$(PY-SILVERCITY_SOURCE)" >>$@
	@echo "Description: $(PY-SILVERCITY_DESCRIPTION)" >>$@
	@echo "Depends: $(PY25-SILVERCITY_DEPENDS)" >>$@
	@echo "Conflicts: $(PY-SILVERCITY_CONFLICTS)" >>$@

#
# This builds the IPK file.
#
# Binaries should be installed into $(PY-SILVERCITY_IPK_DIR)$(TARGET_PREFIX)/sbin or $(PY-SILVERCITY_IPK_DIR)$(TARGET_PREFIX)/bin
# (use the location in a well-known Linux distro as a guide for choosing sbin or bin).
# Libraries and include files should be installed into $(PY-SILVERCITY_IPK_DIR)$(TARGET_PREFIX)/{lib,include}
# Configuration files should be installed in $(PY-SILVERCITY_IPK_DIR)$(TARGET_PREFIX)/etc/py-silvercity/...
# Documentation files should be installed in $(PY-SILVERCITY_IPK_DIR)$(TARGET_PREFIX)/doc/py-silvercity/...
# Daemon startup scripts should be installed in $(PY-SILVERCITY_IPK_DIR)$(TARGET_PREFIX)/etc/init.d/S??py-silvercity
#
# You may need to patch your application to make it use these locations.
#
$(PY24-SILVERCITY_IPK) $(PY25-SILVERCITY_IPK): $(PY-SILVERCITY_BUILD_DIR)/.built
	# 2.4
	rm -rf $(PY24-SILVERCITY_IPK_DIR) $(BUILD_DIR)/py-silvercity_*_$(TARGET_ARCH).ipk
	cd $(PY-SILVERCITY_BUILD_DIR)/2.4; \
	    $(HOST_STAGING_PREFIX)/bin/python2.4 setup.py install \
	    --root=$(PY24-SILVERCITY_IPK_DIR) --prefix=$(TARGET_PREFIX)
	$(STRIP_COMMAND) $(PY24-SILVERCITY_IPK_DIR)$(TARGET_PREFIX)/lib/python2.4/site-packages/SilverCity/*.so
	for f in $(PY24-SILVERCITY_IPK_DIR)$(TARGET_PREFIX)/*bin/*; \
		do mv $$f `echo $$f | sed 's|$$|-2.4|'`; done
	$(MAKE) $(PY24-SILVERCITY_IPK_DIR)/CONTROL/control
	cd $(BUILD_DIR); $(IPKG_BUILD) $(PY24-SILVERCITY_IPK_DIR)
	# 2.5
	rm -rf $(PY25-SILVERCITY_IPK_DIR) $(BUILD_DIR)/py25-silvercity_*_$(TARGET_ARCH).ipk
	cd $(PY-SILVERCITY_BUILD_DIR)/2.5; \
	    $(HOST_STAGING_PREFIX)/bin/python2.5 setup.py install \
	    --root=$(PY25-SILVERCITY_IPK_DIR) --prefix=$(TARGET_PREFIX)
	$(STRIP_COMMAND) $(PY25-SILVERCITY_IPK_DIR)$(TARGET_PREFIX)/lib/python2.5/site-packages/SilverCity/*.so
	$(MAKE) $(PY25-SILVERCITY_IPK_DIR)/CONTROL/control
	cd $(BUILD_DIR); $(IPKG_BUILD) $(PY25-SILVERCITY_IPK_DIR)

#
# This is called from the top level makefile to create the IPK file.
#
py-silvercity-ipk: $(PY24-SILVERCITY_IPK) $(PY25-SILVERCITY_IPK)

#
# This is called from the top level makefile to clean all of the built files.
#
py-silvercity-clean:
	-$(MAKE) -C $(PY-SILVERCITY_BUILD_DIR) clean

#
# This is called from the top level makefile to clean all dynamically created
# directories.
#
py-silvercity-dirclean:
	rm -rf $(BUILD_DIR)/$(PY-SILVERCITY_DIR) $(PY-SILVERCITY_BUILD_DIR)
	rm -rf $(PY24-SILVERCITY_IPK_DIR) $(PY24-SILVERCITY_IPK)
	rm -rf $(PY25-SILVERCITY_IPK_DIR) $(PY25-SILVERCITY_IPK)

#
# Some sanity check for the package.
#
py-silvercity-check: $(PY24-SILVERCITY_IPK) $(PY25-SILVERCITY_IPK)
	perl scripts/optware-check-package.pl --target=$(OPTWARE_TARGET) $(PY24-SILVERCITY_IPK) $(PY25-SILVERCITY_IPK)
