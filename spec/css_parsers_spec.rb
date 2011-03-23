require "spec_helper"

describe InlineStyle::CssParserWrapper do

  it 'should wrap css_parser' do
    rs_count = 0
    sel_count = 0
    selectors = %w(p b i)
    decs = ['color: black;', 'color: black;', 'color: green; text-decoration: none;']
    spes = [1, 1, 1]
    p = InlineStyle::CssParserWrapper.new "p, b {color: black}\ni {color: green; text-decoration: none}"

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

describe InlineStyle::CSSPoolWrapper do

  it 'should wrap csspool' do
    rs_count = 0
    sel_count = 0
    selectors = %w(p b i)
    decs = ['color: black;', 'color: black;', 'color: green; text-decoration: none;']
    spes = [1, 1, 1]
    p = InlineStyle::CSSPoolWrapper.new "p, b {color: black}\ni {color: green; text-decoration: none}"

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
