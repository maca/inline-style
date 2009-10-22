require 'nokogiri'
require 'open-uri'
require 'csspool'

require "#{ File.dirname( __FILE__ ) }/inline-style/rack/middleware"

module InlineStyle
  VERSION = '0.0.1'
  
  def self.process html, document_root
    nokogiri_doc_given = Nokogiri::HTML::Document === html
        
    html  = nokogiri_doc_given ? html : Nokogiri.HTML(html)
    css   = extract_css html, document_root
    nodes = {}

    css.rule_sets.each do |rule_set|
      rule_set.selectors.each do |selector|
        html.css("body #{ selector }").each do |node|
          nodes[node] ||= []
          nodes[node].push selector
          
          next unless node['style']
          
          path = node.css_path
          path << "##{ node['id'] }" if node['id']
          path << ".#{ node['class'].scan(/\S+/).join('.') }" if node['class']
          
          CSSPool.CSS("#{ path }{#{ node['style'] }}").rule_sets.each{ |rule| nodes[node].push *rule.selectors}
        end
      end
    end

    nodes.each_pair do |node, style|
      style = style.sort_by{ |sel| "#{ sel.specificity }#{ style.index sel }" } #TO fix
      style.map!{ |sel| sel.declarations.map{ |d| d.to_css.strip }.join } and style.uniq!
      node['style'] = style.join
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
      File.read File.join(document_root, e['href'])
    }.join("\n")
  end
  
end