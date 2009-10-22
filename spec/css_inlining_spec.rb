require "#{ dir = File.dirname(__FILE__) }/../lib/inline-style"

describe InlineStyle do
  describe 'CSS extraction' do
    it "should extract from style tag"
    it "should extract from link"
  end

  describe 'CSS processing' do
    it 'should separate terms by space'
    it 'should separate terms by coma'
    it 'should order selectors by specificity'
    it 'should order selectors by specificity and defininition order'
  end
  
end





# It should order selectors by specificity
# it should order selectors by specificity and defininition order
# It should apply inline style by tag
# It should apply inline style by universal selector
# It should apply inline style for class
# It should apply inline style for id
# It should overwrite rule with less specificity
# It should overwrite rule previously defined
# It should not overwrite rules defined inline