require "minitest/autorun"

class Checkout
  attr_accessor :items

  def initialize(promotional_rules)
    @items = []
  end

  def scan(item)
    items.push(item)
  end

  def total
    items.reduce(0){|sum, item| sum + item[:value]}
  end
end

class CheckoutTest < Minitest::Test
  DB_ITEMS = {
    "001" => {id: "001", name: "Lavender heart", value: 9.25},
    "002" => {id: "002", name: "Personalised cufflinks", value: 45.00},
    "003" => {id: "003", name: "Kids T-shirt", value: 19.95}
  }


  def test_checkout_without_promotional_rules_with_1_item
    item = {id: "001", name: "Lavender heart", value: 9.25}
    co = Checkout.new(nil)

    co.scan(item)

    assert_equal co.total, 9.25
  end

  def test_checkout_without_promotional_rules_with_2_item
    item_1 = {id: "001", name: "Lavender heart", value: 9.25}
    item_2 = {id: "002", name: "Personalised cufflinks", value: 45.00}
    co = Checkout.new(nil)

    co.scan(item_1)
    co.scan(item_2)

    assert_equal co.total, 54.25
  end

  def test_acceptance_testing_case_1
    skip
    basket = ["001", "002","003"]
    result_value = 66.78
    promotional_rules = [{type: "basket_percentage_discount", price_over: 60, discount: 10}]
    co = Checkout.new(promotional_rules) #create Checkout with promotianl rules
    basket.each{|item_code| co.scan(DB_ITEMS[item_code])}#include items from basket to Checkout instance

    value = co.total

    assert_equal result_value, value
  end

  def test_acceptance_testing_case_2
    skip
    basket = ["001", "003", "001"]
    result_value = 36.95
    promotional_rules = [{type: "item_abs_discount", qty_over: 2, discount: 1.25}]
    co = Checkout.new(promotional_rules) #create Checkout with promotianl rules
    basket.each{|item_code| co.scan(DB_ITEMS[item_code])}#include items from basket to Checkout instance

    value = co.total

    assert_equal result_value, value
  end

  def test_acceptance_testing_case_3
    skip
    basket = ["001", "002", "001", "003"]
    result_value = 73.76
    promotional_rules = [{type: "basket_percentage_discount", price_over: 60, discount: 10},
                          {type: "item_abs_discount", qty_over: 2, discount: 1.25}]
    co = Checkout.new(promotional_rules) #create Checkout with promotianl rules
    basket.each{|item_code| co.scan(DB_ITEMS[item_code])}#include items from basket to Checkout instance

    value = co.total

    assert_equal result_value, value
  end
end