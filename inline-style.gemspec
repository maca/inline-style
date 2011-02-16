# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{inline-style}
  s.version = "0.4.2.20110212194827"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Macario Ortega"]
  s.date = %q{2011-02-12}
  s.description = %q{Will take all css in a page (either from linked stylesheet or from style tag) and will embed it in the style attribute for 
each refered element taking selector specificity and declarator order.

Useful for html email: some clients (gmail, et all) won't render non inline styles.

* Includes a Rack middleware for using with Rails, Sinatra, etc...
* It takes into account selector specificity.}
  s.email = ["macarui@gmail.com"]
  s.extra_rdoc_files = ["History.txt", "Manifest.txt"]
  s.files = ["History.txt", "Manifest.txt", "README.rdoc", "Rakefile", "example.rb", "lib/inline-style.rb", "lib/inline-style/rack/middleware.rb", "spec/as_middleware_spec.rb", "spec/css_inlining_spec.rb", "spec/fixtures/all.css", "spec/fixtures/boletin.html", "spec/fixtures/box-model.html", "spec/fixtures/inline.html", "spec/fixtures/none.css", "spec/fixtures/print.css", "spec/fixtures/selectors.html", "spec/fixtures/style.css", "spec/spec_helper.rb", ".gemtest"]
  s.homepage = %q{http://github.com/maca/inline-style}
  s.rdoc_options = ["--main", "README.txt"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{inline-style}
  s.rubygems_version = %q{1.4.2}
  s.summary = %q{Will take all css in a page (either from linked stylesheet or from style tag) and will embed it in the style attribute for  each refered element taking selector specificity and declarator order}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<nokogiri>, [">= 1.3.3"])
      s.add_runtime_dependency(%q<maca-fork-csspool>, [">= 2.0.2"])
      s.add_development_dependency(%q<newgem>, [">= 1.5.3"])
      s.add_development_dependency(%q<mail>, [">= 0"])
      s.add_development_dependency(%q<hoe>, [">= 2.9.1"])
    else
      s.add_dependency(%q<nokogiri>, [">= 1.3.3"])
      s.add_dependency(%q<maca-fork-csspool>, [">= 2.0.2"])
      s.add_dependency(%q<newgem>, [">= 1.5.3"])
      s.add_dependency(%q<mail>, [">= 0"])
      s.add_dependency(%q<hoe>, [">= 2.9.1"])
    end
  else
    s.add_dependency(%q<nokogiri>, [">= 1.3.3"])
    s.add_dependency(%q<maca-fork-csspool>, [">= 2.0.2"])
    s.add_dependency(%q<newgem>, [">= 1.5.3"])
    s.add_dependency(%q<mail>, [">= 0"])
    s.add_dependency(%q<hoe>, [">= 2.9.1"])
  end
end
