module Preek
  # A smelly file
  class SmellFile
    attr_reader :klasses

    def initialize(smells, excludes)
      @smells = smells
      @excludes = excludes
      @klasses = {}
      add_smells_to_klasses
    end

    def file
      @smells.first.source
    end

    alias :filename :file

  private
    def add_smells_to_klasses
      @smells.each do |smell|
        next if @excludes.include? smell.smell_class
        find(smell.klass).add smell
      end
    end

    def find(klassname)
      @klasses[klassname.to_sym] ||= SmellKlass.new
    end
  end
end