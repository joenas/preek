module Preek
  class Examiner
    def initialize(files,  excludes, reporter = StandardReport)
      @files = files
      @excludes = excludes
      @reporter = reporter
    end

    def perform
      sources.each do |source|
        examiner = Reek::Examiner.new(source)
        filter_excludes_from(examiner)
        @reporter.new(examiner).report
      end
      puts non_existing_files if non_existing_files?
      #@reporter.report_non_exist(non_existing_files) if non_existing_files?
    end

  private
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
      Reek::Source::SourceLocator.new(existing_files).all_sources
    end
  end

  class StandardReport < Thor::Shell::Color
    def initialize(examiner)
      @examiner = examiner
      @padding = 0
    end

    def report
      unless @examiner.smelly?
        report_success_file
      else
        report_smells
      end
    end

    def self.report_non_exist(files)
      say_status :error, "No such file(s) - #{files.join(', ')}.", :red
    end

    def report_success
      say_status 'success!', 'No smells detected.'
    end

    private

    def report_smells
      print_line
      say_status 'file', @examiner.description, :blue
      file = SmellFile.new(@examiner)
      file.klasses.each do |name, klass|
        say_status "\n\tclass", klass.name
        say_status 'smells', '', :red
        print_klass_smells klass.smells
      end
    end

    def print_klass_smells(smells)
      smells.each {|smell| say_status nil, smell }
    end

    def report_success_file
      print_line
      say_status 'file', @examiner.description, :blue
      report_success
    end

    def print_line
      say "\n\t#{'-'*60}\n\n"
    end
  end

  class QuietReport < StandardReport
    def report
      report_smells if @examiner.smelly?
    end
  end
end