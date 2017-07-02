module Calculators
  class Absolute < Calculator
    def execute
      (value - discount).round(2)
    end
  end
end