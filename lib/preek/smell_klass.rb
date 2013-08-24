module Preek
  # A container for a smelly klass in a file!
  class SmellKlass
    attr_reader :name

    def initialize(name)
      @name = name
      @smells = []
    end

    def add(smell)
      @smells << smell
    end

    alias :<< :add

    def smells
      @smells.map(&:smell_string)
    end
  end
end