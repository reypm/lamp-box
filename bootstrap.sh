#!/usr/bin/env bash

sudo yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-6.noarch.rpm
sudo yum update kernel -y
sudo yum update -y && yum upgrade && yum install -y cowsay

cowsay Begin installing everything, grab a coffe and keep calm .... please wait

sudo yum install -y httpd mod_ssl wget net-tools mc php php-mysql php-mssql php-pdo php-gd php-soap php-mbstring php-mcrypt php-pear php-devel php-dom gcc libmpc mpfr cpp htop
sudo chkconfig --add httpd && chkconfig httpd on
sudo pecl install xdebug-2.2.7

cd /tmp || return
sudo wget -q https://dev.mysql.com/get/mysql57-community-release-el6-11.noarch.rpm
sudo yum install -y mysql57-community-release-el6-11.noarch.rpm
sudo yum -y update && yum -y install mysql-community-server
sudo chkconfig --add mysqld && chkconfig mysqld on
sudo service mysqld start

MYSQL_TEMP_PWD=$(sudo awk '/A temporary password/{print $NF}' /var/log/mysqld.log)
mysql -u root --password="$MYSQL_TEMP_PWD" --connect-expired-password -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '.Q^R4)*]Lr8MQg|V';uninstall plugin validate_password;CREATE USER 'root'@'%';GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;DROP USER 'root'@'localhost';CREATE USER 'root'@'localhost';GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' WITH GRANT OPTION;FLUSH PRIVILEGES;"
{ echo "sql_mode=''"; echo "max_allowed_packet=1G"; echo "innodb_buffer_pool_size=1G"; echo "key_buffer_size=64M"; echo "innodb_log_file_size=256M"; echo "early-plugin-load=keyring_file.so"; } >> /etc/my.cnf

sudo service mysqld restart
cd /tmp || return
sudo wget -q https://www.pdflabs.com/tools/pdftk-the-pdf-toolkit/pdftk-2.02-1.el6.x86_64.rpm
sudo yum install -y pdftk-2.02-1.el6.x86_64.rpm
sudo rm -f pdftk-2.02-1.el6.x86_64.rpm
sudo wget -q https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.5/wkhtmltox-0.12.5-1.centos6.x86_64.rpm
sudo yum install -y wkhtmltox-0.12.5-1.centos6.x86_64.rpm
sudo rm -f wkhtmltox-0.12.5-1.centos6.x86_64.rpm

sudo cp -rf /vagrant/files/zz-custom.ini /etc/php.d/zz-custom.ini
sudo cp -rf /vagrant/files/xdebug.ini /etc/php.d/xdebug.ini
sudo cp -rf /vagrant/files/selinux_config /etc/selinux/config

sudo cp -rf /etc/localtime /root/old.timezone
sudo rm -rf /etc/localtime
sudo ln -s /usr/share/zoneinfo/America/New_York /etc/localtime

sudo mkdir -p /var/lib/php/session/
sudo chown -R apache:apache -R /var/lib/php/session/
sudo service httpd restart

cowsay Cleaning the house ....

# shellcheck disable=SC1091
source /vagrant/files/cleanup.sh .
