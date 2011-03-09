require "#{ File.dirname __FILE__ }/spec_helper"
require "#{ DIR }/../lib/inline-style/css_parsers/css_parser"
require "#{ DIR }/../lib/inline-style/css_parsers/csspool"

describe InlineStyle::CssParsers::CssParser do

  it 'should wrap css_parser' do
    rs_count = 0
    sel_count = 0
    selectors = %w(p b i)
    decs = ['color: black;', 'color: black;', 'color: green; text-decoration: none;']
    spes = [1, 1, 1]
    p = InlineStyle::CssParsers::CssParser.new "p, b {color: black}\ni {color: green; text-decoration: none}"

    p.each_rule_set do |rs|
      rs_count += 1
      rs.each_selector do |sel|
        sel_count += 1
        sel.selector_text.should == selectors.shift
        sel.declarations.should == decs.shift
        sel.specificity.should == spes.shift
      end
    end

    rs_count.should == 2
    sel_count.should == 3
  end

end

describe InlineStyle::CssParsers::Csspool do

  it 'should wrap csspool' do
    rs_count = 0
    sel_count = 0
    selectors = %w(p b i)
    decs = ['color: black;', 'color: black;', 'color: green; text-decoration: none;']
    spes = [1, 1, 1]
    p = InlineStyle::CssParsers::Csspool.new "p, b {color: black}\ni {color: green; text-decoration: none}"

    p.each_rule_set do |rs|
      rs_count += 1
      rs.each_selector do |sel|
        sel_count += 1
        sel.selector_text.should == selectors.shift
        sel.declarations.should == decs.shift
        sel.specificity.should == spes.shift
      end
    end

    rs_count.should == 2
    sel_count.should == 3
  end

end
