require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe Rack::I18nLocaleSwitcher do

  it "check if FakeApp responds" do
    get '/test'
    last_response.should be_ok
    last_response.body.should == 'FakeApp responds'
  end
  
end
