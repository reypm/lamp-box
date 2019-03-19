#!/usr/bin/env bash

if [ "$(ls -A /vagrant/files/db)" ]; then
   cowsay Importing MySQL databases .... please wait

   cd /vagrant/files/db || return
   for sql_file in *.sql;
   		do mysql -uroot < "$sql_file";
   done
fi

cowsay Creating VirtualHost .... please wait

sudo cp -rf /vagrant/files/custom-httpd.conf /etc/httpd/conf.d/custom-httpd.conf
sudo cp -rf /vagrant/files/vhosts.conf /etc/httpd/conf.d
sudo service httpd restart

cowsay Cleaning the house .... please wait

# shellcheck disable=SC1091
source /vagrant/files/cleanup.sh .
