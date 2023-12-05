# If we have this code:

class Greeting
  def greet(message)
    puts message
  end
end

class Hello < Greeting
  def hi
    greet("Hello")
  end
end

class Goodbye < Greeting
  def bye
    greet("Goodbye")
  end
end

# What happens in each of the following cases:

hello = Hello.new
hello.hi

# 'Hello' is output.

hello = Hello.new
hello.bye

# NoMethod error.

hello = Hello.new
hello.greet

# wrong number of arguments error (given 0, expected 1)

hello = Hello.new
hello.greet("Goodbye")

# 'Goodbye' is output.

Hello.hi

# NoMethod Error
