# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{inline-style}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Macario Ortega"]
  s.date = %q{2009-10-22}
  s.description = %q{Simple utility for "inlining" all CSS in the style attribute for the html tags. Useful for html emails that won't
correctly render stylesheets in some clients such as gmail.

* Includes a Rack middleware for using with Rails, Sinatra, etc...
* It takes into account selector specificity.}
  s.email = ["macarui@gmail.com"]
  s.extra_rdoc_files = ["History.txt", "Manifest.txt", "README.rdoc"]
  s.files = ["History.txt", "Manifest.txt", "README.rdoc", "Rakefile", "example.rb", "inline-style.gemspec", "lib/inline-style.rb", "lib/inline-style/rack/middleware.rb", "rack-inline-styles.gemspec", "spec/as_middleware_spec.rb", "spec/css_inlining_spec.rb", "spec/fixtures/style.css", "spec/fixtures/with-style-tag.html", "spec/spec_helper.rb"]
  s.homepage = %q{http://github.com/maca/inline-style}
  s.rdoc_options = ["--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{inline-style}
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{Simple utility for "inlining" all CSS in the style attribute for the html tags}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<nokogiri>, [">= 1.3.3"])
      s.add_runtime_dependency(%q<csspool>, [">= 2.0.0"])
      s.add_development_dependency(%q<newgem>, [">= 1.4.1"])
      s.add_development_dependency(%q<hoe>, [">= 1.8.0"])
    else
      s.add_dependency(%q<nokogiri>, [">= 1.3.3"])
      s.add_dependency(%q<csspool>, [">= 2.0.0"])
      s.add_dependency(%q<newgem>, [">= 1.4.1"])
      s.add_dependency(%q<hoe>, [">= 1.8.0"])
    end
  else
    s.add_dependency(%q<nokogiri>, [">= 1.3.3"])
    s.add_dependency(%q<csspool>, [">= 2.0.0"])
    s.add_dependency(%q<newgem>, [">= 1.4.1"])
    s.add_dependency(%q<hoe>, [">= 1.8.0"])
  end
end
