require 'rubygems'
require 'rspec'
require 'rack'
require 'rack/mock'

$:.unshift File.join(File.dirname(__FILE__), '..')
require "inline-style"
require "inline-style/csspool_wrapper"
require "csspool"

FIXTURES = "#{File.dirname __FILE__}/fixtures"

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
      "expected elements with selector #{@selector} style attribute not to be nil"
    end

    def negative_failure_message
      "expected elements with selector #{@selector} style attribute to be nil"
    end
  end


      # private
      # To make testings work for both parsers we need to conform to
      # csspool normalizing attributes. This means all numbers have a
      # decimal place. It also means that urls do not have quotes.
      #
      # NOTE: This really doesn't have anything to do with the
      # correctness of the parser. It just makes testing easier since
      # each parser can run against the same tests.
      # def normalize_for_test!(dec)
      #     # Give all numbers a decimal if they do not already have it
      #     dec.gsub! '0;', '0.0;'
      #     dec.gsub! ' 0 ', ' 0.0 '
      #     dec.gsub! /([^\.0-9]\d+)px/, '\1.0px'
      #     dec.gsub! /([^\.0-9]\d+)%/, '\1.0%'

      #     # Remove any quotes in url()
      #     dec.gsub! "url('", 'url('
      #     dec.gsub! "')", ')'
      # end
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

RSpec.configure { |config| config.include HaveInlineStyleMatcher }
