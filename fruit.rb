require './point'

class Fruit
  def initialize(x = 0, y = 0)
    @position = Point.new(x,y)
  end
  
  def get_position
    return @position.get_position()
  end
  
  def get_x
    return @position.get_x
  end
  
  def get_y
    return @position.get_y
  end
  
end