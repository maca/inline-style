require 'nokogiri'
require 'open-uri'
require '/Users/sistemasinteractivos/Gems/Web/csspool/lib/csspool'

require "#{ File.dirname( __FILE__ ) }/inline-style/rack/middleware"

module InlineStyle
  VERSION = '0.1.2'
  
  def self.process html, document_root
    nokogiri_doc_given = Nokogiri::HTML::Document === html
    html  = nokogiri_doc_given ? html : Nokogiri.HTML(html)
    css   = extract_css html, document_root
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

      node['style'] = sets.collect do |selectors|
        next if selectors.empty?  

        index = sets.index selectors
        set   = selectors.map do |selector|
          declarations = selector.declarations.map{ |d| d.to_css.strip }.join
          index == 0 ? declarations : "#{ selector.to_s.gsub /\w(?=:)/, '' } {#{ declarations }}"
        end
        
        index == 0 && !sets.last.empty? ? "{#{ set }}" : set.join
      end.compact.join(";")
    end
    
    nokogiri_doc_given ? html : html.to_s
  end
  
  def self.extract_css html, document_root
    CSSPool.CSS html.css('style, link').collect { |e|
      next unless e['media'].nil? or e['media'].match /\bscreen\b/
      next(e.remove and e.content) if e.name == 'style'
      next unless e['rel'] == 'stylesheet'
      e.remove
      next open(e['href']).read if %r{^https?://} === e['href']
      File.read File.join(document_root, e['href'].sub(/\?\d+$/,'')) rescue ''
    }.join("\n")
  end
  
end