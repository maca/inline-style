class InlineStyle
  # A simple abstraction of the data we get back from the parsers. CSSPool
  # actually already does this for us but CSSParser does not so we need
  # to create the abstraction ourselves.
  class Rule
    DYNAMIC_PSEUDO_CLASSES = %w(link visited active hover focus target enabled disabled checked)
    DYNAMIC_PSEUDO_CLASSES_MATCHER = /:(#{DYNAMIC_PSEUDO_CLASSES.join('|')})$/

    attr_reader :selector, :declarations, :specificity, :dynamic_pseudo_class

    def initialize selector, declarations, specificity
      @specificity = specificity
      @selector, @dynamic_pseudo_class = selector.split DYNAMIC_PSEUDO_CLASSES_MATCHER
      @selector.sub! /$^/, '*'
      @declarations = declarations.scan /\s*([^:]+):\s*([^;]+);/
    end
  end
end
