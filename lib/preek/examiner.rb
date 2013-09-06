require 'reek/examiner'

module Preek
  class Examiner
    def initialize(files, excludes = [], reporter: VerboseReport, output: Output)
      @files = files
      @excludes = excludes
      @reporter = reporter
      @output = output.new
      @total_smells = 0
    end

    def perform
      examine_and_report
      report_totals if totals_to_report?
      @output.print_line
      report_non_existing if non_existing_files?
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
        @excludes.include? smell.smell_class
      end
    end

    def totals_to_report?
      return false if @reporter.verbose? || @sources.count == 0
      @total_smells == 0
    end

    def report_totals
      @output.print_line
      @output.green :success, %(No smells detected)
    end

    def report_non_existing
      @output.red :error, %{No such file(s) - #{non_existing_files.join(', ')}.\n}
      @output.print_line
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