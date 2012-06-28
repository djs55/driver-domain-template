
.PHONY: appliance
appliance: install
	boxgrinder-build driver-domain.appl --plugins xcp-boxgrinder-build-driverdomain-os-plugin

.PHONY: install
install: xcp-boxgrinder-build-driverdomain-os-plugin-0.0.1.gem
	gem install $<

xcp-boxgrinder-build-driverdomain-os-plugin-0.0.1.gem: xcp-boxgrinder-build-driverdomain-os-plugin.gemspec
	gem build $<

.PHONY: clean
clean:
	rm -f *.gem
