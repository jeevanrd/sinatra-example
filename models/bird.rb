require 'mongoid'

class Bird
  include Mongoid::Document
  field :name, type: String
  field :family, type: String
  field :continents, type: Array
	field :visible, type: Boolean, :default => false
  field :added, type: String, :default => DateTime.now.utc.to_date.strftime("%Y-%m-%d")

	validates_presence_of :name, :family, :continents
	validate :continent_validator, :on => :create

	def as_json(*args)
	   super.tap { |hash| hash["id"] = (hash.delete "_id").to_s }
	end

	private

  def continent_validator
  	return  unless self.errors.messages[:continents].nil?

  	unless self.continents.is_a? Array
  		self.errors.add(:continents, "Please pass only string array of continents")
  		return
  	end

  	self.continents.each do |continent|
  		unless continent.is_a? String
	  		self.errors.add(:continents, "Please pass only string array of continents")
	  		return
	  	end
	  end
  end
end


