class PromotionalRules
  attr_accessor :promotional_rules

  def initialize(promotional_rules)
    @promotional_rules = promotional_rules
  end

  def item_promotional_rules(items)
    promotional_rules.select{|r|r[:rule] == "item"}.each do |promotional_rule|
      items.each do |item|
        quantity = items.select{|item| item[:id] == promotional_rule[:item_id]}.size
        if item[:id] == promotional_rule[:item_id] && quantity >= promotional_rule[:quantity_over]
          item[:value] = item[:value] - promotional_rule[:discount] 
        end
      end
    end
    items
  end

  def basket_promotional_rules(total)
    tmp_total = total
    promotional_rules.select{|r|r[:rule] == "basket"}.each do |promotional_rule|
      if total >= promotional_rule[:value_over]
        tmp_total -= (total * (promotional_rule[:discount]/100.0))
        tmp_total = tmp_total.round(2) 
      end
    end
    total = tmp_total

    total
  end
end