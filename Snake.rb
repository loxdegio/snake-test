require './Point'

class Snake
  def initialize(maxX = 0, maxY = 0)
    @@maxLength = 1024
    @length=3
    @points=Array.new(@@maxLength)
    i=0;
    while i<@length do
      @points[i] = Point.new(maxX/2-i,maxY/2-i)
      i+=1      
    end
  end
  
  def setNextMove(dx = 0, dy = 0)
    update()
    @points[0].dx=dx
    @points[0].dy=dy
  end  
  
  def setDirection(dir = 0)
    case dir
      when 0
        setNextMove(-1, 0)
      when 1
        setNextMove(0, -1)
      when 2
        setNextMove(1, 0)
      when 3
        setNextMove(0, 1)
    end
  end
    
  def update
    i = @length-1;
    while i >= 1 do
      nm=@points[i-1].getNextMove()
      @points[i].setNextMove(nm[0],nm[1])
      i-=1
    end
  end
  
  def move(maxX = 0, maxY = 0)
    for i in @points.each do
      i.move(maxX,maxY)
    end
  end
  
  def extendSnake
    pos=@points[@length-1].getPosition()
    @points[@length]=Point.new(pos[0]-1,pos[1]-1)
    move=@points[length-1].getNextMove()
    @points[@length].setNextMove(move[0],move[1])
    @length+=1
  end  
    
  def eatFruit
    extendSnake()
  end
  
  def getHeadPosition
    return @points[0].getPosition()
  end
  
  def getPosition
    pos= Hash.new
    i=0
    for j in @points.each do
      pos[i] = j.getPosition()
      i+=1
    end
    return pos
  end
  
  private extendSnake  
  private setNextMove
    
end