module Reek
  # Is was easier this way
  class SmellWarning
    def klass
      context[/^([\w:]*)(#\w*)?/, 1]
    end

    def smell_method
      context[/^([\w:]*)(#\w*)?/, 2]
    end

    def smell_string
      "#{smell_method} #{message} (#{subclass}) at lines #{Array(lines)*','}"
    end
  end
end