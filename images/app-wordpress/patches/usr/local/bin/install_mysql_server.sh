#!/bin/bash

if [ ! -f /root/.my.cnf ]; then
    password=$(pwgen 42)
    dbname="wordpress"
    username="root"
    cat <<EOF > /root/.my.cnf
[client]
user = $username
password = $password
EOF
    echo "mysql-server mysql-server/root_password password $password" debconf-set-selections
    echo "mysql-server mysql-server/root_password_again password $password" debconf-set-selections
    apt-get install -qy mysql-server
    sed -i "s/define('DB_NAME', 'database_name_here');/define('DB_NAME', '$dbname');/" /var/www/wp-config.php
    sed -i "s/define('DB_USER', 'username_here');/define('DB_USER', '$username');/" /var/www/wp-config.php
    sed -i "s/define('DB_PASSWORD', 'password_here');/define('DB_PASSWORD', '$password');/" /var/www/wp-config.php
fi

echo "CREATE DATABASE $dbname" | mysql

