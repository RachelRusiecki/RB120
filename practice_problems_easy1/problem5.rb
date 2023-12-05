# Which of these two classes would create objects that would have an instance variable and how do you know?

class Fruit
  def initialize(name)
    name = name
  end
end

class Pizza
  def initialize(name)
    @name = name
  end
end

# The Pizza class would create objects with an instance variable because that is the only class that has one. It has the @ symbol in front of the variable name, but the Fruit class doesn't.

hot_pizza = Pizza.new('cheese')
orange = Fruit.new('apple')

p hot_pizza.instance_variables
p orange.instance_variables
