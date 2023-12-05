# Given this class:
# One problem is that we need to keep track of different breeds of dogs, since they have slightly different behaviors. For example, bulldogs can't swim, but all other dogs can.
# Create a sub-class from Dog called Bulldog overriding the swim method to return "can't swim!"

class Pet
  def run
    'running!'
  end

  def jump
    'jumping!'
  end
end

class Dog < Pet
  def speak
    'bark!'
  end

  def swim
    'swimming!'
  end
end

class Bulldog < Dog
  def swim; "can't swim!" end
end

class Cat < Pet
  def speak; 'meow!' end
end

pete = Pet.new
kitty = Cat.new
dave = Dog.new
bud = Bulldog.new

p pete.run                # => "running!"

p kitty.run               # => "running!"
p kitty.speak             # => "meow!"

p dave.speak              # => "bark!"

p bud.run                 # => "running!"
p bud.swim                # => "can't swim!"

p Bulldog.ancestors
