require 'css_parser'

class InlineStyle
  class CssParserWrapper
    attr_accessor :rules

    def initialize(css_code)
      parser, @rules = CssParser::Parser.new, []
      parser.add_block! css_code
      parser.each_rule_set do |rule_set| 
        rule_set.each_selector { |sel, dec, spec| @rules << Rule.new(sel, dec, '%04d' % spec.to_i) } 
      end
    end
  end
end
