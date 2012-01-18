require 'rubygems'
require 'sinatra'
require 'mechanize'
require 'json'

def agent
  @agent ||= Mechanize.new
end

get '/random' do
  doc = agent.get('http://knowyourmeme.com/memes/wat/photos').parser
  {"wat" => doc.css("a.photo img").map{|img| img["src"]}.sample}.to_json
end