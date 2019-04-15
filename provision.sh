#!/bin/bash

cd
# Let the games begin!

# Handle !I/O/ERR
exec 3>&1 4>&2 1>/dev/null 2>&1

showmsg() {
  exec 1>&3; echo "$1"; exec 1>/dev/null;
  #echo "$1";
}

showmsg "Preparing virtual-machine"
# add Ondřej Sury's Debian PHP repo
sudo wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
sudo sh -c 'echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list'

showmsg "--- Reticulating splines"
sudo apt-get update --fix-missing
sudo DEBIAN_FRONTEND=noninteractive apt-get upgrade -y
sudo apt-get autoremove -y
sudo apt-get install -y vim-nox curl unzip apt-transport-https build-essential software-properties-common

showmsg "--- Installing Nginx"
sudo apt-get install -y nginx-full
# disable sendfile, which causes file corruption in virtualbox vms
sudo sed -i "s/sendfile on/sendfile off/" /etc/nginx/nginx.conf
sudo rm /etc/nginx/sites-enabled/default

showmsg "--- Installing PHP7.x-fpm and indispensable packages"
sudo apt-get install -y php7.3-fpm php7.3-curl php7.3-intl php7.3-mbstring php7.3-mysql php7.3-zip
# disable the pathinfo fix, to conform with nginx socket connections
sudo sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php/7.3/fpm/php.ini
# set the timezone
sudo sed -i "s/;date.timezone =/date.timezone = America\/Denver/" /etc/php/7.3/cli/php.ini
sudo sed -i "s/;date.timezone =/date.timezone = America\/Denver/" /etc/php/7.3/fpm/php.ini
sudo service php7.3-fpm reload

showmsg "--- Installing Composer"
curl --silent https://getcomposer.org/installer | php >> /vagrant/vm_build.log
sudo mv composer.phar /usr/local/bin/composer

sudo service nginx restart
