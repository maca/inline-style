module InlineStyle

  # A factory for returning a configured CSS parser. Defaults to
  # :csspool if not specified. Will also use ENV['CSS_PARSER'].
  module CssParsers

    # Allows you to specify the CSS parser to use.
    def self.parser=(parser)
      @parser = nil
      @parser_name = parser
    end

    def self.parser
      return @parser if @parser
      @parser_name = ENV['CSS_PARSER'] || :css_parser unless @parser_name
      require "inline-style/css_parsers/#{@parser_name}"
      @parser = const_get(@parser_name.to_s.gsub(/(?:^|_)(.)/) { $1.upcase })
    end

  end
end
