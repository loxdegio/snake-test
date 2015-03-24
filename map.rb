require  'io/wait'
require  'thread'

require './fruit'
require './snake'

class Map
  
    def initialize(maxX = 0, maxY = 0)    
      @maxX=maxX
      @maxY=maxY
      @speed=0.5
      @mSnake=Snake.new(@maxX,@maxY)
      @mFruitsPresent = 0
      @mFruits=[]
      @mScore=0
      @mDir=0
      @mLegend = String.new("Legenda:  SNAKE = *   FRUTTA = #")
      @mMutex= Mutex.new
      @mThreads = { "map"       =>  Thread.new { thread_map  },
                    "movement"  =>  Thread.new { thread_move },
                    "turn"      =>  Thread.new { thread_turn }}
    end
    
    def map_release
      @mThreads.each do |k,t|
        t.join
      end
    end
  
  private
  
  def print_header
    rc = false;
    s = @mScore
    if @mScore < 999999999
      score = String.new("SCORE ".+(s.to_s))
      puts score
    else
      system "clear"
      puts "YOU WIN!"
      rc = true
    end
    return rc
  end 
  
  def draw_snake(x=0,y=0)
    @mSnake.get_position.each do |p|
      if ( p.get_x == x && p.get_y == y )
        return true
      end  
    end
    return false
  end
  
  def draw_fruit(x=0,y=0)
      rc = false;
      if @mFruitsPresent > 0
        @mFruits.each do |f|
          if ( f.get_x == x && f.get_y == y )
            return true
          end
        end
      end
      return false
  end
  
  def print_map
    print_header
    i=0
    while i<@maxY
      j=0
      while j<@maxX        
        if draw_snake(j,i)==true
          while draw_snake(j,i)==true
            print "*"
            j+=1
          end 
        else
          if draw_fruit(j,i)==true
            print "#"
          else
            print " "
          end
        end
      j+=1
      end
      print "\n"
      i+=1
    end
    puts @mLegend   
  end
  
  def thread_map
    loop do
      system("clear")
      @mMutex.synchronize {
        print_map
      }
      sleep(@speed)
    end
  end
  
  def fruit_eaten
    @mFruitsPresent-=1
    @mFruits[@mFruitsPresent]=nil
  end
  
  def thread_move
    loop do
      @mMutex.synchronize {
        lastScore = @mScore
        @mSnake.move(@maxX,@maxY)
        if @mFruitsPresent > 0
          @mFruits.each do |f|
            h = @mSnake.get_head_position
            if h.get_x == f.get_x && h.gety == p.get_y
              @mSnake.eat_fruit
              fruit_eaten(j,i)
              @mScore+=5  
              break
            end
          end
        end
        unless (@mScore - lastScore) == 5
          @mScore+=1
        end
      } 
      sleep(@speed) 
    end
  end
  
  def set_dir(arr = "a")
    d = @mDir
    case arr
      when "a"
        if d == "w" || d == "s"
          @mDir = 0
        end
      when "w"
        if d == "a" || d == "d"
          @mDir = 1
        end
      when "d"
        if d == "w" || d == "s"
          @mDir = 2
        end
      when "s"
        if d == "a" || d == "d"
          @mDir = 3
        end
      when "x"
        exit(0)
      else
        @mDir = 0
    end
  end
  
  def char_if_pressed
    begin
      system("stty raw -echo") # turn raw input on
      c = nil
      if $stdin.ready?
        c = $stdin.getc
      end
      c.chr if c
    ensure
      system "stty -raw echo" # turn raw input off
    end
  end
  
  def thread_turn
    loop do
      arr = char_if_pressed
      set_dir(arr)
      @mSnake.set_direction(@mDir)
    end
  end
  
end