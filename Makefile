PACKAGES=util-linux dhclient net-tools xe-guest-utilities xe-guest-utilities-xenstore

initrd:
	sudo ./make-initrd.sh ${PACKAGES}

.PHONY: clean
clean:
	rm -f initrd

