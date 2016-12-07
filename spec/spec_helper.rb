begin
  require 'simplecov'
  SimpleCov.start
rescue LoadError
  puts 'Coverage disabled, enable by installing simplecov'
end

require 'rspec/its'
require 'fakefs/spec_helpers'
require 'fileutils'

%w(
   base
   sequence_checker
   state_machine
   front_matter_number
   back_matter_number
   filename
   insert_number
   page_number
   errors
   slot
).each { |f| require_relative(File.join('..','lib','nyudl','text', f)) }

RSpec.configure do |config|
  config.include FakeFS::SpecHelpers, fakefs: true
end
