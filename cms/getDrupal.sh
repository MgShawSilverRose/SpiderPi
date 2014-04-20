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
# If we aren't root, exit before we do any real damage
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi
#
mysqlPwd=$1
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
/bin/rm -rf /var/www/*
mv drupal-*/* /var/www
#
# Cleanup
#
cd /var/tmp
/bin/rm -f drupal-*.tar.gz
/bin/rm -rf /var/tmp/drupal
#
# Step 2.  Create The MySQL Database
#
# Create Database on MySQL
#
dbnameSuffix=`pwgen -1`
dbname="dru_$dbnameSuffix"
sqlCmd="CREATE DATABASE $dbname"
mysql --user=root --password=$mysqlPwd -e "$sqlCmd" mysql
#
# Create User on MySQL
#
dbuser="dru_$dbnameSuffix"
dbpass=`pwgen -1`
sqlCmd1="CREATE USER $dbuser@localhost IDENTIFIED BY '$dbpass'"
sqlCmd2="GRANT ALL on $dbname.* to '$dbuser'@'localhost'"
mysql --user=root --password=$mysqlPwd -e "$sqlCmd1"
mysql --user=root --password=$mysqlPwd -e "$sqlCmd2"
#
# Record Configuration for user reference
#
echo "Drupal Database Name=$dbname" > /var/tmp/drupalConfig.txt
echo "Drupal Database User=$dbuser" >> /var/tmp/drupalConfig.txt
echo "Drupal Database User Password=$dbpass" >> /var/tmp/drupalConfig.txt
#
# Step 3.  Create Settings.php File
#
cp /var/www/sites/default/default.settings.php /var/www/sites/default/settings.php
chmod a+w /var/sites/
#
# 
cp /var/tmp/drupalConfig.txt ~pi
chown pi ~pi/drupalConfig.txt
cat ~pi/drupalConfig.txt
