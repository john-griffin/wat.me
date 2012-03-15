require "rubygems"
require "bundler/setup"
Bundler.require(:default)
require "active_support/cache"

class Watme < Sinatra::Base
  def wats
    connection = Faraday.new(:url => 'http://knowyourmeme.com/memes/wat/photos?sort=score') do |conn|
      conn.response :caching do
        ActiveSupport::Cache::FileStore.new 'tmp/cache', :namespace => 'faraday', :expires_in => 3600
      end
      conn.adapter Faraday.default_adapter
    end
    response = connection.get
    doc = Nokogiri::HTML(response.body)
    doc.css("a.photo:not(.left) img").map{|img| {"wat" => img["src"].gsub("masonry", "newsfeed")}}
  end

  before do
    content_type :json
  end

  get '/' do
    wats.to_json
  end

  get '/random' do
    wats.sample.to_json
  end
end