DOCKER_NAMESPACE =	armbuild/
NAME =			scw-app-wordpress
VERSION =		latest
VERSION_ALIASES =	4.3 4
TITLE =			WordPress
DESCRIPTION =		WordPresswith MySQL
SOURCE_URL =		https://github.com/scaleway/image-app-wordpress


## Image tools  (https://github.com/scaleway/image-tools)
all:	docker-rules.mk
docker-rules.mk:
	wget -qO - http://j.mp/scw-builder | bash
-include docker-rules.mk
## Below you can add custom makefile commands and overrides
