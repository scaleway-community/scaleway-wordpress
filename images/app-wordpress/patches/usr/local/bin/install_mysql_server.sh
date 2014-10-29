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

    # Reset mysql root password
    cat <<EOF > /tmp/recover_root_mysql.ini
UPDATE mysql.user SET password=PASSWORD("$password") where User='$username';
FLUSH PRIVILEGES;
EOF
    service mysql stop
    mysqld_safe --skip-grant-tables --init-file=/tmp/recover_root_mysql.ini &
    sleep 5
    echo "CREATE DATABASE $dbname" | mysql -u $username -p$password
    killall mysqld
    rm -f /tmp/recover_root_mysql.ini
    service mysql start

    # Configure wordpress database
    sed -i "s/define('DB_NAME',.*/define('DB_NAME', '$dbname');/" /var/www/wp-config.php
    sed -i "s/define('DB_USER',.*/define('DB_USER', '$username');/" /var/www/wp-config.php
    sed -i "s/define('DB_PASSWORD',.*/define('DB_PASSWORD', '$password');/" /var/www/wp-config.php
fi

