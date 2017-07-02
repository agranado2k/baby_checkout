class PromotionalRules
  attr_accessor :promotional_rules

  def initialize(promotional_rules = [])
    @promotional_rules = promotional_rules
  end

  def update_item_value_by_rules(items)
    items.each do |item|
      promotional_rules.select{|r|r[:rule] == "item" && applicable?(r, items, item)}.each do |pr|
        item[:value] = calculate(item[:value], pr)
      end
    end

    items
  end

  def update_basket_value_by_rules(total)
    promotional_rules.select{|r| r[:rule] == "basket" && applicable?(r, total, nil)}
      .reduce(total){|final_total, pr| calculate(total, pr)}
  end

  def calculate(value, pr)
    if pr[:type] == "percentage"
      (value - (value*pr[:discount]/100.00)).round(2)
    else
      (value - pr[:discount]).round(2)
    end
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