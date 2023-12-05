# Create a class called MyCar. When you initialize a new instance or object of the class, allow the user to define some instance variables that tell us the year, color, and model of the car.
# Create an instance variable that is set to 0 during instantiation of the object to track the current speed of the car as well.
# Create instance methods that allow the car to speed up, brake, and shut the car off.

# Add an accessor method to your MyCar class to change and view the color of your car. Then add an accessor method that allows you to view, but not modify, the year of your car.

# You want to create a nice interface that allows you to accurately describe the action you want your program to perform.
# Create a method called spray_paint that can be called on an object and will modify the color of the car.

# Add a class method to your MyCar class that calculates the gas mileage (i.e. miles per gallon) of any car.

# Override the to_s method to create a user friendly print out of your object.

# Create a superclass called Vehicle for your MyCar class to inherit from and move the behavior that isn't specific to the MyCar class to the superclass.
# Create a constant in your MyCar class that stores information about the vehicle that makes it different from other types of Vehicles.
# Then create a new class called MyTruck that inherits from your superclass that also has a constant defined that separates it from the MyCar class in some way.

# Add a class variable to your superclass that can keep track of the number of objects created that inherit from the superclass.
# Create a method to print out the value of this class variable as well.

# Create a module that you can mix in to ONE of your subclasses that describes a behavior unique to that subclass.

# Move all of the methods from the MyCar class that also pertain to the MyTruck class into the Vehicle class. Make sure that all of your previous method calls are working when you are finished.

# Write a method called age that calls a private method to calculate the age of the vehicle. Make sure the private method is not available from outside of the class.
# You'll need to use Ruby's built-in Time class to help.

module Towable
  def tow
    puts 'Towing!'
  end
end

class Vehicle
  attr_accessor :color
  attr_reader :yr, :model

  @@number_of_vehicles = 0

  def self.print_number_of_vehicles
    puts "This program has created #{@@number_of_vehicles} vehicles"
  end

  def self.gas_mileage(miles, gallons)
    puts "#{miles / gallons} miles per gallon of gas"
  end

  def initialize(yr, color, model)
    @yr = yr
    @color = color
    @model = model
    @speed = 0
    @@number_of_vehicles += 1
  end

  def speed_up(num)
    @speed += num
    puts "You push the gas and accelerate #{num} mph."
  end

  def brake(num)
    @speed -= num
    puts "You push the brake and decelerate #{num} mph."
  end

  def current_speed
    puts "You are now going #{@speed} mph."
  end

  def shut_off
    @speed = 0
    puts "Let's park this bad boy!"
  end

  def spray_paint(color)
    self.color = color
    puts "Your new #{color} paint job looks great!"
  end

  def age
    puts "Your #{model} is #{years_old} years old."
  end

  private

  def years_old
    Time.now.year - @yr.to_i
  end
end

class MyCar < Vehicle
  NUMBER_OF_SEATS = 5

  def to_s
    "This car is a #{color} #{yr} #{model} and is currently going #{@speed} mph."
  end
end

class MyTruck < Vehicle
  NUMBER_OF_SEATS = 7

  include Towable

  def to_s
    "This truck is a #{color} #{yr} #{model} and is currently going #{@speed} mph."
  end
end

Vehicle.print_number_of_vehicles
car = MyCar.new(2016, 'red', 'Accent')
Vehicle.print_number_of_vehicles
puts car
car.spray_paint('green')
puts car
car.current_speed
car.speed_up(20)
car.current_speed
car.speed_up(20)
car.current_speed
car.brake(20)
car.current_speed
car.brake(20)
car.current_speed
car.shut_off
car.current_speed
MyCar.gas_mileage(351, 13)
truck = MyTruck.new('2010', 'yellow', 'Tundra')
Vehicle.print_number_of_vehicles
puts truck
truck.tow
car.age
truck.age

# Print to the screen your method lookup for the classes that you have created.

p Vehicle.ancestors
p MyCar.ancestors
p MyTruck.ancestors

# When running the following code...

# class Person
#   attr_reader :name
#   def initialize(name)
#     @name = name
#   end
# end

# bob = Person.new('Steve')
# bob.name = 'Bob'

# We get an undefined method error. Why do we get this error and how do we fix it?

# An error is raised because the `name=` method is a setter method, but the `attr_reader` method only allows us to expose the instance variable, not change it.
# This can be fixed by caling the `attr_accessor` method instead.

class Person
  attr_accessor :name
  def initialize(name)
    @name = name
  end
end

bob = Person.new('Steve')
p bob.name
bob.name = 'Bob'
p bob.name

# Create a class 'Student' with attributes name and grade. Do NOT make the grade getter public, so joe.grade will raise an error. Create a better_grade_than? method, that you can call like so...

class Student
  attr_accessor :name

  def initialize(name, grade)
    @name = name
    @grade = grade
  end

  def better_grade_than?(student)
    grade > student.grade
  end

  protected

  attr_accessor :grade
end

joe = Student.new('Joe', 95)
bob = Student.new('Bob', 85)
puts 'Well done!' if joe.better_grade_than?(bob)

# Given the following code...

# bob = Person.new
# bob.hi

# And a corresponding provate method error message, what is the problem and how would you go about fixing it?

# The problem is that the `hi` method is private and the object cannot access it. This can be fixed by making the method public or by calling another method that uses the `hi` method
