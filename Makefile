DOCKER_NAMESPACE =	armbuild/
NAME =			scw-app-wordpress
VERSION =		latest
VERSION_ALIASES =	4.3 4
TITLE =			WordPress
DESCRIPTION =		WordPresswith MySQL
SOURCE_URL =		https://github.com/scaleway-community/scaleway-wordpress

IMAGE_VOLUME_SIZE =	50G
IMAGE_BOOTSCRIPT =	stable
IMAGE_NAME =		Wordpress 4.3


## Image tools  (https://github.com/scaleway/image-tools)
all:	docker-rules.mk
docker-rules.mk:
	wget -qO - http://j.mp/scw-builder | bash
-include docker-rules.mk
