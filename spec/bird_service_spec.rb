require 'spec_helper'
require_relative './../bird_service'
require 'rack/test'

describe "BirdService" do
  include Rack::Test::Methods

  before :each do
  	Bird.destroy_all
  end

  def app
    BirdService.new
  end

  def build_temp_bird(visible = true)
		bird = Bird.new
  	bird.name = "bird1"
  	bird.family = "family1"
  	bird.continents = ["c1"]
  	bird.visible = visible
  	bird
  end

  def create_temp_bird(visible = true)
		bird = build_temp_bird(visible)
  	bird.save
  	bird
  end

  it "should get invalid mime type error" do
    get '/birds'
    expect(last_response.status).to eq 415

		post '/birds'
    expect(last_response.status).to eq 415

    get '/birds/1'
    expect(last_response.status).to eq 415

    delete '/birds/1'
    expect(last_response.status).to eq 415
  end

  it "should get empty birds" do
  	header 'Content-Type', 'application/json'
    get '/birds'
    expect(last_response.status).to eq 200
  end

  it "should get one bird" do
  	b = create_temp_bird(true)
  	header 'Content-Type', 'application/json'
    get '/birds'
    birds = JSON.parse(last_response.body)
    expect(birds.length).to eq(1)
    expect(birds[0]["name"]).to eq("bird1")
    expect(birds[0]["family"]).to eq("family1")
    expect(birds[0]["continents"]).to eq(["c1"])
    expect(birds[0]["visible"]).to eq(true)
  end

	it "should not get non visibility birds" do
		b = create_temp_bird(false)
		header 'Content-Type', 'application/json'
    get '/birds'
    expect(last_response.status).to eq 200
		birds = JSON.parse(last_response.body)
    expect(birds.length).to eq(0)
	end

	it "should create a bird" do
		b = build_temp_bird(true)
		header 'Content-Type', 'application/json'
    post '/birds', b.to_json
    bird = JSON.parse(last_response.body)
    expect(bird["name"]).to eq("bird1")
    expect(bird["family"]).to eq("family1")
    expect(bird["continents"]).to eq(["c1"])
  end

	it "should not create a bird without name" do
		header 'Content-Type', 'application/json'
    post '/birds', {}
    errors = JSON.parse(last_response.body)
    expect(errors["name"][0]).to eq("Name can't be blank")
  end

	it "should not create a bird without family" do
		header 'Content-Type', 'application/json'
    post '/birds', {}
    errors = JSON.parse(last_response.body)
    expect(errors["family"][0]).to eq("Family can't be blank")
  end

	it "should not create a bird without continents" do
		header 'Content-Type', 'application/json'
    post '/birds', {}
    errors = JSON.parse(last_response.body)
    expect(errors["continents"][0]).to eq("Continents can't be blank")
 end

  it "should get a bird" do
		b = create_temp_bird
		header 'Content-Type', 'application/json'
    get "/birds/#{b.id.to_s}"
    expect(last_response.status).to eq 200
    bird = JSON.parse(last_response.body)
    expect(bird["name"]).to eq("bird1")
    expect(bird["family"]).to eq("family1")
    expect(bird["continents"]).to eq(["c1"])
  end

  it "should get 404 for a bird that doesn't exist" do
  	header 'Content-Type', 'application/json'
    get '/birds/abere'
    expect(last_response.status).to eq 404
    expect(last_response.body).to include("{\"message\":\"Not found\"}")
  end

  it "should delete a bird" do
		b = create_temp_bird
		header 'Content-Type', 'application/json'
    delete "/birds/#{b.id.to_s}"
    expect(last_response.status).to eq 200
  end

	it "should get 404 for a bird while tryint to delete a bird that doesn't exist" do
		header 'Content-Type', 'application/json'
    delete '/birds/1'
    expect(last_response.status).to eq 404
    expect(last_response.body).to include("{\"message\":\"Not found\"}")
  end
end
