module Calculators
  class Percentage < Calculator
    def execute
      (value - (value*promotional_rule[:discount]/100.00)).round(2)
    end
  end
end