gem 'maca-fork-csspool'
require 'csspool'

module InlineStyle::CssParsers
  class Csspool

    def initialize(css_code)
      @parser = CSSPool.CSS css_code
    end

    def each_rule_set
      @parser.rule_sets.each do |rule_set|
        yield Ruleset.new(rule_set)
      end
    end

    class Ruleset

      def initialize(ruleset)
        @ruleset = ruleset
      end

      def each_selector(&blk)
        @ruleset.selectors.each do |selector|
          yield selector.to_s,
            selector.declarations.map{ |d| d.to_s.squeeze(' ') }.join.strip,
            selector.specificity.inject(0) {|t, s| t+s}
        end
      end

    end

  end
end
