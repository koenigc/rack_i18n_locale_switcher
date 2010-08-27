require 'i18n'


module Rack
  class I18nLocaleSwitcher
    
    def initialize(app)
      @app = app
      @default_locale = :en
    end
    
    def call(env)
      request = Rack::Request.new(env)
      params = request.params
      session = request.session
      
      session[:locale] = params['locale'] if params.has_key?('locale')
      I18n.locale = session[:locale] || @default_locale
      
      @app.call(env)
    end
    
  end
end