module Calculators
  class Absolute < Calculator
    def execute
      (value - promotional_rule[:discount]).round(2)
    end
  end
end