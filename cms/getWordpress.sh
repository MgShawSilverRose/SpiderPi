#!/bin/sh
#******************************************************************************
#
# getWordpress.sh
#
# A simple script to download and install wordpress files into the correct
# location.
#
# (C) 2014 SilverRose Systems Ltd.
# License:  GNU Lesser GPL
# 
#  https://www.gnu.org/licenses/lgpl.html
#******************************************************************************
#
#
# Get the wordpress source 
#
cd /var/tmp
wget http://wordpress.org/latest.tar.gz
if [ ! -e latest.tar.gz ]; then
   echo "Download of wordpress failed"
   exit 1
fi
tar zxf latest.tar.gz
mv wordpress/* /var/www
#
# Cleanup
/bin/rm -rf /var/tmp/wordpress
/bin/rm -f /var/tmp/latest.tar.gz
#
# Start Configuration 
#
# Create Database on MySQL
#
# Create User on MySQL
#

