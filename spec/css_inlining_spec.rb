require "#{ File.dirname __FILE__ }/spec_helper"

describe InlineStyle do
  before do
    @processed = InlineStyle.process Nokogiri.HTML(File.read("#{ FIXTURES }/boletin.html")), 
      :pseudo => false,
      :stylesheets_path => FIXTURES
  end

  it "should extract from linked stylesheet" do
    @processed.css('#izq').first['style'].should =~ /margin: 30.0px;/
  end
  
  it "should extract styles from linked stylesheet with no media specified" do
    @processed.css('#izq').first['style'].should =~ /color: red;/
  end
  
  it "should extract styles from linked stylesheet with media 'all'" do
    @processed.css('#izq').first['style'].should =~ /padding: 10.0px;/
  end
  
  it "should ignore styles from linked stylesheet with media other than screen" do
    @processed.css('#izq').first['style'].should_not =~ /display: none;/
  end

  it "should not process pseudo classes" do
    @processed.to_s.should_not =~ /:hover/
    @processed.to_s.should_not =~ /\{/
  end
  
  it "should should process pseudo classes" do
    processed = InlineStyle.process Nokogiri.HTML(File.read("#{ FIXTURES }/boletin.html")), :pseudo => true
    processed.css('a').first['style'].should =~ /:hover/
    processed.css('a').first['style'].should =~ /\{/
  end

  it 'should process location-based pseudo classes' do
    @processed.at_css('#izq')['style'].should =~ /padding: 1.0px;/
  end

  it 'should apply to #A #B' do
    @processed.css('#logos #der').first['style'].should =~ /float: right;/
  end
  
  # it 'should order selectors by specificity'
  # it 'should order selectors by specificity and defininition order'
  # it 'should overwrite rule with less specificity'
  # it 'should overwrite rule previously defined'
  # it 'should not overwrite rules defined inline'
  
  describe 'Box model' do
    before do
      @processed = InlineStyle.process( Nokogiri.HTML(File.read("#{ FIXTURES }/box-model.html")) )
    end

    it "should inline style for selector ul" do
      @processed.css('ul').first['style'].should == "background: yellow; margin: 12.0px 12.0px 12.0px 12.0px; padding: 3.0px 3.0px 3.0px 3.0px;"
    end

    it "should inline style for selector li" do
      @processed.css('li').each do |li|
        li['style'].should =~ /^color: white; background: blue; margin: 12.0px 12.0px 12.0px 12.0px; padding: 12.0px 0.0px 12.0px 12.0px; list-style: none/
      end
    end

    it "should inline style for selector li.withborder" do
      @processed.css('li.withborder').first['style'].
      should == "color: white; background: blue; margin: 12.0px 12.0px 12.0px 12.0px; padding: 12.0px 0.0px 12.0px 12.0px; list-style: none; border-style: dashed; border-width: medium; border-color: lime;"    
    end
  end
end





