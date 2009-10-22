# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{rack-inline-styles}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Macario Ortega"]
  s.date = %q{2009-10-16}
  s.description = %q{FIX (describe your package)}
  s.email = ["macarui@gmail.com"]
  s.extra_rdoc_files = ["History.txt", "Manifest.txt", "README.rdoc"]
  s.files = [".git/HEAD", ".git/config", ".git/description", ".git/hooks/applypatch-msg", ".git/hooks/commit-msg", ".git/hooks/post-commit", ".git/hooks/post-receive", ".git/hooks/post-update", ".git/hooks/pre-applypatch", ".git/hooks/pre-commit", ".git/hooks/pre-rebase", ".git/hooks/update", ".git/index", ".git/info/exclude", ".git/objects/14/fa7459b8ceed4fef2dae431412c51591335354", ".git/objects/2c/0095bcd01468cbafdbb01befcd08cd60ccfb78", ".git/objects/37/04bf0d18ced6f7c6a85467ca3ae017e87d9bf4", ".git/objects/55/8a5df09d6f6b75f07504dd86ead7a0078c9031", ".git/objects/a6/cfe2d2693a7d73be08898b26a1f44886878c21", ".git/objects/e4/f29ca4d0099d827535a935fed78a2aa70fb3e7", ".git/objects/f0/4fbfb5595b8187bf753bdedebb89ee835c28ef", "History.txt", "Manifest.txt", "README.rdoc", "Rakefile", "lib/rack/inline-styles.rb", "rack-inline-styles.gemspec", "spec/spec_helper.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/#{github_username}/#{project_name}}
  s.rdoc_options = ["--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{rack-inline-styles}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{FIX (describe your package)}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<newgem>, [">= 1.4.1"])
      s.add_development_dependency(%q<hoe>, [">= 1.8.0"])
    else
      s.add_dependency(%q<newgem>, [">= 1.4.1"])
      s.add_dependency(%q<hoe>, [">= 1.8.0"])
    end
  else
    s.add_dependency(%q<newgem>, [">= 1.4.1"])
    s.add_dependency(%q<hoe>, [">= 1.8.0"])
  end
end
