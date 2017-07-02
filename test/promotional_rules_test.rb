require "minitest/autorun"
require_relative "../lib/promotional_rules"

class PromotionalRulesTest < Minitest::Test
 def test_promotional_rule
    prs = PromotionalRules.new([{rule: "basket", type: "percentage", property: "value", value_over: 60, discount: 10}])

    assert_equal prs.promotional_rules.size, 1
  end

  def test_promotional_rules_for_items
    items = [{id: "001", name: "Lavender heart", value: 9.25},
             {id: "001", name: "Lavender heart", value: 9.25}]
    prs = PromotionalRules.new([{rule: "basket", type: "percentage", property: "value", value_over: 60, discount: 10},
                                {rule: "item", type: "absolute", property: "quantity", item_id: "001", quantity_over: 2, discount: 0.75}])

    items_after_rule = prs.update_item_value_by_rules(items)

    assert_equal items_after_rule, [{id: "001", name: "Lavender heart", value: 8.50},
                                    {id: "001", name: "Lavender heart", value: 8.50}]
  end

  def test_promotional_rules_for_basket
    total_value = 64.95
    prs = PromotionalRules.new([{rule: "basket", type: "percentage", property: "value", value_over: 60, discount: 10},
                                {rule: "item", type: "absolute", property: "quantity", item_id: "001", quantity_over: 2, discount: 0.75}])

    total_after_rule = prs.update_basket_value_by_rules(total_value)

    assert_equal total_after_rule, 58.46
  end
end