require 'rubygems'
require "#{ dir = File.dirname(__FILE__) }/lib/inline-style"

html  = File.read("#{ fixtures = dir + '/spec/fixtures' }/boletin.html")
 


File.open("#{ fixtures }/inline.html", 'w') {|f| f.write InlineStyle.process(html, dir) }


# h = Nokogiri.HTML(html)
# p InlineStyle.extract_css(h)
