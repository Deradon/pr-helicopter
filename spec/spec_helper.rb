require 'simplecov'
require 'webmock/rspec'
require 'codeclimate-test-reporter'
require 'pry'

RSpec::Matchers.define :be_subclass_of do |expected|
  match { |actual| actual <= expected }
end

RSpec::Matchers.define :respond_to_public do |expected|
  match { |actual| actual.public_methods.include? expected }
end

CodeClimate::TestReporter.start
SimpleCov.start
