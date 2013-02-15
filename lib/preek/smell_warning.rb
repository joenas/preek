module Reek
  # Is was easier this way
  class SmellWarning
    def klass
      @location[CONTEXT_KEY][/^([\w:]*)(#\w*)?/, 1]
    end

    def smell_method
      @location[CONTEXT_KEY][/^([\w:]*)(#\w*)?/, 2]
    end
  end
end