require "minitest/autorun"
require_relative "../lib/checkout"

def create_promotional_rules
  prs = [{rule: "basket", type: "percentage", property: "value", value_over: 60, discount: 10},
         {rule: "item", type: "absolute", property: "quantity", item_id: "001", quantity_over: 2, discount: 0.75}]
  PromotionalRules.new(prs)
end

def include_basket_items_to_checkout(checkout, basket)
  basket.each{|item_id| checkout.scan(@db_items[item_id])}
  checkout
end

class CheckoutTest < Minitest::Test
  def setup
    @db_items = {
      "001" => {id: "001", name: "Lavender heart", value: 9.25},
      "002" => {id: "002", name: "Personalised cufflinks", value: 45.00},
      "003" => {id: "003", name: "Kids T-shirt", value: 19.95}
    }

    @checkout = Checkout.new(create_promotional_rules)
  end

  def test_checkout_without_promotional_rules_with_1_item
    item = {id: "001", name: "Lavender heart", value: 9.25}
    co = Checkout.new

    co.scan(item)

    assert_equal co.total, 9.25
  end

  def test_checkout_without_promotional_rules_with_2_item
    item_1 = {id: "001", name: "Lavender heart", value: 9.25}
    item_2 = {id: "002", name: "Personalised cufflinks", value: 45.00}
    co = Checkout.new

    co.scan(item_1)
    co.scan(item_2)

    assert_equal co.total, 54.25
  end

  def test_checkout_with_basket_promotional_rule
    item_1 = {id: "002", name: "Personalised cufflinks", value: 45.00}
    item_2 = {id: "003", name: "Kids T-shirt", value: 19.95}
    promotional_rules = PromotionalRules.new([{rule: "basket", type: "percentage", property: "value", value_over: 60, discount: 10}])
    co = Checkout.new(promotional_rules)

    co.scan(item_1)
    co.scan(item_2)

    assert_equal co.total, 58.46
  end

  def test_checkout_with_item_promotional_rule
    item_1 = {id: "001", name: "Lavender heart", value: 9.25}
    item_2 = {id: "001", name: "Lavender heart", value: 9.25}
    promotional_rules = PromotionalRules.new([{rule: "item", type: "absolute", property: "quantity", item_id: "001", quantity_over: 2, discount: 0.75}])
    co = Checkout.new(promotional_rules)

    co.scan(item_1)
    co.scan(item_2)

    assert_equal co.total, 17.00
  end

  def test_acceptance_testing_case_1
    basket = ["001", "002","003"]
    result_value = 66.78
    @checkout = include_basket_items_to_checkout(@checkout, basket)

    value = @checkout.total

    assert_equal result_value, value
  end

  def test_acceptance_testing_case_2
    basket = ["001", "003", "001"]
    result_value = 36.95
    @checkout = include_basket_items_to_checkout(@checkout, basket)

    value = @checkout.total

    assert_equal result_value, value
  end

  def test_acceptance_testing_case_3
    basket = ["001", "002", "001", "003"]
    result_value = 73.76
    @checkout = include_basket_items_to_checkout(@checkout, basket)

    value = @checkout.total

    assert_equal result_value, value
  end
end