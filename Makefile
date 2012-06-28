PACKAGES=rsyslog util-linux dhclient net-tools xe-guest-utilities xe-guest-utilities-xenstore pciutils nfs-utils xcp-sm-fs xapi-noarch-backend-udev blktap blktap-debuginfo gdb strace

initrd:
	sudo ./make-initrd.sh ${PACKAGES}

.PHONY: clean
clean:
	rm -f initrd

