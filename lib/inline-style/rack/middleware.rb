module InlineStyle
  module Rack
    
    class Middleware
      #   Options:
      #     +document_root+
      #       File system path for app's public directory where the stylesheets are to be found, defaults to
      #       env['DOCUMENT_ROOT']
      #     
      #     +paths+
      #       Limit processing to the passed absolute paths
      #       Can be an array of strings or regular expressions, a single string or regular expression
      #       If not passed will process output for every path
      def initialize app, opts = {}
        @app           = app
        @document_root = opts[:document_root]
        @paths         = Regexp.new [*opts[:paths]].join('|')
      end

      def call env
        response = @app.call env
        return response unless @paths === env['PATH_INFO']
        
        status, headers, content = response
        response = ::Rack::Response.new '', status, headers
        body     = content.respond_to?(:body) ? content.body : content
                
        response.write InlineStyle.process(body, @document_root || env['DOCUMENT_ROOT'])
        response.finish
      end
    end
    
  end
end
  