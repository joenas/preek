module Preek
  # A smelly file
  class SmellFile
    attr_reader :klasses

    def initialize(examiner)
      @examiner = examiner
      @klasses = {}
      add_smells_to_klasses
    end

    def file
      @examiner.description
    end

    alias :filename :file

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