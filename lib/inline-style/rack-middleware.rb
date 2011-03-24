module InlineStyle::Rack
  class Middleware
    # @param [Hash] opts Middlewar options
    #
    # @option opts [String] :stylesheets_path (env['DOCUMENT_ROOT']) 
    #       Stylesheets root path or app's public directory where the stylesheets are to be found
    # @option opts [Regexp, Array, String] :paths
    #       Limit processing to the passed absolute paths
    #       Can be an array of strings or regular expressions, a single string or regular expression
    #       If not passed will process output for every path.
    #       Regexps and strings must comence with '/'
    # @option opts [Boolean] :pseudo (false) 
    #       If set to true will inline style for pseudo classes according to the W3C specification:
    #       http://www.w3.org/TR/css-style-attr.
    #       Should probably be left as false because browsers don't seem to comply with the specification for pseudo class style in the style attribute.
    def initialize app, opts = {}
      @app   = app
      @opts  = opts
      @paths = /^(?:#{ [*opts[:paths]].join('|') })/
    end

    def call env
      response = @app.call env
      return response unless @paths === env['PATH_INFO']
      
      status, headers, body = response
      
      body = InlineStyle.process(body.first, {:stylesheets_path => env['DOCUMENT_ROOT']}.merge(@opts))
      [status, headers, [body]]
    end
  end
end
  
