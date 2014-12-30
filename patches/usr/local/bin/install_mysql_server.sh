#!/bin/bash

if [ ! -f /root/.my.cnf ]; then

    password=$(pwgen 42)
    dbname="wordpress"
    username="root"
    
    /usr/bin/mysqladmin -u root password $password
    cat <<EOF > /root/.my.cnf
[client]
user = $username
password = $password
EOF

    mysql -e "CREATE DATABASE $dbname"

    # Configure wordpress database
    sed -i "s/define('DB_NAME',.*/define('DB_NAME', '$dbname');/" /var/www/wp-config.php
    sed -i "s/define('DB_USER',.*/define('DB_USER', '$username');/" /var/www/wp-config.php
    sed -i "s/define('DB_PASSWORD',.*/define('DB_PASSWORD', '$password');/" /var/www/wp-config.php
fi
