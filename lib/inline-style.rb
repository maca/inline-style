require 'nokogiri'
require 'open-uri'

gem 'maca-fork-csspool'
require 'csspool'

require "#{ File.dirname( __FILE__ ) }/inline-style/rack/middleware"
require "#{ File.dirname( __FILE__ ) }/inline-style/mail/interceptor"

module InlineStyle
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

    css.rule_sets.each do |rule_set|
      rule_set.selectors.each do |selector|
        css_selector = selector.to_s
        css_selector = "#{ 'body ' unless /^body/ === css_selector }#{ css_selector.gsub /:.*/, '' }"
        
        html.css(css_selector).each do |node|
          nodes[node] ||= []
          nodes[node].push selector
          
          next unless node['style']
          
          path = node.css_path
          path << "##{ node['id'] }" if node['id']
          path << ".#{ node['class'].scan(/\S+/).join('.') }" if node['class']
          
          CSSPool.CSS("#{ path }{#{ node['style'] }}").rule_sets.each{ |rule| nodes[node].push *rule.selectors }
        end
      end
    end

    nodes.each_pair do |node, style|
      style = style.sort_by{ |sel| "#{ sel.specificity }%03d" % style.index(sel) }
      sets  = style.partition{ |sel| not /:\w+/ === sel.to_s  }
      
      sets.pop if not pseudo or sets.last.empty?
      
      node['style'] = sets.collect do |selectors|
        index = sets.index selectors
        
        set   = selectors.map do |selector|
          declarations = selector.declarations.map{ |d| d.to_css.squeeze(' ') }.join
          index == 0 ? declarations : "\n#{ selector.to_s.gsub /\w(?=:)/, '' } {#{ declarations }}"
        end
                     
        index == 0 && sets.size > 1 ? "{#{ set }}" : set.join
      end.join.strip
    end
    
    nokogiri_doc_given ? html : html.to_s
  end
  
  # Returns CSSPool::Document
  def self.extract_css html, stylesheets_path = ''
    CSSPool.CSS html.css('style, link').collect { |e|
      next unless e['media'].nil? || ['screen', 'all'].include?(e['media'])
      next(e.remove and e.content) if e.name == 'style'
      next unless e['rel'] == 'stylesheet'
      e.remove
      
      uri = %r{^https?://} === e['href'] ? e['href'] : File.join(stylesheets_path, e['href'].sub(/\?\d+$/,''))
      open(uri).read rescue nil
    }.join("\n")
  end
end
