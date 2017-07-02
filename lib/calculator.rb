class Calculator
  attr_accessor :promotional_rule, :value
  
  def initialize(value, pr)
    @value = value
    @promotional_rule = pr
  end

  def self.for(value, pr)
    if pr[:type] == "percentage"
      Calculators::Percentage.new(value, pr)
    else
      Calculators::Absolute.new(value, pr)
    end
  end
end

