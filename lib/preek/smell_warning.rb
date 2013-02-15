module Reek
  class SmellWarning
    def klass
      context[/^([\w:]*)(#\w*)?/, 1]
    end

    def smell_method
      context[/^([\w:]*)(#\w*)?/, 2]
    end
  end
end