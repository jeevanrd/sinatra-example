require 'mongoid'

class Bird

  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :family, type: String
  field :continents, type: Array
	field :visible, type: Boolean
  field :added, type: String

	validates_presence_of :name, :family, :continents

end