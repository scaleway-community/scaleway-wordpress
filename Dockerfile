## -*- docker-image-name: "armbuild/ocs-app-wordpress:utopic" -*-
FROM armbuild/ocs-distrib-ubuntu:utopic
MAINTAINER Online Labs <opensource@ocs.online.net> (@online_en)


# Prepare rootfs for image-builder
RUN /usr/local/sbin/builder-enter

# Install packages
RUN apt-get -q update &&  \
    apt-get -q upgrade && \
    apt-get install -y -q \
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

# Install Wordpress
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
# - Add ocs-scripts
# - Tweaks rootfs so it matches Online Labs infrastructure
# RUN curl https://raw.githubusercontent.com/online-labs/ocs-scripts/master/upgrade_root.bash | bash
ADD ./patches/etc/ /etc/
ADD ./patches/usr/local/ /usr/local/

# Clean rootfs from image-builder
RUN /usr/local/sbin/builder-leave
