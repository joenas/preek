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

    def info
      { file: @smell.source, klass: klass }
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
    def smell_method
      @smell.context[@context_reg, 2]
    end

    def klass
      @smell.context[@context_reg, 1]
    end
  end
end