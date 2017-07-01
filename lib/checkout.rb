require_relative "./promotional_rules"

class Checkout
  attr_accessor :items, :to_remove_this_promotional_rules, :promotional_rule

  def initialize(pr = nil)
    @items = []
    @promotional_rule = pr
  end

  def scan(item)
    items.push(item.dup)
  end

  def total
    @items = promotional_rule.item_promotional_rules(items) if promotional_rule
    total = items.reduce(0){|sum, item| sum + item[:value]}
    total = promotional_rule.basket_promotional_rules(total) if promotional_rule

    total
  end
end