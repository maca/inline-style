class InlineStyle
  class CSSPoolWrapper
    attr_accessor :rules

    def initialize css_code
      parser = CSSPool.CSS css_code
      @rules = parser.rule_sets.map do |rule_set| 
        rule_set.selectors.map { |sel| Rule.new(sel.to_s, sel.declarations.join, "0#{sel.specificity.join}") }
      end.flatten 
    end
  end
end
