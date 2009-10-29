require 'rubygems'
require 'spec'
require "#{ DIR = File.dirname(__FILE__) }/../lib/inline-style"
require 'rack'
require 'rack/mock'

FIXTURES = "#{ DIR }/fixtures"


module HaveInlineStyleMatcher
  class HaveInlineStyle
    def initialize selector
      @selector = selector
    end

    def matches? html
      @html = html
      !@html.css(@selector).empty? and @html.css(@selector).inject(true){ |bool, e| bool and !e['style'].nil? }
    end

    def failure_message
      "expected elements with selector #{ @selector } style attribute not to be nil"
    end

    def negative_failure_message
      "expected elements with selector #{ @selector } style attribute to be nil"
    end
  end

  def have_inline_style_for selector
    HaveInlineStyle.new selector
  end
end

Spec::Runner.configure { |config| config.include HaveInlineStyleMatcher }
