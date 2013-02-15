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
      # @files.select do |file|
      #   file.smelly?
      # end
      @files.reject(&:nil?)
    end

  private
    def examine_sources
      @sources.map do |source|
        smells = Reek::Examiner.new(source).smells
        #puts smells.inspect
        SmellFile.new smells unless smells.empty?
      end
    end
  end
end