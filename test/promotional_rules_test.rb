require "test_helper"

class PromotionalRulesTest < Minitest::Test
  def test_promotional_rules_for_items
    items = [{id: "001", name: "Lavender heart", value: 9.25},
             {id: "001", name: "Lavender heart", value: 9.25}]
    prs = PromotionalRules.new
    prs.include_rule({rule: "basket", type: "percentage", property: "value", value_over: 60, discount: 10})
    prs.include_rule({rule: "item", type: "absolute", property: "quantity", item_id: "001", quantity_over: 2, discount: 0.75})

    value_after_rule = prs.update_item_value_by_rules(items.first[:value], items.size, items.first[:id])

    assert_equal value_after_rule, 8.50
  end

  def test_promotional_rules_for_basket
    total_value = 64.95
    prs = PromotionalRules.new
    prs.include_rule({rule: "basket", type: "percentage", property: "value", value_over: 60, discount: 10})
    prs.include_rule({rule: "item", type: "absolute", property: "quantity", item_id: "001", quantity_over: 2, discount: 0.75})

    total_after_rule = prs.update_basket_value_by_rules(total_value)

    assert_equal total_after_rule, 58.46
  end
end