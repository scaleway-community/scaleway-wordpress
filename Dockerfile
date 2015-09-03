## -*- docker-image-name: "armbuild/scw-app-wordpress:trusty" -*-
FROM armbuild/scw-distrib-ubuntu:trusty
MAINTAINER Scaleway <opensource@scaleway.com> (@scaleway)


# Prepare rootfs for image-builder
RUN /usr/local/sbin/builder-enter

# Install packages
RUN apt-get -q update     \
 && apt-get -q -y upgrade \
 && apt-get install -y -q \
        postfix           \
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


ENV WORDPRESS_VERSION 4.2.2


# Install WordPress
RUN wget -qO wordpress.tar.gz https://wordpress.org/wordpress-$WORDPRESS_VERSION.tar.gz && \
    tar -xzf wordpress.tar.gz && \
    rm -rf /var/www && \
    mv wordpress /var/www && \
    cp /var/www/wp-config-sample.php /var/www/wp-config.php && \
    rm -f wordpress.tar.gz


# Configure NginX
RUN ln -sf /etc/nginx/sites-available/wordpress /etc/nginx/sites-enabled/wordpress && \
    rm -f /etc/nginx/sites-enabled/default


# Patch rootfs
ADD ./patches/etc/ /etc/
ADD ./patches/usr/local/ /usr/local/


# Clean rootfs from image-builder
RUN /usr/local/sbin/builder-leave
