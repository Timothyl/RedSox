require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/reloader'
require 'nokogiri'
require 'open-uri'
require 'httparty'
require 'json'

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
  a = Party.schedule
  t = Time.now.strftime("%-m/%d/%Y")
  a = a['schedule_team_sponsors']['schedule_team_complete']['queryResults']['row']
  i = a.index{|r| r['team_game_time'].include?(t)}
  if i == nil
    answer = "NO"
  elsif
    venue = a[i]['venue_name']
    if venue == "Fenway Park"
      answer = "YES"
    else
      answer = "NO"
    end
  end

  # binding.pry
  erb :index, locals: {answer: answer}
end

class Party
  include HTTParty
  base_uri 'http://boston.redsox.mlb.com/lookup/json/named.schedule_team_sponsors.bam?start_date=%272015/09/01%27&end_date=%272015/09/30%27&team_id=111&season=2015'

  def self.schedule
    get("")
  end

end
