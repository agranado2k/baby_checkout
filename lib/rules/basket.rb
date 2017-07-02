module Rules
  class Basket < Rule
    def applicable?(value)
      value >= value_over
    end
  end
end