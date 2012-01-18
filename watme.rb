require 'rubygems'
require 'sinatra'
require 'mechanize'
require 'json'

def wats
  agent = Mechanize.new
  doc = agent.get('http://knowyourmeme.com/memes/wat/photos?sort=score').parser
  doc.css("a.photo:not(.left) img").map{|img| {"wat" => img["src"].gsub("masonry", "newsfeed")}}
end

get '/' do
  content_type :json
  wats.to_json
end

get '/random' do
  content_type :json
  wats.sample.to_json
end