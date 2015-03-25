class Point
  def initialize(x = 0, y = 0, dx = -1, dy = 0)
    @x  = x
    @y  = y
    @dx = dx
    @dy = dy
  end
  
  def get_x
    return @x
  end
  
  def get_y
    return @y
  end
  
  def get_dx
    return @dx
  end
    
  def get_dy
    return @dy
  end
  
  def set_next_move(dx = 0, dy = 0)
    @dx=dx
    @dy=dy
  end
  
  def teleport(x = 0, y = 0)
    @x=x; @y=y
  end
  
  def move(maxX = 0, maxY = 0)
    @x+=@dx
    if @x < 0
      @x=maxX-1
    else
      @x=@x%maxX
    end
    @y+=@dy
    if @y < 1
      @y=maxY-1
    else
      @y=@y%maxY
    end
  end
  
end