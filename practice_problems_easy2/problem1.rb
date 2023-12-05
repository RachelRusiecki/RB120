# You are given the following code:

class Oracle
  def predict_the_future
    "You will " + choices.sample
  end

  def choices
    ["eat a nice lunch", "take a nap soon", "stay at work late"]
  end
end

# What is the result of executing the following code:

oracle = Oracle.new
p oracle.predict_the_future

# The return value will be a string that says 'You will...' and then once of the predictions in the array in the choices method.
