module Preek
  require 'reek'
  require 'preek/smell_file'
  # This is a 'Collector'
  class SmellCollector
    def initialize sources
      @sources = sources
      @files = examine_sources
    end

    def smelly_files
      @files.reject(&:nil?)
    end

  private
    def examine_sources
      @sources.map do |source|
        smells = Reek::Examiner.new(source).smells
        SmellFile.new smells unless smells.empty?
      end
    end
  end
end