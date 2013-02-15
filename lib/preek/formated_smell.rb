module Preek
  # This is a formated smell! yey
  class FormatedSmell
  	def initialize data
      @data = data
  	end

    def print_data
      "#{@data[:method]} #{@data[:desc]} (#{@data[:smell]}) at lines #{@data[:lines]}"
    end
  end
end