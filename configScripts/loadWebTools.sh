#!/bin/bash
#
#***********************************************************************
#
# loadWebTools.sh
#
# Purpose:
#
#  A short shell script to automate loading the Apache2 and PHP stack
#  onto a Raspberry Pi running Raspbian.
#
# Notes:
#	14-04-14  Tested with Raspbian Wheezy
#
# (C) 2014 SilverRose Systems Ltd.
# License:  GNU Lesser GPL
# 
#  https://www.gnu.org/licenses/lgpl.html
#
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi
apt-get -ym update
apt-get -ym install apache2 apache2-doc apache2-utils
apt-get -ym install libapache2-mod-php5 php5 php-pear php5-xcache
apt-get -ym install php5-mysql
apt-get -ym install mysql-server mysql-client
apt-get -ym install pwgen
apt-get -ym install phpmyadmin
echo '#include phpmyadmin config' >> /etc/apache2/apache2.conf
echo 'Include /etc/phpmyadmin/apache.conf' >> /etc/apache2/apache2.conf
/etc/init.d/apache2 restart
