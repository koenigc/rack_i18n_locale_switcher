require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe Rack::I18nLocaleSwitcher do
  
  # Settings for middleware in spec_helper.rb
  # Rack::I18nLocaleSwitcher, :available_locales => [:de, :en, :fr], :default_locale => :fr
  
  it "check if FakeApp responds" do
    get '/test'
    last_response.should be_ok
    last_response.body.should == 'FakeApp responds'
  end
  
  it "should respond to /locale" do
    get '/locale'
    last_response.should be_ok
    last_response.body.should =~ /I18n.locale: '(.*?)'/
  end
  
  it "default locale should be :fr" do
    get '/locale'
    last_response.body.should =~ /I18n.locale: 'fr'/
  end
  
  it "setting the defined :available_locales should be possible : de" do
    get '/locale', :locale => :de
    last_response.body.should =~ /I18n.locale: 'de'/
  end
  
  it "setting the defined :available_locales should be possible : fr" do
    get '/locale', :locale => :fr
    last_response.body.should =~ /I18n.locale: 'fr'/
  end
  
  it "setting the defined :available_locales should be possible : en" do
    get '/locale', :locale => :en
    last_response.body.should =~ /I18n.locale: 'en'/
  end
  
  it "setting any other locale should not be possible : pt, it should use :default_locale : fr" do
    get '/locale', :locale => :pt
    last_response.body.should_not =~ /I18n.locale: 'pt'/
    last_response.body.should =~ /I18n.locale: 'fr'/
  end
  
end
