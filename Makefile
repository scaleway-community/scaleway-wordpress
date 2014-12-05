DOCKER_NAMESPACE =	armbuild/
NAME =			ocs-app-wordpress
VERSION =		utopic
VERSION_ALIASES =	14.10 latest
TITLE =			Wordpress 4.0
DESCRIPTION =		Wordpress 4.0 with MySQL
SOURCE_URL =		https://github.com/online-labs/image-app-wordpress


## Image tools  (https://github.com/online-labs/image-tools)
all:	docker-rules.mk
docker-rules.mk:
	wget -qO - http://j.mp/image-tools | bash
-include docker-rules.mk
## Below you can add custom makefile commands and overrides
