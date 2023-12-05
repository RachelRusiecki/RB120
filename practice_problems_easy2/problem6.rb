# If I have the following class:

class Television
  def self.manufacturer
    # method logic
  end

  def model
    # method logic
  end
end

#Which one of these is a class method (if any) and how do you know? How would you call a class method?

# The self.manufacturer method is a class method because it is prepended with self. A class method must be called on the class itself rather than an instance of the class.
# In this case, Television.manufacturer
