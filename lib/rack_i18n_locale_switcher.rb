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
      session["locale"] = first_http_accept_language(env) unless is_present?(session["locale"])
      
      I18n.locale = session["locale"]
      
      @app.call cleanup_env(env)
    end
    
    
    
    private
    
    
    
    def cleanup_env env
      %w{REQUEST_URI REQUEST_PATH PATH_INFO}.each do |key|
        if is_present?(env[key]) && tmp = env[key].split("/")
          tmp.delete_at(1) if tmp[1] =~ %r{^[a-zA-Z]{2}$}
          env[key] = tmp.join("/")
        end
      end
      env
    end
    
    def extract_locale_from_params(request)
      locale = request.params.delete("locale")
      locale = nil unless locale =~ %r{^#{available_locales.join('|')}$}
      symbolize_locale locale
    end
    
    def extract_locale_from_path(request)
      path_array = request.path_info.split("/")
      path_array[1] =~ %r{^#{available_locales.join('|')}$} ? path_array[1] : nil
    end
    
    def extract_locale_from_path_or_params(request)
      locale = extract_locale_from_path(request) || extract_locale_from_params(request)
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
        locale = symbolize_locale(lang.first.split("-").first)
      else
        locale = nil
      end
      available_locales.include?(locale) ? locale : default_locale
    end
    
    def is_present?(value)
      !(value.nil? || value.to_s.empty?)
    end
    
    def symbolize_locale(locale)
      is_present?(locale) ?  locale.to_s.downcase.to_sym : locale
    end
  
  end

end