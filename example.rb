require 'rubygems'
require "#{ dir = File.dirname(__FILE__) }/lib/inline-style"
require 'benchmark'

html  = File.read("#{ dir }/spec/fixtures/with-style-tag.html")
puts InlineStyle.process(html, "#{ dir }/spec/fixtures")
