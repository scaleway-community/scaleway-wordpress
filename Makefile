DOCKER_NAMESPACE =	armbuild/
NAME =			ocs-app-wordpress
VERSION =		latest
VERSION_ALIASES =	14.10 latest utopic 4.1 4
TITLE =			WordPress 4.1
DESCRIPTION =		WordPress 4.1 with MySQL
SOURCE_URL =		https://github.com/online-labs/image-app-wordpress


## Image tools  (https://github.com/online-labs/image-tools)
all:	docker-rules.mk
docker-rules.mk:
	wget -qO - http://j.mp/image-tools | bash
-include docker-rules.mk
## Below you can add custom makefile commands and overrides
