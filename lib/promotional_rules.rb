require_relative "./calculator"
require_relative "./calculators/percentage"
require_relative "./calculators/absolute"

class PromotionalRules
  attr_accessor :promotional_rules, :calculator, :item_rules, :basket_rules

  def initialize(calculator = Calculator)
    @calculator = calculator
    @item_rules = []
    @basket_rules = []
  end

  def update_item_value_by_rules(item, quantity)
    item_rules.select{|r| applicable?(r, quantity)}.each do |pr|
      item[:value] = calculator.for(item[:value], pr[:discount], pr[:type]).execute
    end
    item
  end

  def update_basket_value_by_rules(total)
    basket_rules.select{|r| applicable?(r, total)}
      .reduce(total){|final_total, pr| calculator.for(total, pr[:discount], pr[:type]).execute }
  end

  def applicable?(pr, value)
    if pr[:rule] == "item"
      value >= pr[:quantity_over]
    else
      value >= pr[:value_over]
    end
  end

  def include_rule(rule)
    if rule[:rule] == "item"
      item_rules.push(rule)
    else
      basket_rules.push(rule)
    end
  end
end