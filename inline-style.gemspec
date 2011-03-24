# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "inline-style/version"

Gem::Specification.new do |s|
  s.name        = "inline-style"
  s.version     = InlineStyle::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Macario Ortega", "Eric Anderson"]
  s.email       = ["macarui@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Inlines CSS for html email delivery}
  s.description = %q{Inlines CSS for html email delivery}
  s.post_install_message = %{Please read documentation for changes on the default css parser gem, specifically if you use csspool}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency 'rspec'
  s.add_development_dependency 'rack'
  s.add_development_dependency 'rspec-core'
  s.add_development_dependency 'mail'

  s.add_dependency 'nokogiri'
  s.add_dependency 'facets'
  s.add_dependency 'css_parser'
  s.add_dependency 'maca-fork-csspool'
end
