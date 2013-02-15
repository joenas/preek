module Preek
  require 'preek/formated_smell'
  # A container for a smelly klass in a file!
  class SmellKlass
    def initialize
      @smells = []
    end

    def add_smell smell
      @smells << smell
    end

    def name
      @smells.first[:klass]
    end

    def smells
      @smells.map do |smell|
        FormatedSmell.new(smell).print_data
      end
    end
  end
end