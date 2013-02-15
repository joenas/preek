module Preek
  require 'preek/klass_collector'
  require 'preek/parser'
  # A smelly file
  class SmellFile
    def initialize(smells)
      @smells = smells
      @klass_collector = KlassCollector.new
    end

    # def smelly?
    #   not @smells.empty?
    # end

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
        parsed_smell = Parser.new smell
        @klass_collector.find(parsed_smell.klass).add_smell parsed_smell.smell
      end
    end

    def get_file

    end
  end
end