require "spec_helper"
require "inline-style/mail/interceptor"
require "mail"

Mail.defaults do
  delivery_method :test
end

Mail.register_interceptor InlineStyle::Mail::Interceptor.new(:stylesheets_path => FIXTURES)

describe InlineStyle::Mail::Interceptor do
  before do
    Mail::TestMailer.deliveries.clear
    class InlineStyle
      remove_const :CSSParser
      CSSParser = InlineStyle::CSSPoolWrapper 
    end
  end

  after do
    class InlineStyle
      remove_const :CSSParser
      CSSParser = InlineStyle::CssParserWrapper 
    end
  end

  it 'should inline html e-mail' do
    Mail.deliver do
      to 'joe@example.com'
      from 'joe@example.com'
      subject 'HTML e-mail'
      content_type 'text/html'
      body File.read("#{ FIXTURES }/boletin.html")
    end

    Mail::TestMailer.deliveries.first.body.to_s.
    should == File.read("#{ FIXTURES }/inline.html")
  end

  it 'should not inline non-html' do
    Mail.deliver do
      to 'joe@example.com'
      from 'joe@example.com'
      subject 'Plain text e-mail (with HTML looking content)'
      content_type 'text/plain'
      body File.read("#{ FIXTURES }/boletin.html")
    end

    Mail::TestMailer.deliveries.first.body.to_s.
    should == File.read("#{ FIXTURES }/boletin.html")
  end

  it 'should inline html part of multipart/alternative' do
    Mail.deliver do
      to 'joe@example.com'
      from 'joe@example.com'
      subject 'Multipart/alternative e-mail'
      text_part do
        body File.read("#{ FIXTURES }/boletin.html")
      end
      html_part do
        content_type 'text/html; charset=UTF-8'
        body File.read("#{ FIXTURES }/boletin.html")
      end
    end

    Mail::TestMailer.deliveries.first.parts[0].body.to_s.
    should == File.read("#{ FIXTURES }/boletin.html")

    Mail::TestMailer.deliveries.first.parts[1].body.to_s.
    should == File.read("#{ FIXTURES }/inline.html")
  end
end
