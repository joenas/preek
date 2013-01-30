require "preek/version"

module Preek
  require 'thor'
  require 'set'
  # whoop whoop
  class Preek < Thor
    include Thor::Actions

    desc 'file', 'Pretty format Reek output'
    def pretty(file)

      @output = `reek -q #{file}`
      @files = {}

      say "\n"
      parse_output
      @files.each { |index, object|
        print_pretty object
      }
    end

    desc 'version (-v)', 'Shows version'
    def version
      say VERSION
    end

  private

    def print_pretty(object)
      say_status 'file', object[:file], :blue
      say_status 'class', object[:klass]
      say_status 'errors', '', :red
      object[:errors].each {|error|
        say_status nil, "#{set_color(error[:method], :red, :bold)}: #{error[:desc]} (#{error[:smell]})"
      }
      say "\n------------------------------------------------------------\n"
    end

    def parse_output
      @output.each_line { |line|
        parse_spec line
        parse_head line
      }
    end

    def parse_spec(line)
      spec = line.match(/^  ([\w:]*)(#\w*)? (.*) \((.*)\)/)
      return unless spec
      klass, method, desc, smell = spec[1], spec[2], spec[3], spec[4]
      ident = klass[/(\w::)?(\w*)\z/,2].downcase.to_sym.object_id
      if @files[ident]
        @files[ident][:klass] = klass#.merge!({klass: klass})
        @files[ident][:errors] << {method: method, desc: desc, smell: smell}
      end
    end

    def parse_head(line)
      head = line.match(/(.*\/\w*).rb -- (\d)/)
      return unless head
      file, nr_errors = head[1], head[2]
      ident = file[/\/(\d*)?(\w*)$/,2].gsub("_",'').to_sym.object_id
      @files[ident] = {file: file, klass: '', errors: [] }
    end
  end
end
