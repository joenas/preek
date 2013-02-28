module Preek
  require 'reek'
  require 'thor'
  require 'preek/version'
  require 'preek/smell_collector'
  require 'preek/smell_reporter'
  require 'preek/smell_warning'
  # whoop whoop
  class Preek < Thor
    include Thor::Actions

    desc 'version', 'Shows version'
    def version(*)
      say VERSION
    end

    desc 'FILE', 'Pretty format Reek output'
    def parse(args)
      files, @not_files = args.partition { |file| File.exists? file }
      report_smells_for files unless files.empty?
      report_not_files
    end

  private
    def report_smells_for files
      sources = Reek::Source::SourceLocator.new(files).all_sources
      smelly_files = SmellCollector.new(sources).smelly_files
      @reporter = SmellReporter.new(smelly_files)
      @reporter.print_smells
    end

    def report_not_files
      say_status :error, "No such file(s) - #{@not_files*", "}.", :red unless @not_files.empty?
    end
  end
end
