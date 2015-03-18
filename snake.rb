require './point'

class Snake
  def initialize(maxX = 0, maxY = 0)
    @@maxLength = 1024
    @length=3
    @points=Array.new(@length)
    i=0;
    while i<@length do
      @points[i] = Point.new(maxX/2-i,maxY/2-i)
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
    i = @length-1;
    while i >= 1 do
      nm=@points[i-1].get_next_move()
      @points[i].set_next_move(nm[0],nm[1])
      i-=1
    end
  end
  
  def move(maxX = 0, maxY = 0)
    for i in @points.each do
      i.move(maxX,maxY)
    end
  end 
    
  def eat_fruit
    return extend_snake
  end
  
  def get_head_position
    return @points[0].get_position
  end
  
  def get_position
    pos= Array.new(@length) { Array.new(2) }
    i=0
    @points.each do |p|
      pos[i] = p.get_position
      i+=1
    end
    return pos
  end
  
  private 
    def extend_snake
      l=@length
      @length+=1
      if length == @@maxLength
        return true
      end
      p=Array.new(@length)
      i=0
      while i<l do
        p[i] = @points[i]
        i+=1
      end
      @points=p
      pos=@points[l-1].get_position
      @points[l]=Point.new(pos[0]-1,pos[1]-1)
      move=@points[l-1].get_next_move()
      @points[l].set_next_move(move[0],move[1])
      @length+=1
      return false
    end

    def set_next_move(dx = 0, dy = 0)
      update()
      @points[0].dx=dx
      @points[0].dy=dy
    end  
end