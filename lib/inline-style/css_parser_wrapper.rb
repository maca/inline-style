require 'css_parser'

class InlineStyle
  class CssParserWrapper
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
          yield InlineStyle::Selector.new(sel, dec, spe)
        end
      end
    end
  end
end
