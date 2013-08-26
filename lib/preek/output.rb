require 'thor/shell/color'
module Preek
  class Output < Thor::Shell::Color
    def status(*args)
      say_status *args
    end

    def print_line
      say "\n\t#{'-'*60}\n\n"
    end

    def blue(*args)
      status *args, :blue
    end

    def green(*args)
      status *args, :green
    end

    def red(*args)
      status *args, :red
    end
  end

  class CompactOutput < Output
    def status(*args)
      title = args[0].to_s
      title += ": " if args[0].is_a?(Symbol)
      say title, args[2], false
      say args[1]
    end

    def print_line
      say "\n-\n\n"
    end
  end
end