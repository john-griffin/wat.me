require "rubygems"
require "bundler/setup"
Bundler.require(:default)
require "active_support/cache"

def wats
  connection = Faraday.new(:url => 'http://knowyourmeme.com/memes/wat/photos?sort=score') do |builder|
    builder.use FaradayStack::ResponseHTML
    builder.use FaradayStack::Caching do
      ActiveSupport::Cache::FileStore.new 'tmp/cache', :namespace => 'faraday', :expires_in => 3600
    end
    builder.adapter Faraday.default_adapter
  end
  response = connection.get
  response.body.css("a.photo:not(.left) img").map{|img| {"wat" => img["src"].gsub("masonry", "newsfeed")}}
end

get '/' do
  content_type :json
  wats.to_json
end

get '/random' do
  content_type :json
  wats.sample.to_json
end