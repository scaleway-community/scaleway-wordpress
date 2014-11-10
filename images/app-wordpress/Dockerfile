FROM armbuild/ocs-ubuntu:utopic

# Prevent init scripts from running during install/update
# policy-rc.d (for most scripts)
RUN echo $'#!/bin/sh\nexit 101' > /usr/sbin/policy-rc.d && \
    chmod +x /usr/sbin/policy-rc.d

# Install packages
RUN apt-get -q update &&
    apt-get -q upgrade &&
    apt-get install -y -q \
	mysql-server \
	php5 \
	php5-cli \
	php5-fpm \
	php5-gd \
	php5-mcrypt \
	php5-mysql \
	pwgen \
        nginx \
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
ADD ./patches/ /

# Clean
# - make image smaller
# - remove ssh host keys so they are regenerated on first boot
# - remove /etc/hostname and resolv.conf that contains build information and will be regenerated using from dhcp
# - Remove hacks
#   - Prevent init scripts from running during install/update
RUN
    rm -f \
	/etc/hostname \
	/etc/resolv.conf \
	/etc/ssh/*_key* \
	/root/.history \
	/var/cache/apt/*.bin
	/var/cache/apt/archives/partial/*.deb \
	/var/log/bootstrap.log \
        /root/.bash_history \
        /usr/sbin/policy-rc.d \
        /var/cache/apt/archives/*.deb \
    && apt-get clean

# Update locate cache
RUN updatedb

# Update aptitude cache
RUN apt-get update
