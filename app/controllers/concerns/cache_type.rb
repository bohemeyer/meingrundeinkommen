module CacheType
  as_trait do |cache_type|

    # This trait sets the `Cache-Control` header which will cause responses to
    # be cached (or not cached) by the application's load balancer.
    #
    # The following cache types are supported:
    #
    # :public
    # Responses may be cached by the load balancer or other proxies.
    #
    # :private
    # Prevents caching in the load balancer and other proxies.
    # The response is intended only for a single recipient
    #
    # It will also set `max-age: 0` and `must-revalidate` for public/private
    # caching, as this is the (useful) default of Rails and Rack.

    after_filter :set_fitting_cache_control

    private

    define_method :set_fitting_cache_control do
      set_cache_control!(cache_type) if may_be_cached?
    end

    helper_method def avoid_cache_busting!
      # Use this method to avoid a `no_cache=1` cookie that will be send on
      # private responses.
      # Note: That cookie is used to force the next request to be loaded from
      # the application servers which is a good default in most cases.
      @avoid_cache_busting = true
    end

    helper_method def disallow_caching!
      cookies[:no_cache] = '1' unless @avoid_cache_busting
      @disallow_caching = true
    end

    def form_authenticity_token(*args, &block)
      # Whenever an authenticity token is requested, this response is very likely
      # to contain user-specific data. It must not be cached.
      disallow_caching!
      super
    end

    define_method :may_be_cached? do
      cache_type == :public && !@disallow_caching && current_user.blank?
    end
    helper_method :may_be_cached?

    def set_cache_control!(cache_type)
      case cache_type
      when :private
        # This is not really reachable, as `may_be_cached?` requires :public
        response.headers['X-May-Cache'] = '0'
      when :public
        response.headers['X-May-Cache'] = '1'
      else
        raise ArgumentError, "Unknown cache type #{cache_type.inspect}"
      end
    end

  end
end
