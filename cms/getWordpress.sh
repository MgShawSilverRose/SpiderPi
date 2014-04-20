#!/bin/sh
#******************************************************************************
#
# getWordpress.sh
#
# A simple script to download and install wordpress files into the correct
# location.
#
# Files Created:
#    /var/tmp/wordpressConfig.txt
#
# Directories Modified:
#   /var/www
#
# (C) 2014 SilverRose Systems Ltd.
# License:  GNU Lesser GPL
# 
#  https://www.gnu.org/licenses/lgpl.html
#******************************************************************************
# If we aren't root, exit before we do any real damage
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi
#
# 
mysqlPwd=$1
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
/bin/rm -rf /var/www/*
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
dbnameSuffix=`pwgen -1`
dbname="wp_$dbnameSuffix"
sqlCmd="CREATE DATABASE $dbname"
mysql --user=root --password=$mysqlPwd -e "$sqlCmd" mysql
#
# Create User on MySQL
#
dbuser="uwp_$dbnameSuffix"
dbpass=`pwgen -1`
sqlCmd1="CREATE USER $dbuser@localhost IDENTIFIED BY '$dbpass'" 
sqlCmd2="GRANT ALL on $dbname.* to '$dbuser'@'localhost'"
mysql --user=root --password=$mysqlPwd -e "$sqlCmd1"
mysql --user=root --password=$mysqlPwd -e "$sqlCmd2"
#
# Record Configuration for user reference
#
echo "Wordpress Database Name=$dbname" > /var/tmp/wordpressConfig.txt
echo "Wordpress Database User=$dbuser" >> /var/tmp/wordpressConfig.txt
echo "Wordpress Database User Password=$dbpass" >> /var/tmp/wordpressConfig.txt
cp /var/tmp/wordpressConfig.txt ~pi
chown pi ~pi/wordpressConfig.txt
/bin/rm -f /var/tmp/wordpressConfig.txt
cat ~pi/wordpressConfig.txt
