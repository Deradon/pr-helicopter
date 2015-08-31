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

WebMock.disable_net_connect!(allow: 'codeclimate.com')

CodeClimate::TestReporter.start

SimpleCov.start do
  formatter SimpleCov::Formatter::MultiFormatter[
    SimpleCov::Formatter::HTMLFormatter,
    CodeClimate::TestReporter::Formatter
  ]
end
