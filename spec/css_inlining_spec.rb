require "#{ File.dirname __FILE__ }/spec_helper"

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
  
  
  describe 'Box model' do
    before do
      @processed = InlineStyle.process( Nokogiri.HTML(File.read("#{ FIXTURES }/box-model.html")) )
    end
    
    it "should inline style for selector ul" do
      style = @processed.css('ul').first['style'].should == "background: yellow; margin: 12.0px 12.0px 12.0px 12.0px; padding: 3.0px 3.0px 3.0px 3.0px;"

    end
    
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