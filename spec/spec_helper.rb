begin
  require 'simplecov'
  SimpleCov.start
rescue LoadError
  puts 'Coverage disabled, enable by installing simplecov'
end

require 'rspec/its'
require 'fakefs/spec_helpers'
require 'fileutils'

require_relative '../lib/nyudl/text'

RSpec.configure do |config|
  config.include FakeFS::SpecHelpers, fakefs: true
end
