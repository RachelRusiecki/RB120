# If I have the following class:

class Television
  def self.manufacturer
    # method logic
  end

  def model
    # method logic
  end
end

# What would happen if I called the methods like shown below?

tv = Television.new
tv.manufacturer # no method error
tv.model # would return the return value of the model method

Television.manufacturer # would return the return value of the manufacturer method
Television.model # no method error
