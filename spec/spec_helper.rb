require 'rubygems'
require 'spec'
require 'rack'
require 'rack/builder'
require 'rack/test'


ENV['RACK_ENV'] = 'test'


Spec::Runner.configure do |conf|
  conf.include Rack::Test::Methods
  
  require File.dirname(__FILE__) + "/../lib/rack_i18n_locale_switcher"
  require File.dirname(__FILE__) + "/fixtures/fake_app"
  
  def app
    Rack::Builder.app do
      use Rack::I18nLocaleSwitcher
      run Rack::Test::FakeApp.new
    end
  end

end