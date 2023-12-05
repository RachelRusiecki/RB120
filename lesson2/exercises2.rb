# Modify the class definition from above to facilitate the following methods. Note that there is no name= setter method now.

class Person
  attr_accessor :first_name, :last_name

  def initialize(full_name)
    @first_name = full_name.split[0]
    @last_name = full_name.split.size > 1 ? full_name.split[-1] : ''
  end

  def name
    "#{first_name} #{last_name}".strip
  end
end

bob = Person.new('Robert')
p bob.name                  # => 'Robert'
p bob.first_name            # => 'Robert'
p bob.last_name             # => ''
bob.last_name = 'Smith'
p bob.name                  # => 'Robert Smith'
