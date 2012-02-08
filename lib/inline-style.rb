require 'nokogiri'
require 'open-uri'
require "inline-style/rule"
require "inline-style/rack-middleware" # This two may be should be required by user if she needs it
require "inline-style/mail-interceptor"

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
  # @option opts [String] :stylesheets_path (ENV['DOCUMENT_ROOT']) 
  #       Stylesheets root path or app's public directory where the stylesheets are to be found
  def self.process html, opts = {}
    new(html, opts).process
  end

  def initialize html, opts = {}
    @stylesheets_path = opts[:stylesheets_path] || ENV['DOCUMENT_ROOT'] || '.'
    @html           = html
    @dom = String === html ? Nokogiri.HTML(html) : html
  end

  def process
    nodes_with_rules.each_pair do |node, rules|
      rules = rules.sort_by{ |sel| "#{sel.specificity}%04d" % rules.index(sel) }

      styles = []
      rules.each do |rule|
        next if rule.dynamic_pseudo_class
        rule.declarations.each do |declaration| 
          if defined = styles.assoc(declaration.first)
            styles[styles.index(defined)] = declaration # overrides defined declaration
          else
            styles << declaration
          end
        end
      end

      style = styles.map{ |declaration| declaration.join(': ') }.join('; ') 
      node['style'] = "#{style};" unless style.empty?
    end
    pre_parsed? ? @dom : @dom.to_s
  end

  private
  def nodes_with_rules
    nodes, body = {}, @dom.css('body')

    parse_css.rules.each do |rule|
      body.css(rule.selector).each do |node|
        nodes[node] ||= []
        nodes[node].push rule
      end
    end

    body.css('[style]').each do |node| 
      nodes[node] ||= []
      nodes[node].push Rule.new ':inline', node['style'], '1000' # :inline is not really a pseudoclass
    end

    nodes
  end

  def pre_parsed?
    @html == @dom
  end

  # Returns parsed CSS
  def extract_css
    @dom.css('style, link[rel=stylesheet]').collect do |node|
      next unless /^$|screen|all/ === node['media'].to_s
      node.remove

      if node.name == 'style'
        node.content 
      else
        uri = %r{^https?://} === node['href'] ? node['href'] : File.join(@stylesheets_path, node['href'].sub(/\?.+$/,'')) 
        open(uri).read.sub(/^\uFEFF/, '')
      end
    end.join("\n")
  end

  def parse_css
    CSSParser.new extract_css 
  end
end
