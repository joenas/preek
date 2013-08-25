require 'thor/shell/color'
module Preek
  # Here we report the smells in a nice fashion
  class SmellReporter < Thor::Shell::Color
    def initialize(smelly_files, not_files)
      @smelly_files = smelly_files
      @not_files = not_files
      @padding = 0
    end

    def print_smells
      if success?
        say_status 'success!', 'No smells detected.'
      else
        print_each_smell
      end
      print_not_files
    end
    alias :print_result :print_smells

  private
    def success?
      @smelly_files.empty?
    end

    def print_not_files
      return if @not_files.empty?
      say_status :error, "No such file(s) - #{@not_files.join(', ')}.", :red
    end

    def print_each_smell
      print_line
      @smelly_files.each do |smelly|
        say_status 'file', format_path(smelly.filename), :blue
        print_klasses smelly.klasses
      end
    end

    def print_klasses klasses
      klasses.each do |index, klass|
        say_status "\n\tclass", klass.name
        say_status 'smells', '', :red
        print_klass_smells klass.smells
      end
      print_line
    end

    def print_klass_smells smells
      smells.each {|smell|
       say_status nil, smell
      }
    end

    def print_line
      say "\n\t#{'-'*60}\n\n"
    end

    def padding; 0; end

    def format_path file
      File.expand_path(file)
    end
  end
end