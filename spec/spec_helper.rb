%w(
   base
   sequence_checker
   state_machine
   front_matter_number
   back_matter_number
   filename
   insert_number
   page_number
   echo
).each { |f| require_relative(File.join('..','lib','nyudl','text', f)) }

=begin
RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
=end
