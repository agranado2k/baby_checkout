class Rule
  attr_accessor :type, :property, :value_over, :discount

  def initialize(rule)
    @type = rule[:type]
    @property = rule[:property]
    @value_over = rule[:value_over]
    @discount = rule[:discount]
  end

  def applicable?(value)
    fail NotImplementedError, "You must implement for your rule"
  end

  def self.for(r)
    if r[:rule] == "item"
      Rules::Item.new(r)
    else
      Rules::Basket.new(r)
    end
  end
end