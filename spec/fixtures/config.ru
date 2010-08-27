# config.ru
require 'fake_app'

app = Rack::Test::FakeApp.new
run app

