module Preek
  # This is a 'Collector'
  class SmellCollector
    def initialize(sources, excludes)
      @sources = sources
      @excludes = excludes
      @files = examine_sources
    end

    def smelly_files
      @files.compact
    end

  private
    def examine_sources
      @sources.map do |source|
        smells = Reek::Examiner.new(source).smells
        SmellFile.new(smells, @excludes) unless smells.empty?
      end
    end
  end
end