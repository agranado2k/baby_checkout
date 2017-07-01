require "minitest/autorun"

class Checkout
  attr_accessor :items, :promotional_rules

  def initialize(promotional_rules = [])
    @promotional_rules = promotional_rules
    @items = []
  end

  def scan(item)
    items.push(item.dup)
  end

  def total
    promotional_rules.each do |promotional_rule|
      if promotional_rule[:rule] == "item"
        items.each do |item|
          quantity = items.select{|item| item[:id] == promotional_rule[:item_id]}.size
          if item[:id] == promotional_rule[:item_id] && quantity >= promotional_rule[:quantity_over]
            item[:value] = item[:value] - promotional_rule[:discount] 
          end
        end
      end
    end

    total = items.reduce(0){|sum, item| sum + item[:value]}

    tmp_total = total
    promotional_rules.each do |promotional_rule|
      if promotional_rule[:rule] == "basket" && total >= promotional_rule[:value_over]
        tmp_total -= (total * (promotional_rule[:discount]/100.0))
        tmp_total = tmp_total.round(2) 
      end
    end
    total = tmp_total

    total
  end
end

class CheckoutTest < Minitest::Test

  def setup
    @db_items = {
      "001" => {id: "001", name: "Lavender heart", value: 9.25},
      "002" => {id: "002", name: "Personalised cufflinks", value: 45.00},
      "003" => {id: "003", name: "Kids T-shirt", value: 19.95}
    }
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
    promotional_rules = [{rule: "basket", type: "percentage", property: "value", value_over: 60, discount: 10}]
    co = Checkout.new(promotional_rules)

    co.scan(item_1)
    co.scan(item_2)

    assert_equal co.total, 58.46
  end

  def test_checkout_with_item_promotional_rule
    item_1 = {id: "001", name: "Lavender heart", value: 9.25}
    item_2 = {id: "001", name: "Lavender heart", value: 9.25}
    promotional_rules = [{rule: "item", type: "absolute", property: "quantity", item_id: "001", quantity_over: 2, discount: 0.75}]
    co = Checkout.new(promotional_rules)

    co.scan(item_1)
    co.scan(item_2)

    assert_equal co.total, 17.00
  end

  def test_acceptance_testing_case_1
    basket = ["001", "002","003"]
    result_value = 66.78
    promotional_rules = [{rule: "basket", type: "percentage", property: "value", value_over: 60, discount: 10},
                         {rule: "item", type: "absolute", property: "quantity", item_id: "001", quantity_over: 2, discount: 0.75}]
    co = Checkout.new(promotional_rules) #create Checkout with promotianl rules
    basket.each{|item_id| co.scan(@db_items[item_id])}#include items from basket to Checkout instance

    value = co.total

    assert_equal result_value, value
  end

  def test_acceptance_testing_case_2
    basket = ["001", "003", "001"]
    result_value = 36.95
    promotional_rules = [{rule: "basket", type: "percentage", property: "value", value_over: 60, discount: 10},
                         {rule: "item", type: "absolute", property: "quantity", item_id: "001", quantity_over: 2, discount: 0.75}]
    co = Checkout.new(promotional_rules) #create Checkout with promotianl rules
    basket.each{|item_id| co.scan(@db_items[item_id])}#include items from basket to Checkout instance

    value = co.total

    assert_equal result_value, value
  end

  def test_acceptance_testing_case_3
    basket = ["001", "002", "001", "003"]
    result_value = 73.76
    promotional_rules = [{rule: "basket", type: "percentage", property: "value", value_over: 60, discount: 10},
                         {rule: "item", type: "absolute", property: "quantity", item_id: "001", quantity_over: 2, discount: 0.75}]
    co = Checkout.new(promotional_rules) #create Checkout with promotianl rules
    basket.each{|item_id| co.scan(@db_items[item_id])}#include items from basket to Checkout instance

    value = co.total

    assert_equal result_value, value
  end
end