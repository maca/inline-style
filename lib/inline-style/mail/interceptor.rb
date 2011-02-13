# A interceptor for +mail+ (https://github.com/mikel/mail) to
# automatically inline the styles of outgoing e-mails. To use:
#
#   Mail.register_interceptor \
#     InlineStyle::Mail::Interceptor.new(:stylesheets_path => 'public')
#
# Rails 3's ActionMailer wraps around the +mail+ and also supports
# interceptors. Example usage:
#
#   ActionMailer::Base.register_interceptor \
#     InlineStyle::Mail::Interceptor.new(:stylesheets_path => 'public')
module InlineStyle
  module Mail
    class Interceptor
      # The mime types we should inline. Basically HTML and XHTML.
      # If you have something else you can just push it onto the list
      INLINE_MIME_TYPES = %w(text/html application/xhtml+xml)

      # Save the options to later pass to InlineStyle.process
      def initialize(options={})
        @options = options
      end

      # Mail callback where we actually inline the styles
      def delivering_email(part)
        if part.multipart?
          for part in part.parts
            delivering_email part
          end
        elsif INLINE_MIME_TYPES.any? {|m| part.content_type.starts_with? m}
          part.body = InlineStyle.process(part.body.to_s, @options)
        end
      end

    end
  end
end
