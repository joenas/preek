module Preek

  require 'thor'
  #require 'psych'
  require 'reek'
  require 'preek/parser'
  require "preek/version"
  # whoop whoop
  class Preek < Thor
    include Thor::Actions

    desc 'version (-v)', 'Shows version'
    def version(*)
      say VERSION
    end

    desc 'FILE', 'Pretty format Reek output'
    def parse(args)
      @smells = {}
      @errors = {}
      @output = Reek::Examiner.new(args).smells
      if @output.empty?
        say_status 'success!', 'No smells detected.'
      else
        show_me_the_smells
      end
    end

  private
    def show_me_the_smells
      parse_smells
      print_smells
      print_line
    end

    def parse_smells
      # Psych.load(@output).each {|smell|
      #   setup_smell Parser.new(smell)
      # }
      @output.each {|smell|
        setup_smell Parser.new(smell)
      }
    end

    def setup_smell(parsed_smell)
      ident = parsed_smell.identifier
      unless @smells[ident]
        @smells[ident] = {file: parsed_smell.file, klass: parsed_smell.klass }
        @errors[ident] = []
      end
      @errors[ident] << parsed_smell.smell
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
