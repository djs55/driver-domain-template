Gem::Specification.new do |s|
  s.name = %q{xcp-boxgrinder-build-driverdomain-os-plugin}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Dave Scott"]
  s.date = %q{2012-06-21}
  s.description = %q{BoxGrinder Build XCP driver domain plugin}
  s.email = %q{xen-api@lists.xen.org}
  s.extra_rdoc_files = ["lib/xcp-boxgrinder-build-driverdomain-os-plugin.rb", "lib/xcp-boxgrinder-build-driverdomain-os-plugin/driverdomain.rb"]
  s.files = ["lib/xcp-boxgrinder-build-driverdomain-os-plugin.rb", "lib/xcp-boxgrinder-build-driverdomain-os-plugin/driverdomain.rb", "xcp-boxgrinder-build-driverdomain-os-plugin.gemspec"]
  s.homepage = %q{http://www.xen.org/}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Xcp-boxgrinder-build-driverdomain-os-plugin"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{BoxGrinder Build}
  s.rubygems_version = %q{1.3.6}
  s.summary = %q{XCP driverdomain plugin}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<boxgrinder-build>, [">= 0.5.0"])
    else
      s.add_dependency(%q<boxgrinder-build>, [">= 0.5.0"])
    end
  else
    s.add_dependency(%q<boxgrinder-build>, [">= 0.5.0"])
  end
end

