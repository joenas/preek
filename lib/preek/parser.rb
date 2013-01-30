module Preek

  # Parse ReekSmellWarning to another format
  class Parser
    def initialize(smell)
      @smell = smell
      @context_reg = /^([\w:]*)(#\w*)?/
    end

    def identifier
      @smell.source.to_sym.object_id
    end

    def klass
      file_klass
    end

    def file
      @smell.source
    end

    def smell
      {
        method: smell_method,
        smell: @smell.subclass,
        desc: @smell.message,
        lines: @smell.lines*","
      }
    end

  private
    def file_klass
      @smell.context[@context_reg, 1]
    end

    def smell_method
      @smell.context[@context_reg, 2]
    end

    def smell_klass
      @smell.smell['subclass']
    end

    def smell_description
      @smell.message
    end

    def smell_line
      @smell.lines
    end
  end
end