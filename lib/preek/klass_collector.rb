module Preek
  require 'preek/smell_klass'
  # This keeps track of classes in a smelly file
  class KlassCollector
    def initialize
      @klasses = {}
    end

    def find(klassname)
      @klasses[klassname.to_sym] ||= SmellKlass.new
    end

    def get_klasses
      @klasses
    end
  end
end