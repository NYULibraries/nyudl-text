# Nyudl::Text

This gem encapsulates functionality for processing Text digital objects 
generated or managed by NYU's Digital Library Technology Services group.

## Installation

Add this line to your application's Gemfile:

    gem 'nyudl-text'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install nyudl-text

## Usage

Example using Thor to create a CLI class:

```ruby

  class Text < Thor
    class_option :verbose, :type => :boolean
    class_option :noop,    :type => :boolean

    option :dir,        :required => true,  :aliases => :d
    option :prefix,     :required => true,  :aliases => :p
    option :new_prefix, :required => false, :aliases => :n
    option :force,      :required => false, :aliases => :f, :type => :boolean, :default => false

    option :fr_digits_max, :required => false, :type => :numeric, :default => 2 # max allowable digits in fr fragments
    option :fr_digits_out, :required => false, :type => :numeric, :default => 2 # # of digits in fr output fragments
    option :bk_digits_max, :required => false, :type => :numeric, :default => 2 # max allowable digits in bk fragments
    option :bk_digits_out, :required => false, :type => :numeric, :default => 2 # # of digits in bk output fragments
    option :in_digits_max, :required => false, :type => :numeric, :default => 2 # max allowable digits in insert fragments
    option :in_digits_out, :required => false, :type => :numeric, :default => 2 # # of digits in insert output fragments

    desc "fix_names", "bulk filename correction from known patterns to canonical pattern"
    def fix_names

      # extract parameters
      dir    = options[:dir]
      prefix = options[:prefix]
      errors = []

      text = Nyudl::Text::Base.new(dir, prefix, options)

      text.analyze
      if text.valid?
        puts "Text is valid. No changes required. Thank you for using #$0"
        return true
      end

      unless text.recognized?
        puts "Unrecognized files detected: #{text.errors}"
        return false
      end

      puts "-------------------------------------------------------------------------------"
      puts "RENAME PLAN"
      puts "-------------------------------------------------------------------------------"

      text.rename_plan.each do |h|
        printf("%30s   ->   %30s\n", File.basename(h[:old_name]), File.basename(h[:new_name]))
      end

      puts "-------------------------------------------------------------------------------"
      $stdout.flush
      $stderr.flush

      # provide prompt unless force flag is set
      unless options[:force]
        puts "Do you want to continue with rename operation?"
        puts "(anything by Y aborts operation):"
        $stdout.flush
        $stderr.flush
        answer = $stdin.gets.chomp

        unless (answer == 'y' || answer == 'Y')
          puts "OPERATION ABORTED"
          return true
        end
      end

      text.rename!

      puts "\nRENAME OPERATION COMPLETE"
      puts "thank you for using #$0 "
      puts "goodbye..."
      puts "-------------------------------------------------------------------------------"
      $stdout.flush
      $stderr.flush
      return true
    end

    option :dir,        :required => true,  :aliases => :d
    option :prefix,     :required => true,  :aliases => :p

    desc "check", "check filenames to see if they comply with known patterns"
    def check
      # extract parameters
      dir    = options[:dir]
      prefix = options[:prefix]
      errors = []

      text = Nyudl::Text::Base.new(dir, prefix, options)

      text.analyze
      if text.valid?
        puts "#{dir} : All text filenames are recognized and conformant"
        return true
      end

      if text.recognized?
        puts "#{dir} All filenames recognized, but some filenames are not conformant. Rename is possible."
        return true
      else
        puts "#{dir} : ERROR: UNRECOGNIZED FILES DETECTED:"
        text.errors[:unrecognized].each { |e| puts "#{dir} : ERROR: #{e}" }
        return false
      end
    end
  end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
