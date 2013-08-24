require 'thor/shell/color'
module Preek
  # Here we report the smells in a nice fashion
  class SmellReporter < Thor::Shell::Color
    def initialize smelly_files
      @smelly_files = smelly_files
      @padding = 0
    end

    def print_smells
      return say_status 'success!', 'No smells detected.' if success?
      print_line
      @smelly_files.each do |smelly|
        say_status 'file', format_path(smelly.filename), :blue
        print_klasses smelly.klasses
      end
    end
    alias :print_result :print_smells

  private

    def success?
      @smelly_files.empty?
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