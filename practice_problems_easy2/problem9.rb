# If we have this class:

class Game
  def play
    "Start the game!"
  end
end

class Bingo < Game
  def rules_of_play
    #rules of play
  end

  def play
    'Eyes down'
  end
end

# What would happen if we added a play method to the Bingo class, keeping in mind that there is already a method of this name in the Game class that the Bingo class inherits from.

# The Bingo::play method would be invoked if called on a Bingo object because it would encounter thatmethod first in the method lookup path.

p Bingo.new.play
