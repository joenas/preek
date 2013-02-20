module Preek
  # Here we report the smells in a nice fashion
  class SmellReporter < Thor::Shell::Color
    def initialize smelly_files
      @smelly_files = smelly_files
      @padding = 0
    end

    def print_smells
      return say_status 'success!', 'No smells detected.' if @smelly_files.empty?
      print_line
      @smelly_files.each do |smell|
        say_status 'file', format_path(smell.file), :blue
        print_klasses smell.klasses
      end
    end
  private
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
      File.expand_path(file)#.gsub(Dir.pwd, ".")
    end
  end
end