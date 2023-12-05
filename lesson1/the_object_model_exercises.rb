# How do we create an object in Ruby? Give an example of the creation of an object.

# Objects are created in Ruby from classes. An object is creted by initializing it with the `.new` method


# What is a module? What is its purpose? How do we use them with our classes? Create a module for the class you created in exercise 1 and include it properly.

# A module is a collection of behaviors that is usable in other classes. Its purpose is to hav another way to acheive polymorphism.
# They are included in classes to allow objcts in that class to access the methods in the module.

module Drinkable
end

class Drinks
  include Drinkable
end

energy_drink = Drinks.new

p energy_drink
