module Preek
  # A container for a smelly klass in a file!
  class SmellKlass
    def initialize
      @smells = []
    end

    def add(smell)
      @smells << smell
    end

    def name
      @smells.first.klass
    end

    def smells
      @smells.map(&:smell_string)
    end
  end
end