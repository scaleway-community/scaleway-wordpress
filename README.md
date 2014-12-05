Official Ghost image on Online Labs
====================================

Scripts to build the official Wordpress image on Online Labs

This image is built using [Image Tools](https://github.com/online-labs/image-tools) and depends on the official [Ubuntu](https://github.com/online-labs/image-ubuntu) image.

---

Commands
--------

    # build the image in a rootfs directory
    $ make rootfs

    # write the image to /dev/nbd1
    $ make install_on_disk

Full list of commands available at: https://github.com/online-labs/image-tools/tree/master#commands
