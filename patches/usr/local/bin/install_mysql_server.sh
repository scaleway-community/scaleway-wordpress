#!/bin/bash

if [ ! -f /root/.my.cnf ]; then

    password=$(pwgen 42)
    dbname="wordpress"
    username="root"
    
    echo mysql-server mysql-server/root_password password $password | debconf-set-selections
    echo mysql-server mysql-server/root_password_again password $password | debconf-set-selections
    apt-get -q update
    apt-get install -y -q mysql-server
    cat <<EOF > /root/.my.cnf
[client]
user = $username
password = $password
EOF

    echo "CREATE DATABASE $dbname" | mysql -u $username -p$password

    # Configure wordpress database
    sed -i "s/define('DB_NAME',.*/define('DB_NAME', '$dbname');/" /var/www/wp-config.php
    sed -i "s/define('DB_USER',.*/define('DB_USER', '$username');/" /var/www/wp-config.php
    sed -i "s/define('DB_PASSWORD',.*/define('DB_PASSWORD', '$password');/" /var/www/wp-config.php
    sed -i "/WP_DEBUG/a\\define('FS_METHOD', 'direct');" /var/www/wp-config.php
fi
