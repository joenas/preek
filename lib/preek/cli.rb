require 'preek'
module Preek
  class Cli
    def initialize(args)
      @args = args
    end

    def execute
      Preek.start []
    end
  end
end

      
# unless ARGV.empty?
#   preek = Preek::Preek.new
#   if preek.respond_to? ARGV[0]
#     preek.send ARGV.shift.to_sym, ARGV
#   else
#     preek.parse ARGV
#   end
# else
#   Preek::Preek.start
# end
