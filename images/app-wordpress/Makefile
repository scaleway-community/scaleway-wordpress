NAME=armbuild/ocs-app-wordpress
VERSION=utopic
DISK=/dev/nbd1
S3_URL=s3://test-images
IS_LATEST=1

.PHONY: build release install_on_disk publish_on_s3 clean shell re all publish_on_s3.tar publish_on_s3.sqsh

all: build

re: clean all

build: rootfs.tar


release:
	docker tag  $(NAME):$(VERSION) $(NAME):$(shell date +%Y-%m-%d)
	docker push $(NAME):$(VERSION) $(NAME):$(shell date +%Y-%m-%d)
	if [ "x$(IS_LATEST)" = "x1" ]; then              \
	    docker tag $(NAME):$(VERSION) $(NAME):latest \
	    docker push $(NAME):latest                   \
	fi


install_on_disk: rootfs.tar /mnt/$(DISK)
	tar -C /mnt/$(DISK) -xf rootfs.tar


publish_on_s3: publish_on_s3.tar publish_on_s3.sqsh


publish_on_s3.tar: rootfs.tar
	s3cmd put --acl-public rootfs.tar $(S3_URL)/$(NAME)-$(VERSION).tar


publish_on_s3.sqsh: rootfs.sqsh
	s3cmd put --acl-public rootfs.sqsh $(S3_URL)/$(NAME)-$(VERSION).sqsh


clean:
	docker rmi $(NAME):$(VERSION) || true
	rm -f rootfs.tar .??*.built || true


shell:  .docker-container.built
	docker run --rm -it $(NAME):$(VERSION) /bin/bash


.docker-container.built: Dockerfile
	find patches -name '*~' -delete
	docker build -t $(NAME):$(VERSION) .
	docker inspect -f '{{.Id}}' $(NAME):$(VERSION) > .docker-container.built


rootfs: export.tar
	rm -rf rootfs.tmp
	mkdir rootfs.tmp
	tar -C rootfs.tmp -xf export.tar
	rm -f rootfs.tmp/.dockerenv rootfs.tmp/.dockerinit
	mv rootfs.tmp rootfs


rootfs.tar: rootfs
	tar --format=gnu -C rootfs -cf rootfs.tar.tmp .
	mv rootfs.tar.tmp rootfs.tar


rootfs.sqsh: rootfs
	mksquashfs rootfs rootfs.sqsh -noI -noD -noF -noX


export.tar: .docker-container.built
	docker run --entrypoint /dontexists $(NAME):$(VERSION) 2>/dev/null || true
	docker export $(shell docker ps -lq) > export.tar.tmp
	mv export.tar.tmp export.tar


/mnt/$(DISK):
	umount $(DISK) || true
	mkfs.ext4 $(DISK)
	mkdir -p /mnt/$(DISK)
	mount $(DISK) /mnt/$(DISK)
