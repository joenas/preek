require 'reek'

require 'preek/ext/smell_warning'

require 'preek/smell_file'
require 'preek/smell_klass'

module Preek
  # This is a 'Collector'
  class SmellCollector
    def initialize(files, excludes)
      @files = files
      @excludes = excludes
    end

    def smelly_files
      @smelly_files ||= examine_sources
    end

  private
    def examine_sources
      sources.map do |source|
        smells = Reek::Examiner.new(source).smells
        SmellFile.new(smells, @excludes) unless smells.empty?
      end.compact
    end

    def sources
      Reek::Source::SourceLocator.new(@files).all_sources
    end
  end
end