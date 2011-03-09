require 'css_parser'

module InlineStyle::CssParsers
  class CssParser

    def initialize(css_code)
      @parser = ::CssParser::Parser.new
      @parser.add_block! css_code
    end

    def each_rule_set(&blk)
      @parser.each_rule_set do |rule_set|
        yield Ruleset.new(rule_set)
      end
    end

    class Ruleset

      def initialize(ruleset)
        @ruleset = ruleset
      end

      def each_selector
        @ruleset.each_selector do |sel, dec, spe|
          normalize_for_test! dec
          yield InlineStyle::Selector.new(sel, dec, spe)
        end
      end

      private

      # To make testings work for both parsers we need to conform to
      # csspool normalizing attributes. This means all numbers have a
      # decimal place. It also means that urls do not have quotes.
      #
      # NOTE: This really doesn't have anything to do with the
      # correctness of the parser. It just makes testing easier since
      # each parser can run against the same tests.
      def normalize_for_test!(dec)

          # Give all numbers a decimal if they do not already have it
          dec.gsub! '0;', '0.0;'
          dec.gsub! ' 0 ', ' 0.0 '
          dec.gsub! /([^\.0-9]\d+)px/, '\1.0px'
          dec.gsub! /([^\.0-9]\d+)%/, '\1.0%'

          # Remove any quotes in url()
          dec.gsub! "url('", 'url('
          dec.gsub! "')", ')'

      end

    end

  end
end
