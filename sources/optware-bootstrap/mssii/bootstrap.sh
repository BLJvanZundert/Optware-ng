#!/bin/sh

# Replaced during packaging based on value in target-specific.mk
REAL_OPT_DIR=/mnt/.optware

if [ -e "$REAL_OPT_DIR" ] ; then
    echo "Backup your configuration settings, then type:"
    echo "  rm -rf $REAL_OPT_DIR"
    echo "  rm -rf /usr/lib/ipkg"
    echo "This will remove all existing optware packages."
    echo
    echo "You must *reboot* and then restart the bootstrap script."
    exit 1
fi

BSDIR="$REAL_OPT_DIR/ipkg-bootstrap"

echo "Creating temporary ipkg repository..."
rm -rf $BSDIR
mkdir -p $BSDIR
ln -s $BSDIR /tmp/ipkg
cat >>$BSDIR/ipkg.conf <<EOF
dest root /
lists_dir ext $BSDIR/ipkg
EOF

export IPKG_CONF_DIR=$BSDIR 
export IPKG_DIR_PREFIX=$BSDIR 

echo "Installing optware-bootstrap package..."
sh ./ipkg.sh install optware-bootstrap.ipk

echo "Installing ipkg..."
sh ./ipkg.sh install ipkg-opt.ipk

echo "Removing temporary ipkg repository..."
rm -rf $BSDIR
rm /tmp/ipkg

echo "Installing wget..."
%OPTWARE_TARGET_PREFIX%/bin/ipkg install wget.ipk || exit 1

[ ! -d %OPTWARE_TARGET_PREFIX%/etc/ipkg ] && mkdir -p %OPTWARE_TARGET_PREFIX%/etc/ipkg
if [ ! -e %OPTWARE_TARGET_PREFIX%/etc/ipkg/cross-feed.conf ]
then
	echo "Creating %OPTWARE_TARGET_PREFIX%/etc/ipkg/armel-feed.conf..."
	echo "src/gz armel http://ipkg.nslu2-linux.org/feeds/optware/cs05q3armel/cross/stable" >%OPTWARE_TARGET_PREFIX%/etc/ipkg/armel-feed.conf
fi
if [ ! -e %OPTWARE_TARGET_PREFIX%/etc/ipkg/mssii-feed.conf ]
then
	echo "Creating %OPTWARE_TARGET_PREFIX%/etc/ipkg/mssii-feed.conf..."
	echo "src/gz mssii http://ipkg.nslu2-linux.org/feeds/optware/mssii/cross/stable" >%OPTWARE_TARGET_PREFIX%/etc/ipkg/mssii-feed.conf
fi

echo "Setup complete."
