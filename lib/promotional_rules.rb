require_relative "./calculator"
require_relative "./calculators/percentage"
require_relative "./calculators/absolute"

class PromotionalRules
  attr_accessor :promotional_rules, :calculator

  def initialize(promotional_rules = [], calculator = Calculator)
    @promotional_rules = promotional_rules
    @calculator = calculator
  end

  def update_item_value_by_rules(items)
    items.each do |item|
      promotional_rules.select{|r|r[:rule] == "item" && applicable?(r, items, item)}.each do |pr|
        item[:value] = calculator.for(item[:value], pr).execute
      end
    end

    items
  end

  def update_basket_value_by_rules(total)
    promotional_rules.select{|r| r[:rule] == "basket" && applicable?(r, total, nil)}
      .reduce(total){|final_total, pr| calculator.for(total, pr).execute}
  end

  def applicable?(pr, value, object)
    if pr[:rule] == "item"
      quantity = value.select{|i|i[:id] == pr[:item_id]}.size
      object[:id] == pr[:item_id] && quantity >= pr[:quantity_over]
    else
      value >= pr[:value_over]
    end
  end
end