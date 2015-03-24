class Point
  def initialize(x = 0, y = 0)
    @x  = x
    @y  = y
    @dx = -1
    @dy = 0
  end
  
  def get_x
    return @x
  end
  
  def get_y
    return @y
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
      @y=maxY-1
    else
      @y=@y%maxY
    end
  end
  
end