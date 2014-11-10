NAME=ocs-app-wordpress
VERSION=utopic
DISK=/dev/nbd1
S3_URL=s3://test-images/$(NAME)

build: rootfs.tar

rootfs.tar: Dockerfile
	docker build -t $(NAME):$(VERSION) .
	docker run --entrypoint /dontexists $(NAME):$(VERSION) 2>/dev/null || true
	docker export $(shell docker ps -lq) | docker import - $(NAME)-flatten:$(VERSION)
	docker save $(NAME)-flatten:$(VERSION) | tar -O xf - '*/layer.tar' > $@

release:
	docker tag $(NAME):$(VERSION) $(NAME):latest
	docker tag $(NAME):$(VERSION) $(NAME):$(shell date +%Y-%m-%d)
	docker push $(NAME):$(VERSION)

/mnt/$(DISK):
	umount $(DISK) || true
	mkfs.ext4 $(DISK)
	mkdir -p /mnt/$(DISK)
	mount $(DISK) /mnt/$(DISK)

install_on_disk: /mnt/$(DISK) rootfs.tar
	tar xf rootfs.tar /mnt/$(DISK)

publish_on_s3: rootfs.tar
	s3cmd put --acl-public $< $(S3_URL)/$(NAME)-$(VERSION).tar.gz
