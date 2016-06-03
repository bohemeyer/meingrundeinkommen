class CacheControl

  # In development, this file is *not* reloaded automatically by Rails.
  # For changes to apply, you need to restart your development web server,
  # or do a `spring stop` before running specs via Spring (bin/rspec).

  def initialize(app)
    @app = app
  end

  def call(env)
    request = ::Rack::Request.new(env)
    old_session_cookie_value = request.cookies[session_name]

    status, headers, body = @app.call(env)

    if headers['X-May-Cache'] == '1'
      # If the session was not changed, we remove its Set-Cookie header.
      HeadersCleaner.
        new(headers, old_session_cookie_value, session_name).
        strip_unchanged_session!

      if headers['Set-Cookie']
        # There are (still) cookies to be set. This response becomes private.
        headers['X-May-Cache'] = '0'
        ::Rack::Utils.set_cookie_header! headers, 'no_cache', 1
      elsif request.cookies.has_key?('no_cache')
        # Request bypassed cache, and this response may be cached.
        # We did not rewrite this response, so the next request may be served from the cache.
        ::Rack::Utils.delete_cookie_header! headers, 'no_cache'
      end
    end

    [status, headers, body]
  end

  private

  def session_name
    Rails.application.config.session_options[:key]
  end

  class HeadersCleaner

    def initialize(headers, old_session_cookie_value, session_name)
      @headers = headers
      Rack::Response.new.headers
      @old_session_cookie_value = old_session_cookie_value
      @session_name = session_name
    end

    def strip_unchanged_session!
      return unless cookies.size == 1
      return unless session_cookie?(cookies.first)

      # Application sends back ONLY the session cookie. This happens when the
      # user sent it to the application, even when there were no changes to it.
      # If the session did not change, there is no reason to disallow caching.
      # However, we need to remove the Set-Cookie header.

      old_session = decrypt_session_cookie(@old_session_cookie_value)
      new_session = decrypt_session_cookie(cookie_value(cookies.first))

      if old_session == new_session
        @headers.delete 'Set-Cookie'
      end
    end

    private

    def cookies
      @cookies ||= case @headers['Set-Cookie']
      when ''
        []
      when String
        @headers['Set-Cookie'].split(/\n+/)
      when Array
        @headers['Set-Cookie']
      else
        []
      end
    end

    def session_cookie?(cookie_string)
      cookie_string.starts_with?("#{@session_name}=")
    end

    def cookie_value(cookie_string)
      match = cookie_string.match(/\A[^=]+=([^\;]+)(?:\;.*\z|\z)/)
      match[1] if match
    end

    def decrypt_session_cookie(cookie)
      return if cookie.blank?

      # Based on https://gist.github.com/pdfrod/9c3b6b6f9aa1dc4726a5
      cookie = CGI::unescape(cookie)

      key_generator = Rails.application.key_generator
      secret = key_generator.generate_key(Rails.application.config.action_dispatch.encrypted_cookie_salt)
      sign_secret = key_generator.generate_key(Rails.application.config.action_dispatch.encrypted_signed_cookie_salt)

      encryptor = ActiveSupport::MessageEncryptor.new(secret, sign_secret, serializer: ActiveSupport::MessageEncryptor::NullSerializer)

      # Will return a string representation of the session hash (because of the NullSerializer)
      encryptor.decrypt_and_verify(cookie)
    rescue ActiveSupport::MessageVerifier::InvalidSignature
      nil
    end

  end

end