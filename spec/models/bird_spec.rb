require 'spec_helper'

describe Bird, :type => :model do
  before :each do
  	Bird.destroy_all
  end

  it "should test presence of name,family,continents" do
  	b = Bird.new
  	b.valid?.should eq(false)
  	b.errors[:name].should eq(["can't be blank"])
  end

	it "should return valid with all valid attributes" do
  	b = Bird.new
  	b.name = "bird1"
  	b.family = "family1"
  	b.continents = ["c1"]
  	b.valid?.should eq(true)
  	b.errors.should be_empty
  end

  it "should return invalid with empty continents attributes" do
    b = Bird.new
    b.name = "bird1"
    b.family = "family1"
    b.continents = []
    b.valid?.should eq(false)
    b.errors[:continents].should eq(["can't be blank"])
  end

  it "should return invalid with continents with invalid datatype" do
    b = Bird.new
    b.name = "bird1"
    b.family = "family1"
    b.continents = [1,2]
    b.valid?.should eq(false)
    b.errors[:continents].should eq(["Please pass only string array of continents"])
  end

  it "should save bird" do
  	b = Bird.new
  	b.name = "bird1"
  	b.family = "family1"
  	b.continents = ["c1"]
  	b.save
    Bird.find(b.id).name.should eq("bird1")
	end

  it "should delete bird" do
  	b = Bird.new
  	b.name = "bird1"
  	b.family = "family1"
  	b.continents = ["c1"]
  	b.save
  	b.destroy
  	Bird.find(b.id).should eq(nil)
  end
end
