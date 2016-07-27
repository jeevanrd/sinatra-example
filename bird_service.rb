require 'sinatra'
require 'mongoid'

configure do
  Mongoid.load!("mongoid.yml")
end


before do
  content_type :json
end

get '/birds' do
  content_type :json
  birds = Bird.all.where(:visible => true)
  return birds.to_json
end

post '/birds' do

  request_payload = JSON.parse (request.body.read) rescue {}
	bird = Bird.new(request_payload)
  halt 400, {:error => bird.errors.to_a.join(",")}.to_json unless bird.valid?
	bird.save
  return bird.to_json
end

get '/birds/:id' do
  bird = Bird.find(params[:id])
  halt 404, {:message=>"Not found"}.to_json if bird.nil?
  return bird.to_json
end

delete '/birds/:id' do
  bird = Bird.find(params[:id])
  halt 404, {:message=>"Not found"}.to_json if bird.nil?
  bird.destroy
end
