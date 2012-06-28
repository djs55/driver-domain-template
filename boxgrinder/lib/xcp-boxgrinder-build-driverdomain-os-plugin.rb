require 'xcp-boxgrinder-build-driverdomain-os-plugin/driverdomain'

plugin :class => BoxGrinder::DriverDomainPlugin, :type => :os, :versions => [ "5" ], :name => :driverdomain, :full_name  => "XCP driver domain plugin", :require_root => true
