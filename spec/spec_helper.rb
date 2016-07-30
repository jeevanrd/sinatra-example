require 'rspec/core'
require "mongoid"

ENV["RACK_ENV"]= "test"
ENV["MONGOID_ENV"]= "test"

Mongoid.load!("config/mongoid.yml")

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
# Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }
Dir["./models/**/*.rb"].each { |f| require f }
