require 'reek/examiner'

module Preek
  class Examiner
    def initialize(files, excludes = [], options = {})
      @files = files
      @excludes = excludes
      @reporter = options[:reporter] || VerboseReport
      output_class = options[:output] || Output
      @output = output_class.new
      @total_smells = 0
    end

    def perform
      examine_and_report
      @output.separated do
        report_success if report_success?
        report_total_smells unless success?
        report_non_existing if non_existing_files?
      end
    end

  private
    def examine_and_report
      sources.each do |source|
        examiner = Reek::Examiner.new(source)
        filter_excludes_from(examiner)
        @reporter.new(examiner, @output).report
        @total_smells += examiner.smells_count
      end
    end

    def filter_excludes_from(examiner)
      examiner.smells.delete_if do |smell|
        @excludes.include? smell.class
      end
    end

    def success?
      @total_smells == 0
    end

    def report_success?
      !@reporter.verbose? && @sources.count > 0 && success?
    end

    def report_success
      @output.green :success, %(No smells detected)
    end

    def report_total_smells
      @output.red :total, @total_smells
    end

    def report_non_existing
      @output.red :error, %{No such file(s) - #{non_existing_files.join(', ')}.\n}
    end

    def existing_files
      @existing_files ||= @files.select {|file| File.exists? file}
    end

    def non_existing_files?
      !non_existing_files.empty?
    end

    def non_existing_files
      @files - existing_files
    end

    def sources
      @sources ||= Reek::Source::SourceLocator.new(existing_files).all_sources
    end
  end
end