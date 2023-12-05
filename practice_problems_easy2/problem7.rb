# If we have a class such as the one below:

class Cat
  @@cats_count = 0

  def initialize(type)
    @type = type
    @age  = 0
    @@cats_count += 1
  end

  def self.cats_count
    @@cats_count
  end
end

# Explain what the @@cats_count variable does and how it works. What code would you need to write to test your theory?

# The @@cats_count variable represents the number of objects in the Cat class. Every time a new Cat object is instantiated, the value is incresed by 1.

p Cat.cats_count
Cat.new('hairless')
p Cat.cats_count
