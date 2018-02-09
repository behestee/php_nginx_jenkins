#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive

if ! [ -L /var/www/php_nginx_jenkins ]; then
  rm -rf /var/www/php_nginx_jenkins
  ln -fs /home/ubuntu/php_nginx_jenkins /var/www/php_nginx_jenkins
fi

# Update Package List

apt-get update

# Update System Packages
apt-get -y upgrade


# Install Some PPAs

apt-get install -y software-properties-common curl

apt-add-repository ppa:nginx/stable -y
#apt-add-repository ppa:chris-lea/redis-server -y
apt-add-repository ppa:ondrej/php -y


# gpg: key 5072E1F5: public key "MySQL Release Engineering <mysql-build@oss.oracle.com>" imported
# apt-key adv --keyserver ha.pool.sks-keyservers.net --recv-keys 5072E1F5
# sh -c 'echo "deb http://repo.mysql.com/apt/ubuntu/ xenial mysql-5.7" >> /etc/apt/sources.list.d/mysql.list'

wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ xenial-pgdg main" >> /etc/apt/sources.list.d/pgdg.list'

curl -s https://packagecloud.io/gpg.key | apt-key add -
echo "deb http://packages.blackfire.io/debian any main" | tee /etc/apt/sources.list.d/blackfire.list

curl --silent --location https://deb.nodesource.com/setup_8.x | bash -

# Update Package Lists

apt-get update

# Install Some Basic Packages

apt-get install -y build-essential dos2unix gcc git libmcrypt4 libpcre3-dev ntp unzip \
make python2.7-dev python-pip re2c supervisor unattended-upgrades whois vim libnotify-bin \
pv cifs-utils mcrypt bash-completion zsh

# Install PHP Stuffs
# Current PHP 7.2
apt-get install -y --allow-downgrades --allow-remove-essential --allow-change-held-packages \
php7.2-cli php7.2-dev \
php7.2-pgsql php7.2-sqlite3 php7.2-gd \
php7.2-curl php7.2-memcached \
php7.2-imap php7.2-mysql php7.2-mbstring \
php7.2-xml php7.2-zip php7.2-bcmath php7.2-soap \
php7.2-intl php7.2-readline

# PHP 7.1
apt-get install -y --allow-downgrades --allow-remove-essential --allow-change-held-packages \
php7.1-cli php7.1-dev \
php7.1-pgsql php7.1-sqlite3 php7.1-gd \
php7.1-curl php7.1-memcached \
php7.1-imap php7.1-mysql php7.1-mbstring \
php7.1-xml php7.1-zip php7.1-bcmath php7.1-soap \
php7.1-intl php7.1-readline php-xdebug php-pear

# PHP 7.0
apt-get install -y --allow-downgrades --allow-remove-essential --allow-change-held-packages \
php7.0-cli php7.0-dev \
php7.0-pgsql php7.0-sqlite3 php7.0-gd \
php7.0-curl php7.0-memcached \
php7.0-imap php7.0-mysql php7.0-mbstring \
php7.0-xml php7.0-zip php7.0-bcmath php7.0-soap \
php7.0-intl php7.0-readline


update-alternatives --set php /usr/bin/php7.1

# Install Composer

curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer

# Add Composer Global Bin To Path

printf "\nPATH=\"$(sudo su - vagrant -c 'composer config -g home 2>/dev/null')/vendor/bin:\$PATH\"\n" | tee -a /home/vagrant/.profile

# Set Some PHP CLI Settings

sudo sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php/7.2/cli/php.ini
sudo sed -i "s/display_errors = .*/display_errors = On/" /etc/php/7.2/cli/php.ini
sudo sed -i "s/memory_limit = .*/memory_limit = 512M/" /etc/php/7.2/cli/php.ini
sudo sed -i "s/;date.timezone.*/date.timezone = UTC/" /etc/php/7.2/cli/php.ini

sudo sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php/7.1/cli/php.ini
sudo sed -i "s/display_errors = .*/display_errors = On/" /etc/php/7.1/cli/php.ini
sudo sed -i "s/memory_limit = .*/memory_limit = 512M/" /etc/php/7.1/cli/php.ini
sudo sed -i "s/;date.timezone.*/date.timezone = UTC/" /etc/php/7.1/cli/php.ini

sudo sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php/7.0/cli/php.ini
sudo sed -i "s/display_errors = .*/display_errors = On/" /etc/php/7.0/cli/php.ini
sudo sed -i "s/memory_limit = .*/memory_limit = 512M/" /etc/php/7.0/cli/php.ini
sudo sed -i "s/;date.timezone.*/date.timezone = UTC/" /etc/php/7.0/cli/php.ini


# Install Nginx & PHP-FPM

apt-get install -y --allow-downgrades --allow-remove-essential --allow-change-held-packages \
nginx php7.1-fpm php7.2-fpm php7.0-fpm

sudo cp /var/www/nginx_vhost /etc/nginx/sites-available/nginx_vhost
sudo ln -s /etc/nginx/sites-available/nginx_vhost /etc/nginx/sites-enabled/
rm /etc/nginx/sites-enabled/default
rm /etc/nginx/sites-available/default

# sudo cp /var/www/hosts_conf /etc/hosts

service nginx restart
# sudo service nginx restart

# Installing Jenkins
wget -q -O - https://pkg.jenkins.io/debian/jenkins-ci.org.key | sudo apt-key add -
echo deb https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list

apt-get update
apt-get install jenkins -y

# Start jenkins as service
systemctl start jenkins



# Setup Some PHP-FPM Options

echo "xdebug.remote_enable = 1" >> /etc/php/7.2/mods-available/xdebug.ini
echo "xdebug.remote_connect_back = 1" >> /etc/php/7.2/mods-available/xdebug.ini
echo "xdebug.remote_port = 9000" >> /etc/php/7.2/mods-available/xdebug.ini
echo "xdebug.max_nesting_level = 512" >> /etc/php/7.2/mods-available/xdebug.ini
echo "opcache.revalidate_freq = 0" >> /etc/php/7.2/mods-available/opcache.ini

echo "xdebug.remote_enable = 1" >> /etc/php/7.1/mods-available/xdebug.ini
echo "xdebug.remote_connect_back = 1" >> /etc/php/7.1/mods-available/xdebug.ini
echo "xdebug.remote_port = 9000" >> /etc/php/7.1/mods-available/xdebug.ini
echo "xdebug.max_nesting_level = 512" >> /etc/php/7.1/mods-available/xdebug.ini
echo "opcache.revalidate_freq = 0" >> /etc/php/7.1/mods-available/opcache.ini

echo "xdebug.remote_enable = 1" >> /etc/php/7.0/mods-available/xdebug.ini
echo "xdebug.remote_connect_back = 1" >> /etc/php/7.0/mods-available/xdebug.ini
echo "xdebug.remote_port = 9000" >> /etc/php/7.0/mods-available/xdebug.ini
echo "xdebug.max_nesting_level = 512" >> /etc/php/7.0/mods-available/xdebug.ini
echo "opcache.revalidate_freq = 0" >> /etc/php/7.0/mods-available/opcache.ini

sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php/7.2/fpm/php.ini
sed -i "s/display_errors = .*/display_errors = On/" /etc/php/7.2/fpm/php.ini
sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php/7.2/fpm/php.ini
sed -i "s/memory_limit = .*/memory_limit = 512M/" /etc/php/7.2/fpm/php.ini
sed -i "s/upload_max_filesize = .*/upload_max_filesize = 100M/" /etc/php/7.2/fpm/php.ini
sed -i "s/post_max_size = .*/post_max_size = 100M/" /etc/php/7.2/fpm/php.ini
sed -i "s/;date.timezone.*/date.timezone = UTC/" /etc/php/7.2/fpm/php.ini

printf "[openssl]\n" | tee -a /etc/php/7.2/fpm/php.ini
printf "openssl.cainfo = /etc/ssl/certs/ca-certificates.crt\n" | tee -a /etc/php/7.2/fpm/php.ini

printf "[curl]\n" | tee -a /etc/php/7.2/fpm/php.ini
printf "curl.cainfo = /etc/ssl/certs/ca-certificates.crt\n" | tee -a /etc/php/7.2/fpm/php.ini

sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php/7.1/fpm/php.ini
sed -i "s/display_errors = .*/display_errors = On/" /etc/php/7.1/fpm/php.ini
sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php/7.1/fpm/php.ini
sed -i "s/memory_limit = .*/memory_limit = 512M/" /etc/php/7.1/fpm/php.ini
sed -i "s/upload_max_filesize = .*/upload_max_filesize = 100M/" /etc/php/7.1/fpm/php.ini
sed -i "s/post_max_size = .*/post_max_size = 100M/" /etc/php/7.1/fpm/php.ini
sed -i "s/;date.timezone.*/date.timezone = UTC/" /etc/php/7.1/fpm/php.ini

printf "[openssl]\n" | tee -a /etc/php/7.1/fpm/php.ini
printf "openssl.cainfo = /etc/ssl/certs/ca-certificates.crt\n" | tee -a /etc/php/7.1/fpm/php.ini

printf "[curl]\n" | tee -a /etc/php/7.1/fpm/php.ini
printf "curl.cainfo = /etc/ssl/certs/ca-certificates.crt\n" | tee -a /etc/php/7.1/fpm/php.ini

sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php/7.0/fpm/php.ini
sed -i "s/display_errors = .*/display_errors = On/" /etc/php/7.0/fpm/php.ini
sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php/7.0/fpm/php.ini
sed -i "s/memory_limit = .*/memory_limit = 512M/" /etc/php/7.0/fpm/php.ini
sed -i "s/upload_max_filesize = .*/upload_max_filesize = 100M/" /etc/php/7.0/fpm/php.ini
sed -i "s/post_max_size = .*/post_max_size = 100M/" /etc/php/7.0/fpm/php.ini
sed -i "s/;date.timezone.*/date.timezone = UTC/" /etc/php/7.0/fpm/php.ini

printf "[curl]\n" | tee -a /etc/php/7.0/fpm/php.ini
printf "curl.cainfo = /etc/ssl/certs/ca-certificates.crt\n" | tee -a /etc/php/7.0/fpm/php.ini


# Disable XDebug On The CLI

sudo phpdismod -s cli xdebug

# Copy fastcgi_params to Nginx because they broke it on the PPA

cat > /etc/nginx/fastcgi_params << EOF
fastcgi_param	QUERY_STRING		\$query_string;
fastcgi_param	REQUEST_METHOD		\$request_method;
fastcgi_param	CONTENT_TYPE		\$content_type;
fastcgi_param	CONTENT_LENGTH		\$content_length;
fastcgi_param	SCRIPT_FILENAME		\$request_filename;
fastcgi_param	SCRIPT_NAME			\$fastcgi_script_name;
fastcgi_param	REQUEST_URI			\$request_uri;
fastcgi_param	DOCUMENT_URI		\$document_uri;
fastcgi_param	DOCUMENT_ROOT		\$document_root;
fastcgi_param	SERVER_PROTOCOL		\$server_protocol;
fastcgi_param	GATEWAY_INTERFACE	CGI/1.1;
fastcgi_param	SERVER_SOFTWARE		nginx/\$nginx_version;
fastcgi_param	REMOTE_ADDR			\$remote_addr;
fastcgi_param	REMOTE_PORT			\$remote_port;
fastcgi_param	SERVER_ADDR			\$server_addr;
fastcgi_param	SERVER_PORT			\$server_port;
fastcgi_param	SERVER_NAME			\$server_name;
fastcgi_param	HTTPS				\$https if_not_empty;
fastcgi_param	REDIRECT_STATUS		200;
EOF


# Set The Nginx & PHP-FPM User

sed -i "s/user www-data;/user jenkins;/" /etc/nginx/nginx.conf
sed -i "s/# server_names_hash_bucket_size.*/server_names_hash_bucket_size 64;/" /etc/nginx/nginx.conf


sed -i "s/user = www-data/user = jenkins/" /etc/php/7.2/fpm/pool.d/www.conf
sed -i "s/group = www-data/group = jenkins/" /etc/php/7.2/fpm/pool.d/www.conf


sed -i "s/user = www-data/user = jenkins/" /etc/php/7.1/fpm/pool.d/www.conf
sed -i "s/group = www-data/group = jenkins/" /etc/php/7.1/fpm/pool.d/www.conf

sed -i "s/listen\.owner.*/listen.owner = jenkins/" /etc/php/7.1/fpm/pool.d/www.conf
sed -i "s/listen\.group.*/listen.group = jenkins/" /etc/php/7.1/fpm/pool.d/www.conf
sed -i "s/;listen\.mode.*/listen.mode = 0666/" /etc/php/7.1/fpm/pool.d/www.conf


sed -i "s/user = www-data/user = jenkins/" /etc/php/7.0/fpm/pool.d/www.conf
sed -i "s/group = www-data/group = jenkins/" /etc/php/7.0/fpm/pool.d/www.conf

sed -i "s/listen\.owner.*/listen.owner = jenkins/" /etc/php/7.0/fpm/pool.d/www.conf
sed -i "s/listen\.group.*/listen.group = jenkins/" /etc/php/7.0/fpm/pool.d/www.conf
sed -i "s/;listen\.mode.*/listen.mode = 0666/" /etc/php/7.0/fpm/pool.d/www.conf

service nginx restart
service php7.2-fpm restart
service php7.1-fpm restart
service php7.0-fpm restart


# Add jenkins User To WWW-Data

usermod -a -G www-data jenkins
id jenkins
groups jenkins



# Install MySQL
echo "mysql-server mysql-server/root_password password secret" | debconf-set-selections
echo "mysql-server mysql-server/root_password_again password secret" | debconf-set-selections
apt-get install -y mysql-server

# Configure MySQL Password Lifetime

echo "default_password_lifetime = 0" >> /etc/mysql/mysql.conf.d/mysqld.cnf

# Configure MySQL Remote Access

sed -i '/^bind-address/s/bind-address.*=.*/bind-address = 0.0.0.0/' /etc/mysql/mysql.conf.d/mysqld.cnf

mysql --user="root" --password="secret" -e "GRANT ALL ON *.* TO root@'0.0.0.0' IDENTIFIED BY 'secret' WITH GRANT OPTION;"
service mysql restart

mysql --user="root" --password="secret" -e "CREATE USER 'dbuser'@'0.0.0.0' IDENTIFIED BY 'secret';"
mysql --user="root" --password="secret" -e "GRANT ALL ON *.* TO 'dbuser'@'0.0.0.0' IDENTIFIED BY 'secret' WITH GRANT OPTION;"
mysql --user="root" --password="secret" -e "GRANT ALL ON *.* TO 'dbuser'@'%' IDENTIFIED BY 'secret' WITH GRANT OPTION;"
mysql --user="root" --password="secret" -e "FLUSH PRIVILEGES;"
mysql --user="root" --password="secret" -e "CREATE DATABASE mydb character set UTF8mb4 collate utf8mb4_bin;"
service mysql restart

# Add Timezone Support To MySQL

mysql_tzinfo_to_sql /usr/share/zoneinfo | mysql --user=root --password=secret mysql


# Install Postgres

apt-get install -y postgresql-9.6

Configure Postgres Remote Access

sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/g" /etc/postgresql/9.6/main/postgresql.conf
echo "host    all             all             0.0.0.0/0               md5" | tee -a /etc/postgresql/9.6/main/pg_hba.conf
sudo -u postgres psql -c "CREATE ROLE dbuser LOGIN UNENCRYPTED PASSWORD 'secret' SUPERUSER INHERIT NOCREATEDB NOCREATEROLE NOREPLICATION;"
sudo -u postgres /usr/bin/createdb --echo --owner=dbuser mydb

service postgresql restart

# Configure Supervisor

systemctl daemon-reload

systemctl enable supervisor.service
service supervisor start


# One last upgrade check

apt-get -y upgrade

# Clean Up

apt-get -y autoremove
apt-get -y clean
chown -R jenkins:www-data /home/ubuntu/php_nginx_jenkins

# Enable Swap Memory

/bin/dd if=/dev/zero of=/var/swap.1 bs=1M count=1024
/sbin/mkswap /var/swap.1
/sbin/swapon /var/swap.1

apt-get -y autoremove;
apt-get -y clean;

echo "Finished server setup."

