#!/bin/bash
#adminroot

echo "--- Atualizando lista de pacotes ---"
sudo apt-get update

echo "--- Definindo Senha padrao para o MySQL e suas ferramentas ---"
sudo debconf-set-selections <<EOF
mysql-server	mysql-server/root_password password $DB_ROOT_PASSWORD
mysql-server	mysql-server/root_password_again password $DB_ROOT_PASSWORD
dbconfig-common	dbconfig-common/mysql/app-pass password $DB_ROOT_PASSWORD
dbconfig-common	dbconfig-common/mysql/admin-pass password $DB_ROOT_PASSWORD
dbconfig-common	dbconfig-common/password-confirm password $DB_ROOT_PASSWORD
dbconfig-common	dbconfig-common/app-password-confirm password $DB_ROOT_PASSWORD
phpmyadmin		phpmyadmin/reconfigure-webserver multiselect apache2
phpmyadmin		phpmyadmin/dbconfig-install boolean true
phpmyadmin      phpmyadmin/app-password-confirm password $DB_ROOT_PASSWORD 
phpmyadmin      phpmyadmin/mysql/admin-pass     password $DB_ROOT_PASSWORD
phpmyadmin      phpmyadmin/password-confirm     password $DB_ROOT_PASSWORD
phpmyadmin      phpmyadmin/setup-password       password $DB_ROOT_PASSWORD
phpmyadmin      phpmyadmin/mysql/app-pass       password $DB_ROOT_PASSWORD
EOF

echo "--- Instalando pacotes basicos ---"
sudo apt-get install -y \
    software-properties-common \
    vim \
    curl \
    git-core \
    zip \
    unzip 

echo "--- Instalando nginx ---"
sudo add-apt-repository ppa:nginx/stable
sudo apt-get install -y nginx
sudo ufw app list
sudo ufw allow 'Nginx HTTP'
sudo ufw allow https comment 'Open all to access Nginx port 443'
sudo ufw allow http comment 'Open access Nginx port 80'
sudo ufw allow ssh comment 'Open access OpenSSH port 22'
sudo ufw status

echo "--- Adicionando repositorio do pacote PHP ---"
sudo add-apt-repository -y ppa:ondrej/php
sudo apt-get update
sudo apt-get install -y  openssl mcrypt php-gettext php-mbstring php7.2 php7.2-cli php7.2-fpm php7.2-common
sudo apt-get install -y php7.2-curl php7.2-gd php7.2-json php7.2-mbstring php7.2-intl php7.2-mysql php7.2-xml php7.2-zip

echo "--- Instalando MySQL ---"
sudo apt-get install -y -f mysql-server
mysql --version

echo "--- Reiniciando MySQL ---"
sudo service mysql restart

echo "--- Instalando phpMyAdmin ---"
#sudo phpenmod mcrypt
#sudo phpenmod mbstring
sudo apt-get install -y phpmyadmin 
#sudo ln -s /usr/share/phpmyadmin /var/www/html
sudo service php7.2-fpm restart
#sed -i '$127.0.0.1       phpmyadmin' /etc/hosts


#sudo service apache2 stop 
#sudo update-rc.d apache2 disable
sudo service nginx start

echo "--- Baixando e Instalando Composer ---"
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer

sudo apt-get install -y redis-server
sudo apt-get install -y php7.2-redis