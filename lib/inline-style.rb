require 'nokogiri'
require 'open-uri'

class InlineStyle

  #   Options:
  #     +:stylesheets_path+
  #       Stylesheets root path, can also be a URL
  #
  #     +pseudo+
  #       If set to true will inline style for pseudo classes according to the W3C specification:
  #       http://www.w3.org/TR/css-style-attr.
  #       Defaults to false and should probably be left like that because at least Safari and Firefox don't seem to 
  #       comply with the specification for pseudo class style in the style attribute.
  def self.process html, opts = {}
    new(html, opts).send :process
  end

  private

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

          InlineStyle::CssParsers.parser.new("#{ path }{#{ node['style'] }}").each_rule_set do |rule|
            rule.each_selector do |selector_inner|
              nodes[node].push selector_inner
            end
          end
        end
      end
    end

    nodes.each_pair do |node, selectors|
      selectors = selectors.sort_by{ |sel| "#{ sel.specificity }%03d" % selectors.index(sel) }
      selectors = selectors.reject {|sel| not @pseudo and sel.pseudo?}
      using_pseudo = selectors.any? &:pseudo?
      
      node['style'] = selectors.collect do |selector|
        if using_pseudo && !selector.pseudo?
          "{#{ selector.inline_declarations }}"
        else
          selector.inline_declarations
        end
      end.join(' ').strip
    end
    
    if html_already_parsed?
      @dom
    else
      @dom.to_s
    end
  end

  def dom
    @dom ||= if html_already_parsed?
      @html
    else
      Nokogiri.HTML @html
    end
  end

  def html_already_parsed?
    @html.respond_to? :css
  end

  # Returns parsed CSS
  def css
    @css ||= InlineStyle::CssParsers.parser.new dom.css('style, link').collect { |e|
      next unless e['media'].nil? || ['screen', 'all'].include?(e['media'])
      next(e.remove and e.content) if e.name == 'style'
      next unless e['rel'] == 'stylesheet'
      e.remove
      
      uri = if %r{^https?://} === e['href']
        e['href']
      else
        File.join @stylesheets_path, e['href'].sub(/\?\d+$/,'')
      end
      open(uri).read rescue nil
    }.join("\n")
  end
end

require "#{ File.dirname( __FILE__ ) }/inline-style/selector"
require "#{ File.dirname( __FILE__ ) }/inline-style/css_parsers"
require "#{ File.dirname( __FILE__ ) }/inline-style/rack/middleware"
require "#{ File.dirname( __FILE__ ) }/inline-style/mail/interceptor"
