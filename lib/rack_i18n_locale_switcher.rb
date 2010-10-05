require 'i18n'


module Rack
  class I18nLocaleSwitcher
    
    attr_accessor :available_locales, :default_locale
    
    def initialize(app, *args)
      @app = app
      opts = extract_options(args)
      @available_locales = opts[:available_locales] || [:en]
      @default_locale    = opts[:default_locale] || :en
    end
    
    def call(env)
      request = Rack::Request.new env
      session = request.session
      
      locale = extract_locale_from_path_or_params(request)
      session["locale"] = locale if is_present?(locale)
      
      unless is_present?(session["locale"])
        http_accept_language = first_http_accept_language(env)
        session["locale"] = (available_locales.include?(http_accept_language) ? http_accept_language : default_locale) 
      end
      
      I18n.locale = session["locale"]
      
      @app.call(env)
    end
    
    
    
    private
    
    
    
    def extract_locale_from_params(request)
      symbolize_locale request.params.delete("locale")
    end
    
    def extract_locale_from_path(request)
      path_array = request.path_info.split("/")
      if path_array[1] =~ /^\w{2}$/
        locale = symbolize_locale path_array.delete_at(1)
        request.path_info = path_array.join("/")
      else
        locale = nil
      end
      locale
    end
    
    def extract_locale_from_path_or_params(request)
      locale = extract_locale_from_path(request) || extract_locale_from_params(request)
      available_locales.include?(locale) ? locale : nil
    end
    
    def extract_options(args)
      if args.is_a?(Array)
        args.last.is_a?(Hash) ? args.pop : {}
      else
        {}
      end
    end
    
    def first_http_accept_language(env)
      if lang = env["HTTP_ACCEPT_LANGUAGE"]
        lang = lang.split(",").map { |l|
          l += ';q=1.0' unless l =~ /;q=\d+\.\d+$/
          l.split(';q=')
        }.first
        symbolize_locale(lang.first.split("-").first)
      end
    end
    
    def is_present?(value)
      !(value.nil? || value.to_s.empty?)
    end
    
    def symbolize_locale(locale)
      is_present?(locale) ?  locale.to_s.to_sym : locale
    end
  
  end

end