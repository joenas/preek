module Preek
  # A smelly file
  class SmellFile

    def initialize(examiner)
      @examiner = examiner
      @klasses = {}
      add_smells_to_klasses
    end

    def file
      @examiner.description
    end

    alias :filename :file

    def klasses
      return @klasses unless block_given?
      @klasses.each do |name, klass|
        yield klass
      end
    end

  private
    def add_smells_to_klasses
      @examiner.smells.each do |smell|
        find(smell.klass) << smell
      end
    end

    def find(klassname)
      @klasses[klassname.to_sym] ||= SmellKlass.new(klassname)
    end
  end
end