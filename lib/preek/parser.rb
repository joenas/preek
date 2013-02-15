module Preek

  # Parse ReekSmellWarning to another format
  class Parser
    def initialize(smell)
      @smell = smell
      #puts @smell.methods(true)#.inspect
      #[:smell, :smell_class, :subclass, :message, :location, :context, :status ].each do |mee|
      [:klass, :smell_method ].each do |mee|
        puts "#{mee}:"
        puts @smell.send(mee)
        puts "\n"
      end
      exit
      @context_reg = /^([\w:]*)(#\w*)?/
    end

    def file
      @smell.source
    end

    def klass
      @smell.context[@context_reg, 1]
    end

    def smell
      {
        klass: klass,
        method: smell_method,
        smell: @smell.subclass,
        desc: @smell.message,
        lines: @smell.lines*","
      }
    end

    def smell_method
      @smell.context[@context_reg, 2]
    end
  end
end