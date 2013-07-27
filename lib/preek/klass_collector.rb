module Preek
  require 'preek/smell_klass'
  # This keeps track of classes in a smelly file
  class KlassCollector
    attr_reader :klasses
    def initialize
      @klasses = {}
    end

    def find(klassname)
      @klasses[klassname.to_sym] ||= SmellKlass.new
    end
  end
end