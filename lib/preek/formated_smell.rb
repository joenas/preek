module Preek
  # This is a formated smell! yey
  class FormatedSmell
  	def initialize data
      @data = data
  	end

    def print_data
      "#{@data.smell_method} #{@data.message} (#{@data.subclass}) at lines #{@data.lines*','}"
    end
  end
end