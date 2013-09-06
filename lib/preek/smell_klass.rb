module Preek
  # A container for smells in a class
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