require 'nokogiri'
require 'open-uri'

require "#{ File.dirname( __FILE__ ) }/inline-style/css_parsers"
require "#{ File.dirname( __FILE__ ) }/inline-style/rack/middleware"
require "#{ File.dirname( __FILE__ ) }/inline-style/mail/interceptor"

module InlineStyle
  VERSION = '0.4.2'  

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
    stylesheets_path = opts[:stylesheets_path] || ''
    pseudo           = opts[:pseudo] || false
    
    nokogiri_doc_given = Nokogiri::HTML::Document === html
    html  = nokogiri_doc_given ? html : Nokogiri.HTML(html)
    css   = extract_css html, stylesheets_path
    nodes = {}

    css.each_rule_set do |rule_set|
      rule_set.each_selector do |css_selector, declarations, specificity|
        orig_selector = css_selector.dup
        css_selector = "#{ 'body ' unless /^body/ === css_selector }#{ css_selector.gsub /:.*/, '' }"
        
        html.css(css_selector).each do |node|
          nodes[node] ||= []
          nodes[node].push [css_selector, declarations, specificity, orig_selector]
          
          next unless node['style']
          
          path = node.css_path
          path << "##{ node['id'] }" if node['id']
          path << ".#{ node['class'].scan(/\S+/).join('.') }" if node['class']
          
          InlineStyle::CssParsers.parser.new("#{ path }{#{ node['style'] }}").each_rule_sets do |rule|
            rule.each_selectors do |css_selector, declarations, specificity|
              nodes[node].push [css_selector, declarations, specificity]
            end
          end
        end
      end
    end

    nodes.each_pair do |node, style|
      style = style.sort_by{ |(sel, dec, spe)| "#{ spe }%03d" % style.index([sel, dec, spe]) }
      sets  = style.partition{ |(sel, dec, spe, orig)| not /:\w+/ === orig  }
      
      sets.pop if not pseudo or sets.last.empty?
      
      node['style'] = sets.collect do |selectors|
        index = sets.index selectors
        
        set   = selectors.map do |(css_selector, declarations, specificity, orig_selector)|
          index == 0 ? declarations : "\n#{ orig_selector.gsub /\w(?=:)/, '' } {#{ declarations }}"
        end
                     
        index == 0 && sets.size > 1 ? "{#{ set }}" : set.collect(&:strip).join(' ')
      end.join.strip
    end
    
    nokogiri_doc_given ? html : html.to_s
  end
  
  # Returns CSSPool::Document
  def self.extract_css html, stylesheets_path = ''
    InlineStyle::CssParsers.parser.new html.css('style, link').collect { |e|
      next unless e['media'].nil?  or ['screen', 'all'].include? e['media']
      next(e.remove and e.content) if e.name == 'style'
      next unless e['rel'] == 'stylesheet'
      e.remove
      
      uri = %r{^https?://} === e['href'] ? e['href'] : File.join(stylesheets_path, e['href'].sub(/\?\d+$/,''))
      open(uri).read rescue nil
    }.join("\n")
  end
end
