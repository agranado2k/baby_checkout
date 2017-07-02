module Calculators
  class Percentage < Calculator
    def execute
      (value - (value*discount/100.00)).round(2)
    end
  end
end