# A simple abstraction of the data we get back from the parsers. CSSPool
# actually already does this for us but CSSParser does not so we need
# to create the abstraction ourselves.
class InlineStyle::Selector < Struct.new :selector_text, :declarations, :specificity

  # A slightly adjusted version of the selector_text that should be
  # used for finding nodes.
  def search
    selector_text.gsub(/:.*/, '').tap {|s| s.insert(0, 'body ') unless s =~ /^body/}
  end

  # For the most part is just declarations unless a pseudo selector.
  # Then it uses the inline pseudo declarations 
  def inline_declarations
    if pseudo?
      "\n#{ selector_text.gsub /\w(?=:)/, '' } {#{ declarations }}"
    else
      declarations
    end
  end

  # Is this selector using a pseudo class?
  def pseudo?
    selector_text =~ /:\w+/ 
  end

end
