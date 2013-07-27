module Preek
  require 'reek'
  require 'thor'

  require 'preek/version'
  require 'preek/smell_collector'
  require 'preek/smell_reporter'
  require 'preek/smell_warning'
  require 'preek/smell_file'
  require 'preek/klass_collector'

  # whoop whoop
  class Preek < Thor
    include Thor::Actions

    desc 'version', 'Shows version'
    def version(*)
      say VERSION
    end

    desc 'smell FILE(S)|DIR', 'Pretty format Reek output'
    method_option :irresponsible,
                  type: :boolean,
                  aliases: '-i',
                  desc: 'include IrresponsibleModule smell in output.'
    def smell(*args)
      args ||= @args
      @includes = options.keys.map {|key| _aliases[key.to_sym] }
      @files, @not_files = args.partition { |file| File.exists? file }
      report_smells
      report_not_files
    end

  private
    def report_smells
      return if @files.empty?
      sources = Reek::Source::SourceLocator.new(@files).all_sources
      smelly_files = SmellCollector.new(sources, excludes).smelly_files
      SmellReporter.new(smelly_files).print_smells
    end

    def report_not_files
      return if @not_files.empty?
      say_status :error, "No such file(s) - #{@not_files.join(', ')}.", :red
    end

    def _aliases
      {
        irresponsible: 'IrresponsibleModule'
      }
    end

    def excludes
      (exclude_list - @includes)
    end

    def exclude_list
      %w(IrresponsibleModule)
    end
  end
end
