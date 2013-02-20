module Reek
  # Is was easier this way
  class SmellWarning
    def klass
      @location[CONTEXT_KEY][/^([\w:]*)(#\w*)?/, 1]
    end

    def smell_method
      @location[CONTEXT_KEY][/^([\w:]*)(#\w*)?/, 2]
    end

    def smell_string
      "#{smell_method} #{@smell['message']} (#{@smell['subclass']}) at lines #{@location['lines']*','}"
    end
  end
end