require 'rubygems'
require "#{ File.dirname(__FILE__) }/lib/inline-style"

html  = File.read("#{ dir = File.dirname(__FILE__) + '/spec/fixtures' }/boletin.html")
puts InlineStyle.process(html, dir)
