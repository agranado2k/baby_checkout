require_relative "./promotional_rules"

class Checkout
  attr_accessor :items, :pr

  def initialize(pr = nil)
    @items = []
    @pr = pr
  end

  def scan(item)
    items.push(item.dup)
  end

  def total
    @items = apply_promotional_rules_to_items
    apply_promotional_rules_to_basket(pre_calculate_total)
  end

  def apply_promotional_rules_to_items
    if pr
      items.each do |item| 
        quantity = items.select{|i|i[:id] == item[:id]}.size
        item = pr.update_item_value_by_rules(item, quantity) 
      end
    end
    items
  end

  def pre_calculate_total
    items.reduce(0){|sum, item| sum + item[:value]}
  end

  def apply_promotional_rules_to_basket(total)
    pr ? pr.update_basket_value_by_rules(total) : total
  end
end