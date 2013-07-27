module Preek
  # A smelly file
  class SmellFile
    def initialize(smells, excludes)
      @smells = smells
      @excludes = excludes
      @klass_collector = KlassCollector.new
      add_smells_to_klass
    end

    def klasses
      @klass_collector.klasses
    end

    def file
      @smells.first.source
    end

  private
    def add_smells_to_klass
      @smells.each do |smell|
        next if @excludes.include? smell.smell_class
        @klass_collector.find(smell.klass).add smell
      end
    end
  end
end