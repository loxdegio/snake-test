require  'thread'

require './fruit'
require './snake'

class Map
  
    def initialize
      super
    
      init_map
    end
  
    def set_resolution(x=640, y=480)
      @maxX=x
      @maxY=y
    end
    
    def map_release
      @mThreads.each do |k,t|
        t.join
      end
    end
  
  private
  
  def init_map
    @maxX=640
    @maxY=480
    @mGrid = Array.new(@maxY) { Array.new(@maxX) }
    @mSnake=Snake.new(@maxX,@maxY)
    @mFruitsPresent = 0
    @mFruits=[]
    @mHeader=nil
    @mScore=0
    @mLegend=String.new 
    @mMutex= { "fruit"  => Mutex.new,
               "map"   => Mutex.new,
               "header" => Mutex.new, 
               "score"  => Mutex.new,               
               "snake"  => Mutex.new  }
    @mThreads = { "map"       => Thread.new { thread_map },
                  "movement"  => Thread.new { thread_move } }
  end
  
  def write_legend
    @mLegend="Legenda:  SNAKE = *   FRUTTA = #"
    i=0
    while i<@@maxX-@Legend.length do
      @mLegend+=" "
      i+=1
    end
    @mLegend+="\n"
  end
  
  def draw_map
    draw_header
    @mMutex["snake"].synchronize {
      draw_snake
    }
    @mMutex["fruit"].synchronize {
      if @mFruitsPresent != 0
        draw_fruits
      end
    }
    puts @mLegend
  end
  
  def draw_header
    score = String.new
    i=0
    while i<625 do
      score.+(" ")
      i+=1
    end
    score.+("SCORE ")
    s=0
    @mMutex["score"].synchronize {
      s = @mScore
    }
    if s >= 0 && s < 10
      l = 8
    elsif s >= 10 && s < 100
      l = 7 
    else if s >= 100 && s < 1000
      l = 6
    elsif s >= 1000 && s < 10000
      l = 5
    elsif s >= 10000 && s < 100000
      l = 4
    elsif s >= 100000 && s < 1000000
      l = 3
    elsif s >= 1000000 && s < 10000000
      l = 2
    elsif s >= 1000000 && s < 10000000
      l = 1
    elsif s >= 999999999
      system("clear")
      puts "YOU WIN!!"
      wait 30
      return true
    end
    
    if l > 0
      i=0
      while i<l do
        score.+("0")
        i+=1
      end
      end
    end
    score.+(s.to_s)
    @mMutex["header"].synchronize {
      @mHeader=score
    }
    return false
  end 
  
  def draw_snake
    pos=@mSnake.get_position
    pos.each do |p|
      @mMutex["map"].synchronize {
        @mGrid[p[1]][p[0]] = String.new("*")
      }
    end
  end
  
  def draw_fruit
      @mFruits.each do |f|
        pos=f.get_position  
        @mMutex["map"].synchronize {
          @mGrid[pos[1]][pos[0]] = String.new("#")
        }
      end
  end
  
  def print_map
    e = String.new
    @mMutex["score"].synchronize {
      puts @mScore
    }
    i=0; j=0
    while i<@maxX
      while j<@maxY do
        r = String.new  
          @mMutex["map"].synchronize {
            if @mGrid[i][j] == nil
              r.+(" ")
            else
              r.+(@mGrid[i][j])
            end
          }
      j+=1
      end
    i+=1  
    end
    puts "#{r}\n"   
  end
  
  def thread_map
    loop do
      system("clear")
      draw_map
      print_map
      sleep(1)
    end
  end
  
  def thread_move
    loop do
      @Mutex["score"].synchronize {
         lastScore = @mScore
      }
      @Mutex["fruit"].synchronize {
        if @mFruitsPresent > 0
          @mFruits.each do |f|
            @mMutex["snake"].synchronize {
              @mSnake.move(@maxX,@maxY)
              h = @mSnake.get_head_position
            }
            p = f.get_position
            e = ( h.first == p.first ) && ( h.last == p.last )
            if e
              @mMutex[ "score" ].synchronize {
                @mScore+=5
              }
              break
            end
          end
        end
      }
      unless (@mScore - lastScore) == 5
        @mMutex[ "score" ].synchronize {
          @mScore+=1
        }
      end
    end
  end
end