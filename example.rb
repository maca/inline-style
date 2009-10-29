require 'rubygems'
require "#{ dir = File.dirname(__FILE__) }/lib/inline-style"

html  = File.read("#{ fixtures = dir + '/spec/fixtures' }/boletin.html")
puts InlineStyle.process(html)
