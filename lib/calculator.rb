class Calculator
  attr_accessor :discount, :value
  
  def initialize(value, discount)
    @value = value
    @discount = discount
  end

  def self.for(value, discount, type)
    if type == "percentage"
      Calculators::Percentage.new(value, discount)
    else
      Calculators::Absolute.new(value, discount)
    end
  end
end

