## -*- docker-image-name: "armbuild/scw-app-wordpress:trusty" -*-
FROM armbuild/scw-distrib-ubuntu:trusty
MAINTAINER Scaleway <opensource@scaleway.com> (@scaleway)


# Prepare rootfs for image-builder
RUN /usr/local/sbin/builder-enter

# Install packages
RUN apt-get -q update     \
 && apt-get -q -y upgrade \
 && apt-get install -y -q \
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


# Install WordPress
RUN wget -qO latest.tar.gz http://wordpress.org/latest.tar.gz && \
    tar -xzf latest.tar.gz && \
    rm -rf /var/www && \
    mv wordpress /var/www && \
    cp /var/www/wp-config-sample.php /var/www/wp-config.php && \
    rm -f latest.tar.gz


# Configure NginX
RUN ln -sf /etc/nginx/sites-available/wordpress /etc/nginx/sites-enabled/wordpress && \
    rm -f /etc/nginx/sites-enabled/default


# Patch rootfs
ADD ./patches/etc/ /etc/
ADD ./patches/usr/local/ /usr/local/


# Clean rootfs from image-builder
RUN /usr/local/sbin/builder-leave
