include Point

class Fruit
  def initialize(x = 0, y = 0)
    @position = Point.new(x,y)
  end
  
  def getPosition
    return @position.getPosition()
  end
  
end