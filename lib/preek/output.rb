require 'thor/shell/color'
module Preek
  class Output < Thor::Shell::Color
    def status(*args)
      say_status *args
    end

    def print_line
      say "\n\t#{'-'*60}\n\n"
    end

    alias :separator :print_line

    def blue(*args)
      status *args, :blue
    end

    def green(*args)
      status *args, :green
    end

    def red(*args)
      status *args, :red
    end

    def separated(&block)
      print_line
      yield
      print_line
    end
  end

  class CompactOutput < Output
    def status(title, text, color = nil)
      title = title.to_s + ": " if title.is_a?(Symbol)
      say title, color, false
      say text
    end

    def print_line
      say "\n-\n\n"
    end
    alias :separator :print_line
  end
end