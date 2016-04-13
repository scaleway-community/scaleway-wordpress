NAME =			wordpress
VERSION =		latest
VERSION_ALIASES =	4.4.0 4.4 4
TITLE =			WordPress
DESCRIPTION =		WordPress with MySQL
SOURCE_URL =		https://github.com/scaleway-community/scaleway-wordpress

IMAGE_VOLUME_SIZE =	50G
IMAGE_BOOTSCRIPT =	stable
IMAGE_NAME =		Wordpress 4.4.0


## Image tools  (https://github.com/scaleway/image-tools)
all:	docker-rules.mk
docker-rules.mk:
	wget -qO - https://j.mp/scw-builder | bash
-include docker-rules.mk
