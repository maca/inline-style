require "#{ File.dirname __FILE__ }/spec_helper"

describe InlineStyle::CssParsers do

  before do
    @orig_env = ENV['CSS_PARSER']
    ENV['CSS_PARSER'] = nil
    InlineStyle::CssParsers.parser = nil # Clear out any cached value
  end
  after do
    ENV['CSS_PARSER'] = @orig_env
    InlineStyle::CssParsers.parser = nil # Clear out any cached value
  end

  it 'should load css_parser by default' do
    InlineStyle::CssParsers.parser.name.
    should == 'InlineStyle::CssParsers::CssParser'
  end

  it "should obey ENV['CSS_PARSER']" do
    ENV['CSS_PARSER'] = 'css_parser'
    InlineStyle::CssParsers.parser.name.
    should == 'InlineStyle::CssParsers::CssParser'
  end

  it 'should be able to load csspool' do
    InlineStyle::CssParsers.parser = :csspool
    InlineStyle::CssParsers.parser.name.
    should == 'InlineStyle::CssParsers::Csspool'
  end

  it 'should be able to load css_parser' do
    InlineStyle::CssParsers.parser = :css_parser
    InlineStyle::CssParsers.parser.name.
    should == 'InlineStyle::CssParsers::CssParser'
  end

end
