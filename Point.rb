class Point
  def initialize(x = 0, y = 0)
    @x=x
    @y=y
    @dx=-1
    @dy=0
  end
  
  def getPosition
    point=Array.new(2)
    point[0]=@x
    point[1]=@y
    return point
  end
  
  def setNextMove(dx = 0, dy = 0)
    @dx=dx
    @dy=dy
  end
  
  def getNextMove
    move=Array.new(2)
    move[0]=@dx
    move[1]=@dy
  end
  
  def move(maxX = 0, maxY = 0)
    @x+=@dx%maxX
    @y+=@dy%maxY
  end
  
end