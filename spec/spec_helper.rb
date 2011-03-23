require 'rubygems'
require 'rspec'
require 'rack'
require 'rack/mock'

require "inline-style"
require "inline-style/csspool_wrapper"
require "csspool"

FIXTURES = "#{File.dirname __FILE__}/fixtures"

module InlineStyleMatchers
  class HaveInlineStyle
    def initialize selector
      @selector = selector
    end

    def matches? html
      @html = html
      !@html.css(@selector).empty? and @html.css(@selector).inject(true){ |bool, e| bool and !e['style'].nil? }
    end

    def failure_message
      "expected elements with selector #{@selector} style attribute not to be nil"
    end

    def negative_failure_message
      "expected elements with selector #{@selector} style attribute to be nil"
    end
  end

  class MatchStyle
    def initialize style
      @style = style  
    end

    def matches? actual
      @actual = actual.gsub(/([^\.0-9]\d+)(px|;|%|\s)/, '\1.0\2')
      @actual =~ @style
    end

    def failure_message
      "expected #{@style} to match #{@actual}"
    end

    def negative_failure_message
      "expected #{@style} not to match #{@actual}"
    end
  end

  def have_inline_style_for selector
    HaveInlineStyle.new selector
  end

  def match_style style
    MatchStyle.new style
  end
end

RSpec.configure { |config| config.include InlineStyleMatchers }
