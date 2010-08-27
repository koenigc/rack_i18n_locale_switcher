require 'i18n'


module Rack
  class I18nLocaleSwitcher
    
    attr_accessor :available_locales, :default_locale
    
    def initialize(app, *args)
      @app = app
      opts = args.extract_options!
      @available_locales = opts[:available_locales] || [:en]
      @default_locale    = opts[:default_locale] || :en
    end
    
    def call(env)
      request = Rack::Request.new env
      params  = request.params
      session = request.session
      
      locale = symbolize_locale params["locale"]
      session["locale"] = (available_locales.include?(locale) ? locale : default_locale) if locale.present?
      
      unless session["locale"].present? 
        http_accept_language = first_http_accept_language(env)
        session["locale"] = (available_locales.include?(http_accept_language) ? http_accept_language : default_locale) 
      end
      
      I18n.locale = session["locale"]
      
      @app.call(env)
    end
    
    
    private
    
    
    def symbolize_locale(locale)
      locale.present? ? locale.to_s.to_sym : locale
    end
    
    def first_http_accept_language(env)
      # http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.4
      if lang = env["HTTP_ACCEPT_LANGUAGE"]
        lang = lang.split(",").map { |l|
          l += ';q=1.0' unless l =~ /;q=\d+\.\d+$/
          l.split(';q=')
        }.first
        lang.first.split("-").first
      end
    end
    
  end
end