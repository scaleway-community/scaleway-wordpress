## -*- docker-image-name: "armbuild/scw-app-wordpress:trusty" -*-
FROM armbuild/scw-distrib-ubuntu:trusty
MAINTAINER Scaleway <opensource@scaleway.com> (@scaleway)

# Prepare rootfs for image-builder
RUN /usr/local/sbin/builder-enter

# Pre-seeding for postfix
RUN sudo su root -c "debconf-set-selections <<< \"postfix postfix/main_mailer_type string 'Internet Site'\"" \
  && sudo su root -c "debconf-set-selections <<< \"postfix postfix/mailname string localhost\""

# Install packages
RUN apt-get -q update     \
 && apt-get -q -y upgrade \
 && apt-get install -y -q \
	mailutils         \
	mysql-server      \
	php5              \
	php5-cli          \
	php5-fpm          \
	php5-gd           \
	php5-mcrypt       \
	php5-mysql        \
	pwgen             \
	nginx             \
 && apt-get clean


# Uninstall apache
RUN apt-get -yq remove apache2

ENV WORDPRESS_VERSION 4.3

# Install WordPress
RUN wget -qO wordpress.tar.gz https://wordpress.org/wordpress-$WORDPRESS_VERSION.tar.gz && \
    tar -xzf wordpress.tar.gz && \
    rm -rf /var/www && \
    mv wordpress /var/www && \
    cp /var/www/wp-config-sample.php /var/www/wp-config.php && \
    /usr/local/bin/wp_config.sh && \
    rm -f /usr/local/bin/wp_config.sh && \
    rm -f wordpress.tar.gz

# Configure NginX
RUN ln -sf /etc/nginx/sites-available/000-default.conf /etc/nginx/sites-enabled/000-default.conf && \
    rm -f /etc/nginx/sites-enabled/default


# Patch rootfs
ADD ./patches/root/ /root/
ADD ./patches/etc/ /etc/
ADD ./patches/usr/local/ /usr/local/

RUN /etc/init.d/mysql start \
  && mysql -u root -e "CREATE DATABASE wordpress CHARACTER SET utf8;" \
  && /etc/init.d/mysql stop


# Clean rootfs from image-builder
RUN /usr/local/sbin/builder-leave
