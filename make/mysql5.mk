###########################################################
#
# mysql
#
###########################################################

# You must replace "mysql" and "MYSQL5" with the lower case name and
# upper case name of your new package.  Some places below will say
# "Do not change this" - that does not include this global change,
# which must always be done to ensure we have unique names.

#
# MYSQL5_VERSION, MYSQL5_SITE and MYSQL5_SOURCE define
# the upstream location of the source code for the package.
# MYSQL5_DIR is the directory which is created when the source
# archive is unpacked.
# MYSQL5_UNZIP is the command used to unzip the source.
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

MYSQL5_VERSION = $(MYSQL_VERSION)

MYSQL5_SOURCE=$(MYSQL_SOURCE)
MYSQL5_DIR=mysql-$(MYSQL5_VERSION)
MYSQL5_UNZIP=zcat
MYSQL5_MAINTAINER=NSLU2 Linux <nslu2-linux@yahoogroups.com>
MYSQL5_DESCRIPTION=Popular free SQL database system. This is a dummy package that install 'mysql' package
MYSQL5_SECTION=misc
MYSQL5_PRIORITY=optional
MYSQL5_DEPENDS=mysql
MYSQL5_CONFLICTS=

#
# MYSQL5_IPK_VERSION should be incremented when the ipk changes.
#
MYSQL5_IPK_VERSION=1

#
# MYSQL5_CONFFILES should be a list of user-editable files
#MYSQL5_CONFFILES=$(TARGET_PREFIX)/etc/my.cnf

#
# MYSQL5_PATCHES should list any patches, in the the order in
# which they should be applied to the source code.
#
#MYSQL5_PATCHES=$(MYSQL5_SOURCE_DIR)/configure-$(MYSQL5_VERSION).patch

#
# If the compilation of the package requires additional
# compilation or linking flags, then list them here.
#
MYSQL5_CPPFLAGS ?=
MYSQL5_LDFLAGS="-Wl,-rpath,$(TARGET_PREFIX)/lib/mysql"
MYSQL5_CONFIG_ENV=ac_cv_sys_restartable_syscalls=yes
MYSQL5_CONFIG_ENV += $(strip \
$(if $(filter arm armeb, $(TARGET_ARCH)), ac_cv_c_stack_direction=1, \
))
MYSQL5_CONFIG_ENV += $(MYSQL5_CONFIG_ENV_EXTRA)

#
# MYSQL5_BUILD_DIR is the directory in which the build is done.
# MYSQL5_SOURCE_DIR is the directory which holds all the
# patches and ipkg control files.
# MYSQL5_IPK_DIR is the directory in which the ipk is built.
# MYSQL5_IPK is the name of the resulting ipk files.
#
# You should not change any of these variables.
#
MYSQL5_SOURCE_DIR=$(SOURCE_DIR)/mysql5
MYSQL5_BUILD_DIR=$(BUILD_DIR)/mysql5
MYSQL5_HOST_BUILD_DIR=$(HOST_BUILD_DIR)/mysql5

MYSQL5_IPK_DIR=$(BUILD_DIR)/mysql5-ipk
MYSQL5_IPK=$(BUILD_DIR)/mysql5_$(MYSQL5_VERSION)-$(MYSQL5_IPK_VERSION)_$(TARGET_ARCH).ipk

#
# The source code depends on it existing within the download directory.
# This target will be called by the top level Makefile to download the
# source code's archive (.tar.gz, .bz2, etc.)
#
mysql5-source: $(DL_DIR)/$(MYSQL5_SOURCE) $(MYSQL5_PATCHES)

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
$(MYSQL5_BUILD_DIR)/.configured: $(MYSQL5_PATCHES) $(DL_DIR)/$(MYSQL5_SOURCE) make/mysql5.mk
	$(INSTALL) -d $(@D)
	touch $@

mysql5-unpack: $(MYSQL5_BUILD_DIR)/.configured

#
# This builds the actual binary.
#
$(MYSQL5_BUILD_DIR)/.built: #$(MYSQL5_BUILD_DIR)/.configured
	rm -f $@
	$(MAKE) mysql
	touch $@

#
# This is the build convenience target.
#
mysql5: $(MYSQL5_BUILD_DIR)/.built

#
# If you are building a library, then you need to stage it too.
#
$(MYSQL5_BUILD_DIR)/.staged: #$(MYSQL5_BUILD_DIR)/.built
	rm -f $@
	$(MAKE) mysql-stage
	touch $@

mysql5-stage: $(MYSQL5_BUILD_DIR)/.staged

#
# This rule creates a control file for ipkg.  It is no longer
# necessary to create a seperate control file under sources/mysql
#
$(MYSQL5_IPK_DIR)/CONTROL/control:
	@$(INSTALL) -d $(@D)
	@rm -f $@
	@echo "Package: mysql5" >>$@
	@echo "Architecture: $(TARGET_ARCH)" >>$@
	@echo "Priority: $(MYSQL5_PRIORITY)" >>$@
	@echo "Section: $(MYSQL5_SECTION)" >>$@
	@echo "Version: $(MYSQL5_VERSION)-$(MYSQL5_IPK_VERSION)" >>$@
	@echo "Maintainer: $(MYSQL5_MAINTAINER)" >>$@
	@echo "Source: $(MYSQL5_SITE)/$(MYSQL5_SOURCE)" >>$@
	@echo "Description: $(MYSQL5_DESCRIPTION)" >>$@
	@echo "Depends: $(MYSQL5_DEPENDS)" >>$@
	@echo "Conflicts: $(MYSQL5_CONFLICTS)" >>$@

#
# This builds the IPK file.
#
# Binaries should be installed into $(MYSQL5_IPK_DIR)$(TARGET_PREFIX)/sbin or $(MYSQL5_IPK_DIR)$(TARGET_PREFIX)/bin
# (use the location in a well-known Linux distro as a guide for choosing sbin or bin).
# Libraries and include files should be installed into $(MYSQL5_IPK_DIR)$(TARGET_PREFIX)/{lib,include}
# Configuration files should be installed in $(MYSQL5_IPK_DIR)$(TARGET_PREFIX)/etc/mysql/...
# Documentation files should be installed in $(MYSQL5_IPK_DIR)$(TARGET_PREFIX)/doc/mysql/...
# Daemon startup scripts should be installed in $(MYSQL5_IPK_DIR)$(TARGET_PREFIX)/etc/init.d/S??mysql
#
# You may need to patch your application to make it use these locations.
#
$(MYSQL5_IPK_DIR)/.packaged: make/mysql5.mk make/mysql.mk #$(MYSQL5_BUILD_DIR)/.built
	rm -rf $(MYSQL5_IPK_DIR) $(BUILD_DIR)/mysql5_*_$(TARGET_ARCH).ipk
	$(MAKE) $(MYSQL5_IPK_DIR)/CONTROL/control
	cd $(BUILD_DIR); $(IPKG_BUILD) $(MYSQL5_IPK_DIR)
	touch $@

#
# This is called from the top level makefile to create the IPK file.
#
mysql5-ipk: $(MYSQL5_IPK_DIR)/.packaged

#
# This is called from the top level makefile to clean all of the built files.
#
mysql5-clean:
	-$(MAKE) -C $(MYSQL5_BUILD_DIR) clean
	-$(MAKE) -C $(MYSQL5_HOST_BUILD_DIR) clean

#
# This is called from the top level makefile to clean all dynamically created
# directories.
#
mysql5-dirclean:
	rm -rf $(BUILD_DIR)/$(MYSQL5_DIR) $(MYSQL5_BUILD_DIR) $(MYSQL5_IPK_DIR) $(MYSQL5_IPK)
	rm -rf $(MYSQL5_HOST_BUILD_DIR)

#
# Some sanity check for the package.
#
mysql5-check: $(MYSQL5_IPK)
	perl scripts/optware-check-package.pl --target=$(OPTWARE_TARGET) $^
