require "spec_helper"

describe 'CSS parsing' do
  shared_examples_for 'parses css' do
    describe 'parsing tag selector' do
      before do 
        @wrapper = subject.new 'p {background-color: black; padding: 0.0 0.0 0.0 0.0}'
      end

      it { @wrapper.should have(1).rules }

      describe 'rule' do
        before { @rule = @wrapper.rules.first }
        it { @rule.specificity.should == '0001' }
        it { @rule.declarations.should == [['background-color', 'black'], ['padding', '0.0 0.0 0.0 0.0']] }
        it { @rule.selector.should == 'p' }
        it { @rule.dynamic_pseudo_class.should be_nil }
      end
    end

    describe 'parsing body tag selector' do
      before do 
        @wrapper = subject.new 'body {background-color: black; padding: 0.0 0.0 0.0 0.0}'
      end

      it { @wrapper.should have(1).rules }

      describe 'rule' do
        before { @rule = @wrapper.rules.first }
        it { @rule.specificity.should == '0001' }
        it { @rule.declarations.should == [['background-color', 'black'], ['padding', '0.0 0.0 0.0 0.0']] }
        it { @rule.selector.should == 'body' }
        it { @rule.dynamic_pseudo_class.should be_nil }
      end
    end

    describe 'parsing tag and class selector' do
      before do 
        @wrapper = subject.new 'div.article {background-color: black; padding: 0.0 0.0 0.0 0.0}'
      end

      it { @wrapper.should have(1).rules }

      describe 'rule' do
        before { @rule = @wrapper.rules.first }
        it { @rule.specificity.should == '0011' }
        it { @rule.declarations.should == [['background-color', 'black'], ['padding', '0.0 0.0 0.0 0.0']] }
        it { @rule.selector.should == 'div.article' }
        it { @rule.dynamic_pseudo_class.should be_nil }
      end
    end

    describe 'parsing tag, class and id selector' do
      before do 
        @wrapper = subject.new 'div#headline.article {background-color: black; padding: 0.0 0.0 0.0 0.0}'
      end

      it { @wrapper.should have(1).rules }

      describe 'rule' do
        before { @rule = @wrapper.rules.first }
        it { @rule.specificity.should == '0111' }
        it { @rule.declarations.should == [['background-color', 'black'], ['padding', '0.0 0.0 0.0 0.0']] }
        it { @rule.selector.should == 'div#headline.article' }
        it { @rule.dynamic_pseudo_class.should be_nil }
      end
    end

    describe 'parsing tag selector' do
      before do 
        @wrapper = subject.new 'p, div {background-color: black; padding: 0.0 0.0 0.0 0.0}'
      end

      it { @wrapper.should have(2).rules }

      describe 'first rule' do
        before { @rule = @wrapper.rules.first }
        it { @rule.specificity.should == '0001' }
        it { @rule.declarations.should == [['background-color', 'black'], ['padding', '0.0 0.0 0.0 0.0']] }
        it { @rule.selector.should == 'p' }
        it { @rule.dynamic_pseudo_class.should be_nil }
      end

      describe 'last rule' do
        before { @rule = @wrapper.rules.last }
        it { @rule.specificity.should == '0001' }
        it { @rule.declarations.should == [['background-color', 'black'], ['padding', '0.0 0.0 0.0 0.0']] }
        it { @rule.selector.should == 'div' }
        it { @rule.dynamic_pseudo_class.should be_nil }
      end
    end

    describe 'dynamic pseudo selectors' do
      InlineStyle::Rule::DYNAMIC_PSEUDO_CLASSES.each do |pseudo_class|
        describe "parsing tag with :#{pseudo_class}" do
          before { @dynamic_pseudo_class = pseudo_class }
          it_should_behave_like 'parses dynamic pseudo selector'
        end
      end
    end

    describe 'multiple dynamic pseudo selector' do
      before do
        @wrapper = subject.new 'a:visited:hover {background-color: black; padding: 0.0 0.0 0.0 0.0}'
      end

      it { @wrapper.should have(1).rules }

      describe 'rule' do
        before { @rule = @wrapper.rules.first }
        it { @rule.selector.should == 'a' }
        it { @rule.dynamic_pseudo_class.should == 'visited:hover' }
      end
    end
  end

  shared_examples_for 'parses dynamic pseudo selector' do
    describe 'with tag' do
      before do 
        @wrapper = subject.new "p:#{@dynamic_pseudo_class} {background-color: black; padding: 0.0 0.0 0.0 0.0}"
      end

      it { @wrapper.should have(1).rules }

      describe 'rule' do
        before { @rule = @wrapper.rules.first }
        # it { @rule.specificity.should == '011' }
        it { @rule.declarations.should == [['background-color', 'black'], ['padding', '0.0 0.0 0.0 0.0']] }
        it { @rule.selector.should == 'p' }
        it { @rule.dynamic_pseudo_class.should == @dynamic_pseudo_class }
      end
    end

    describe 'without tag' do
      before do 
        @wrapper = subject.new ":#{@dynamic_pseudo_class} {background-color: black; padding: 0.0 0.0 0.0 0.0}"
      end

      it { @wrapper.should have(1).rules }

      describe 'rule' do
        before { @rule = @wrapper.rules.first }
        # it { @rule.specificity.should == '011' }
        it { @rule.declarations.should == [['background-color', 'black'], ['padding', '0.0 0.0 0.0 0.0']] }
        it { @rule.selector.should == '*' }
        it { @rule.dynamic_pseudo_class.should == @dynamic_pseudo_class }
      end
    end
  end

  describe InlineStyle::CssParserWrapper do
    subject { InlineStyle::CssParserWrapper }
    it_should_behave_like 'parses css'
  end

  describe InlineStyle::CssParserWrapper do
    subject { InlineStyle::CSSPoolWrapper }
    it_should_behave_like 'parses css'
  end
end
