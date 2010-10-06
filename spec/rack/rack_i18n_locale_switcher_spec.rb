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
  
  it "should use the HTTP_ACCEPT_LANGUAGE if possible : en" do
    get '/locale', {}, 'HTTP_ACCEPT_LANGUAGE' => "en-us,en;q=0.5"
    last_response.body.should =~ /I18n.locale: 'en'/
  end
  
  it "should use :default_locale if the HTTP_ACCEPT_LANGUAGE is not possible : pt" do
    get '/locale', {}, 'HTTP_ACCEPT_LANGUAGE' => "pt-pt,es;q=0.5"
    last_response.body.should =~ /I18n.locale: 'fr'/
  end
  
  it "should store the locale in the session : de" do
    get '/locale', :locale => :de
    last_response.body.should =~ /I18n.locale: 'de'/
    
    get '/home'
    last_response.should be_ok
    last_response.body.should == 'Home'
    
    get '/imprint'
    last_response.should be_ok
    last_response.body.should == 'Imprint'
    
    get '/locale'
    last_response.body.should =~ /I18n.locale: 'de'/
  end
  
  
  describe "locale as part of the url" do
    it "should set locale with format http://host.domain.tld/locale/path/to/site?param=set" do
      get '/de/locale/'
      last_response.should be_ok
      last_response.body.should =~ /I18n.locale: 'de'/
    end
    it "should reject the locale from the path" do
      get '/en/home/'
      last_response.should be_ok
      last_response.body.should == 'Home'
    end
    it "locale in path should have priority before locale in params" do
      get '/en/locale/', :locale => :de
      last_response.should be_ok
      last_response.body.should =~ /I18n.locale: 'en'/
    end
    it "wrong locale in path should cause fallback to params locale" do
      get '/pt/locale/', :locale => :de
      last_response.should be_ok
      last_response.body.should =~ /I18n.locale: 'de'/
    end
    it "wrong locale in path and params should cause fallback to default locale" do
      get '/pt/locale/', :locale => :us
      last_response.should be_ok
      last_response.body.should =~ /I18n.locale: 'fr'/
    end
  end
  
end
