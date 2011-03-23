require "spec_helper"

describe InlineStyle do
  shared_examples_for 'inlines styles' do
    before do
      processed  = InlineStyle.process File.read("#{FIXTURES}/boletin.html"), :pseudo => false, :stylesheets_path => FIXTURES
      @processed = Nokogiri.HTML(processed)
    end

    it "should extract from linked stylesheet" do
      @processed.css('#izq').first['style'].should match_style /margin: 30.0px;/
    end

    it "should extract styles from linked stylesheet with no media specified" do
      @processed.css('#izq').first['style'].should match_style /color: red;/
    end

    it "should extract styles from linked stylesheet with media 'all'" do
      @processed.css('#izq').first['style'].should match_style /padding: 10.0px;/
    end

    it "should ignore styles from linked stylesheet with media other than screen" do
      @processed.css('#izq').first['style'].should_not match_style /display: none;/
    end

    it "should not process pseudo classes" do
      @processed.css('a').first['style'].should_not match_style /^:hover \{background-color: #8ae0ea; color: #126b5d;\}$/
    end

    it "should should process pseudo classes" do
      processed = InlineStyle.process Nokogiri.HTML(File.read("#{FIXTURES}/boletin.html")), :pseudo => true
      processed.css('a').first['style'].should match_style /^:hover \{background-color: #8ae0ea; color: #126b5d;\}$/
    end

    it 'should process location-based pseudo classes' do
      @processed.at_css('#izq')['style'].should match_style /padding: 1.0px;/
    end

    it 'should apply to #A #B' do
      @processed.css('#logos #der').first['style'].should match_style /float: right;/
    end

    # it 'should overwrite rule with less specificity'
    # it 'should overwrite rule previously defined'
    # it 'should not overwrite rules defined inline'

    describe 'Box model' do
      before do
        @processed = InlineStyle.process(Nokogiri.HTML(File.read("#{FIXTURES}/box-model.html")))
      end

      it "should inline style for selector ul" do
        @processed.css('ul').first['style'].should match_style /^background: yellow; margin: 12.0px 12.0px 12.0px 12.0px; padding: 3.0px 3.0px 3.0px 3.0px;$/
      end

      it "should inline style for selector li" do
        @processed.css('li').each do |li|
          li['style'].should match_style /^color: white; background: blue; margin: 12.0px 12.0px 12.0px 12.0px; padding: 12.0px 0.0px 12.0px 12.0px; list-style: none/
        end
      end

      it "should inline style for selector li.withborder" do
        @processed.css('li.withborder').first['style'].
          should match_style /^color: white; background: blue; margin: 12.0px 12.0px 12.0px 12.0px; padding: 12.0px 0.0px 12.0px 12.0px; list-style: none; border-style: dashed; border-width: medium; border-color: lime;$/    
      end
    end
  end

  describe CssParser do
    it { InlineStyle::CSSParser.should == InlineStyle::CssParserWrapper }
    it_should_behave_like 'inlines styles'
  end

  describe CSSPool do
    before do
      class InlineStyle
        remove_const :CSSParser
        CSSParser = InlineStyle::CSSPoolWrapper 
      end
    end

    after do
      class InlineStyle
        remove_const :CSSParser
        CSSParser = InlineStyle::CssParserWrapper 
      end
    end
    it { InlineStyle::CSSParser.should == InlineStyle::CSSPoolWrapper }
    it_should_behave_like 'inlines styles'
  end
end
