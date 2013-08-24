require 'reek'

require 'preek/ext/smell_warning'

require 'preek/smell_file'
require 'preek/smell_klass'

module Preek
  # This is a 'Collector'
  class SmellCollector
    def initialize(files, excludes = [])
      @files = files
      @excludes = excludes
    end

    def smelly_files
      @smelly_files ||= files_from_sources
    end

  private
    def files_from_sources
      filtered_sources.map do |examiner|
        SmellFile.new(examiner) if examiner.smelly?
      end.compact
    end

    def filtered_sources
      sources.map do |source|
        examiner = Reek::Examiner.new(source)
        filter_excludes_from(examiner)
        examiner
      end
    end

    def filter_excludes_from(examiner)
      examiner.smells.delete_if do |smell|
        @excludes.include? smell.smell_class
      end
    end

    def sources
      Reek::Source::SourceLocator.new(@files).all_sources
    end
  end
end