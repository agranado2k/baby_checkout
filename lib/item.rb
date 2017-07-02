class Item
  attr_accessor :id, :name, :value

  def initialize(args)
    @id = args[:id]
    @name = args[:name]
    @value = args[:value]
  end
end