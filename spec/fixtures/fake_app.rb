require 'rubygems'
require 'sinatra'


module Rack
  module Test

    class FakeApp < Sinatra::Base
      
      get '/test' do
        "FakeApp responds"
      end
    end

  end
end
