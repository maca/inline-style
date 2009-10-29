module InlineStyle
  module Rack
    class Middleware
      #
      #   Options:
      #     +document_root+
      #       File system path for app's public directory where the stylesheets are to be found, defaults to
      #       env['DOCUMENT_ROOT']
      #     
      #     +paths+
      #       Limit processing to the passed absolute paths
      #       Can be an array of strings or regular expressions, a single string or regular expression
      #       If not passed will process output for every path.
      #       Regexps and strings must comence with '/'
      #
      #     +pseudo+
      #       If set to true will inline style for pseudo classes according to the W3C specification:
      #       http://www.w3.org/TR/css-style-attr.
      #       Defaults to false and should probably be left like that because at least Safari and Firefox don't seem to 
      #       comply with the specification for pseudo class style in the style attribute.
      #
      def initialize app, opts = {}
        @app   = app
        @opts  = opts
        @paths = /^(?:#{ [*opts[:paths]].join('|') })/
      end

      def call env
        response = @app.call env
        return response unless @paths === env['PATH_INFO']
        
        status, headers, content = response
        response = ::Rack::Response.new '', status, headers
        body     = content.respond_to?(:body) ? content.body : content
        
        response.write InlineStyle.process(body, {:document_root => env['DOCUMENT_ROOT']}.merge(@opts))
        response.finish
      end
    end
  end
end
  