require 'rubygems'
require 'I18n'
require 'sinatra'


module Rack
  module Test

    class FakeApp < Sinatra::Base
      
      get '/test' do
        "FakeApp responds"
      end
      
      get '/locale' do
        "I18n.locale: '#{I18n.locale}'"
      end
      
      get '/home' do
        "Home"
      end
      
      get '/imprint' do
        "Imprint"
      end
      
    end
  
  end
end
