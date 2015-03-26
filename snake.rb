require './point'

class Snake
  def initialize(maxX = 0, maxY = 0)
    @@maxLength = 1024
    @length=5
    @points=Array.new(@length)
    i = 0
    y = maxY/2
    while i<@length
      x = (maxX/2)-i;
      @points[i] = Point.new(x,y,-1,0)
      i+=1
    end
  end
  
  def set_direction(dir = 0)
    case dir
      when 0
        set_next_move(-1, 0)
      when 1
        set_next_move(0, -1)
      when 2
        set_next_move(1, 0)
      when 3
        set_next_move(0, 1)
    end
  end
    
  def update
    i = 0;
    while i < @length-1
      @points[i].set_next_move(@points[i+1].get_dx,@points[i+1].get_dy)
      i+=1
    end
  end
  
  def move(maxX = 0, maxY = 0)
    @points.each do |i|
      i.move(maxX,maxY)
    end
    update
  end 
    
  def eat_fruit
    return extend_snake
  end
  
  def get_head_position
    return @points[0]
  end
  
  def get_position
    return @points
  end
  
  def collision
    l = @length-1
    i = 0
    while i<l && is_head_in(@points[i].get_x,@points[i].get_y) == false
      i+=1
    end
    return !(i==l) 
  end
  
  def is_head_in( x=0, y=0 )
    h = @points[@length-1]
    return ( h.get_x == x && h.get_y == y )
  end
  
  private 
    def extend_snake
      rc = false
      l=@length
      @length+=1
      if l == @@maxLength
        return true
      else
        p=Array.new(@length)
        i=0
        while i<l do
          p[i] = @points[i]
          i+=1
        end
        @points=p
        @points[l]=Point.new(@points[l-1].get_x+@points[l-1].get_dx,@points[l-1].get_y+@points[l-1].get_dy,@points[l-1].get_dx,@points[l-1].get_dy)
      end
      return false
    end

    def set_next_move(dx = 0, dy = 0)
      @points[@length-1].set_next_move(dx,dy)
    end  
end
