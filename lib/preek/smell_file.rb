module Preek
  require 'preek/klass_collector'
  # A smelly file
  class SmellFile
    def initialize(smells)
      @smells = smells
      @klass_collector = KlassCollector.new
    end

    def klasses
      add_smells_to_klass
      @klass_collector.get_klasses
    end

    def file
      @smells.first.source
    end

  private
    def add_smells_to_klass
      @smells.each do |smell|
        @klass_collector.find(smell.klass).add_smell smell
      end
    end
  end
end