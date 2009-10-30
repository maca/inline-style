require "#{ File.dirname __FILE__ }/spec_helper"

describe InlineStyle::Rack::Middleware do

  def get_response path, body, opts = {}
    content_type = opts.delete(:content_type) || 'text/html'
    app = Rack::Builder.new do
      use InlineStyle::Rack::Middleware, opts
      run lambda { |env| env['DOCUMENT_ROOT'] = FIXTURES; [200, {'Content-Type' => content_type}, body ] }
    end    
    Nokogiri.HTML Rack::MockRequest.new(app).get(path).body
  end
  
  before do
    @html = File.read("#{ FIXTURES }/boletin.html")
  end

  it "should inline css" do
    get_response('/', @html, :stylesheets_path => FIXTURES).should have_inline_style_for('#A')
  end
  
  it "should use external css" do
    get_response('/', Nokogiri.HTML(@html), :stylesheets_path => FIXTURES).css('#izq').first['style'].should =~ /margin: 30.0px/
  end
  
  describe 'Path inclusion' do
    
    it "should inline style for string path" do
      paths = "/some/path"
      get_response('/some/path', @html, :stylesheets_path => FIXTURES, :paths => paths).should have_inline_style_for('#A')
    end
    
    it "should not inline style for string path" do
      paths = "/some/path"
      get_response('/some/other/path', @html, :stylesheets_path => FIXTURES, :paths => paths).should_not have_inline_style_for('#A')
    end
    
    it "should inline style for regexp path" do
      paths = %r{/some/.*}
      get_response('/some/path', @html, :stylesheets_path => FIXTURES, :paths => paths).should have_inline_style_for('#A')
      get_response('/some/other/path', @html, :stylesheets_path => FIXTURES, :paths => paths).should have_inline_style_for('#A')
    end
    
    it "should not inline style for regexp path" do
      paths = %r{/some/.*}
      get_response('/other/path', @html, :stylesheets_path => FIXTURES, :paths => paths).should_not have_inline_style_for('#A')
    end

    it "should inline style for array regexp path" do
      paths = [%r{/some/path}, %r{/some/other/path}]
      get_response('/some/path', @html, :stylesheets_path => FIXTURES, :paths => paths).should have_inline_style_for('#A')
      get_response('/some/other/path', @html, :stylesheets_path => FIXTURES, :paths => paths).should have_inline_style_for('#A')
    end
    
    it "should not inline style for array regexp path" do
      paths = [%r{/some/path}, %r{/some/other/path}]
      get_response('/path', @html, :stylesheets_path => FIXTURES, :paths => paths).should_not have_inline_style_for('#A')
      get_response('/other/path', @html, :stylesheets_path => FIXTURES, :paths => paths).should_not have_inline_style_for('#A')
    end
  end
end