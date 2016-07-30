require 'sinatra/base'
require 'mongoid'
require_relative './models/bird'

class BirdService < Sinatra::Base

  configure do
    Mongoid.load!("config/mongoid.yml")
  end

  before do
    content_type :json
    halt 415, "invalid mime type" unless request.content_type == 'application/json'
  end

  get '/birds' do
    birds = Bird.all.where(:visible => true)
    birds.to_json
  end

  post '/birds' do
    request_payload = JSON.parse (request.body.read) rescue {}
  	bird = Bird.new(request_payload)
    halt 400, bird.errors.as_json(full_messages: true).to_json unless bird.valid?
  	bird.save
    bird.to_json
  end

  get '/birds/:id' do
    halt 404, {:message=>"Not found"}.to_json unless BSON::ObjectId.legal?(params[:id])
    bird = Bird.find(params[:id])
    halt 404, {:message=>"Not found"}.to_json if bird.nil?
    bird.to_json
  end

  delete '/birds/:id' do
    halt 404, {:message=>"Not found"}.to_json unless BSON::ObjectId.legal?(params[:id])
    bird = Bird.find(params[:id])
    halt 404, {:message=>"Not found"}.to_json if bird.nil?
    bird.destroy
  end
end