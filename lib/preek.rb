module Preek

  require 'thor'
  require 'reek'
  require 'preek/parser'
  require 'preek/version'
  # whoop whoop
  class Preek < Thor
    include Thor::Actions

    desc 'version (-v)', 'Shows version'
    def version(*)
      say VERSION
    end

    desc 'FILE', 'Pretty format Reek output'
    def parse(args)
      @files, not_files = args.partition { |file| File.exists? file }
      run_reek_examiner unless @files.empty?
      say_status :error, "No such file(s) - #{not_files*", "}.", :red unless not_files.empty?
    end

  private
    def run_reek_examiner
      @output = Reek::Examiner.new(@files).smells
      if @output.empty?
        say_status 'success!', 'No smells detected.'
      else
        show_me_the_smells
      end
    end

    def show_me_the_smells
      @smells = {}
      @errors = Hash.new { |hash, key| hash[key] = [] }

      parse_smells
      print_smells
      print_line
    end

    def parse_smells
      @output.each do |smell|
        parsed_smell = Parser.new smell
        ident = parsed_smell.identifier
        @smells[ident] ||= parsed_smell.info
        @errors[ident] << parsed_smell.smell
      end
    end

    def print_smells
      @smells.each do |index, object|
        pretty_print index, object
      end
    end

    def pretty_print(index, object)
      print_line
      say_status 'file', object[:file], :blue
      say_status 'class', object[:klass]
      say_status 'smells', '', :red
      @errors[index].each {|error|
       say_status nil, "#{set_color("#{error[:method]}", :red, :bold)} #{error[:desc]} (#{error[:smell]}) at lines #{error[:lines]}"
      }
    end

    def print_line
      say "\n\t#{'-'*60}\n\n"
    end
  end
end
