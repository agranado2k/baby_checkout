require_relative "./calculator"
require_relative "./calculators/percentage"
require_relative "./calculators/absolute"
require_relative "./rule"
require_relative "./rules/item"
require_relative "./rules/basket"

class PromotionalRules
  attr_accessor :promotional_rules, :calculator, :item_rules, :basket_rules

  def initialize(calculator = Calculator)
    @calculator = calculator
    @item_rules = []
    @basket_rules = []
  end

  def update_item_value_by_rules(value, quantity, item_id)
    value_by_rule(item_rules.select{|r| r.applicable?(quantity, item_id)}, value, quantity)
  end

  def update_basket_value_by_rules(total)
    value_by_rule(basket_rules.select{|r| r.applicable?(total)}, total)
  end

  def value_by_rule(rules, value, quantity = nil)
    quantity = quantity.nil? ? value : quantity
    rules.each do |rule|
      value = calculator.for(value, rule.discount, rule.type).execute
    end
    value
  end

  def include_rule(rule)
    if rule[:rule] == "item"
      item_rules.push(Rule.for(rule))
    else
      basket_rules.push(Rule.for(rule))
    end
  end
end