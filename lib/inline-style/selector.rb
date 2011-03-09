# A simple abstraction of the data we get back from the parsers. CSSPool
# actually already does this for us but CSSParser does not so we need
# to create the abstraction ourselves.
class InlineStyle::Selector < Struct.new :selector_text, :declarations, :specificity

  # A slightly adjusted version of the selector_text that should be
  # used for finding nodes. Will remove the pseudo selector and prepend
  # 'body '.
  def search
    selector_text.dup.tap do |s|
      state_based_pseudo_selectors.each {|p| s.gsub! /:#{p}$/, ''}
      s.insert(0, 'body ') unless s =~ /^body/
    end
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
    state_based_pseudo_selectors.any? {|p| selector_text.end_with? ":#{p}"} 
  end

  # A list of state based pseudo selectors (like hover) that should
  # be handled based on the pseudo option. Unlike position-based
  # pseudo selectors (like :first-child) which once resolved to the
  # correct node effectively get inlined like a normal selector.
  def state_based_pseudo_selectors
    %w(link visited active hover focus target enabled disabled checked)
  end

end
