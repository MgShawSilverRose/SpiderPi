#!/bin/bash
#******************************************************************************
#
# getDrupal.sh
#
# A simple script to download and install Drupal files into the correct
# location.
#
# (C) 2014 SilverRose Systems Ltd.
# License:  GNU Lesser GPL
#
#  https://www.gnu.org/licenses/lgpl.html
#****************************************************************************
#
#
# Step 1.  Download the latest Drupal
# 
cd /var/tmp
wget  http://ftp.drupal.org/files/projects/$(wget -O- http://drupal.org/project/drupal | egrep -o 'drupal-[0-9\.]+.tar.gz' | sort -V  | tail -1)
mkdir drupal
cd drupal
tar zxf ../drupal-*.gz 
#
# Step 2.  Copy it to /var/www
#
mv drupal-*/* /var/www
#
# Cleanup
#
cd /var/tmp
/bin/rm -f drupal-*.tar.gz
/bin/rm -rf /var/tmp/drupal

