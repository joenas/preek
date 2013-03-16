#This class a nil check
class NilCheck
  def initialize(number)
    @number = number
  end

  def nil_check
    @number.times do |number|
      next if number.nil?
    end
  end
end