require 'reek/examiner'

module Preek
  class Examiner
    def initialize(files, excludes = [], reporter: StandardReport, output: Output)
      @files = files
      @excludes = excludes
      @reporter = reporter
      @output = output.new
    end

    def perform
      @reporter = StandardReport if sources.count == 1
      sources.each do |source|
        examiner = ::Reek::Examiner.new(source)
        filter_excludes_from(examiner)
        @reporter.new(examiner, @output).report
      end
      @output.print_line
      report_non_existing_files if non_existing_files?
    end

  private
    def report_non_existing_files
      @output.red :error, %{No such file(s) - #{non_existing_files.join(', ')}.\n}
      @output.print_line
    end

    def filter_excludes_from(examiner)
      examiner.smells.delete_if do |smell|
        @excludes.include? smell.smell_class
      end
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