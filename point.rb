class Point
  def initialize(x = 0, y = 0)
    @x=x
    @y=y
    @dx=-1
    @dy=0
  end
  
  def get_position
    point=Array.new(2)
    point[0]=@x
    point[1]=@y
    return point
  end
  
  def set_next_move(dx = 0, dy = 0)
    @dx=dx
    @dy=dy
  end
  
  def get_next_move
    move=Array.new(2)
    move[0]=@dx
    move[1]=@dy
  end
  
  def move(maxX = 0, maxY = 0)
    @x+=@dx
    if @x < 0
      @x=maxX-1
    else
      @x=@x%maxX
    end
    @y+=@dy
    if @y < 0
      @y=maxX-1
    else
      @y=@y%maxX
    end
  end
  
end