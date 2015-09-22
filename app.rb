require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/reloader'
require 'nokogiri'
require 'open-uri'

configure :development, :test do
  require 'pry'
end

configure do
  set :views, 'app/views'
end

Dir[File.join(File.dirname(__FILE__), 'app', '**', '*.rb')].each do |file|
  require file
  also_reload file
end

get '/' do
  doc = Nokogiri::HTML(open('http://boston.redsox.mlb.com/schedule/?c_id=bos#y=2015&m=9&calendar=DEFAULT'))
  a = doc.css('div')
  binding.pry
  erb :index
end
