module Rules
  class Item < Rule
    attr_accessor :item_id

    def initialize(rule)
      super(rule)
      @value_over = rule[:quantity_over]
      @item_id = rule[:item_id]
    end

    def applicable?(value, id)
      value >= value_over && item_id == id
    end
  end
end