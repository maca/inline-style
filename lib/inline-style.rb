require 'nokogiri'
require 'open-uri'

$:.unshift(File.dirname(__FILE__)) unless $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require "inline-style/selector"
require "inline-style/rack/middleware" # This two may be should be required by user if she needs it
require "inline-style/mail/interceptor"

class InlineStyle
  CSSParser =
  if const_defined? :CSSPool
    require 'inline-style/csspool_wrapper'
    CSSPoolWrapper
  else
    require 'inline-style/css_parser_wrapper'
    CssParserWrapper
  end

  # @param [String, Nokogiri::HTML::Document] html Html or Nokogiri html to be inlined
  # @param [Hash] opts Processing options
  #
  # @option opts [String] :stylesheets_path (env['DOCUMENT_ROOT']) 
  #       Stylesheets root path or app's public directory where the stylesheets are to be found
  # @option opts [boolean] :pseudo (false) 
  #       If set to true will inline style for pseudo classes according to the W3C specification:
  #       http://www.w3.org/TR/css-style-attr.
  #       Should probably be left as false because browsers don't seem to comply with the specification for pseudo class style in the style attribute.
  def self.process html, opts = {}
    new(html, opts).process
  end

  def initialize html, opts = {}
    @html             = html
    @stylesheets_path = opts[:stylesheets_path] || ''
    @pseudo           = opts[:pseudo]
  end

  def process
    nodes = {}

    css.each_rule_set do |rule_set|
      rule_set.each_selector do |selector|
        dom.css(selector.search).each do |node|
          nodes[node] ||= []
          nodes[node].push selector
          
          next unless node['style']
          
          path = node.css_path
          path << "##{ node['id'] }" if node['id']
          path << ".#{ node['class'].scan(/\S+/).join('.') }" if node['class']

          CSSParser.new("#{path}{#{node['style']}}").each_rule_set do |rule|
            rule.each_selector do |selector_inner|
              nodes[node].push selector_inner
            end
          end
        end
      end
    end

    nodes.each_pair do |node, selectors|
      selectors = selectors.sort_by{ |sel| "#{ sel.specificity }%03d" % selectors.index(sel) }
      selectors = selectors.reject {|sel| !@pseudo && sel.pseudo? }
      using_pseudo = selectors.any? &:pseudo?
      
      node['style'] = selectors.collect do |selector|
        if using_pseudo && !selector.pseudo?
          "{#{selector.inline_declarations}}"
        else
          selector.inline_declarations
        end
      end.join(' ').strip
    end
    
    html_already_parsed? ? @dom : @dom.to_s
  end

  private
  def dom
    @dom ||= html_already_parsed? ? @html : Nokogiri.HTML(@html)
  end

  def html_already_parsed?
    @html.respond_to? :css
  end

  # Returns parsed CSS
  def css
    @css ||= CSSParser.new dom.css('style, link').collect { |e|
      next unless e['media'].nil? || ['screen', 'all'].include?(e['media'])
      next(e.remove and e.content) if e.name == 'style'
      next unless e['rel'] == 'stylesheet'
      e.remove
      
      uri = %r{^https?://} === e['href'] ? e['href'] : File.join(@stylesheets_path, e['href'].sub(/\?.+$/,'')) 
      open(uri).read rescue nil
    }.join("\n")
  end
end
