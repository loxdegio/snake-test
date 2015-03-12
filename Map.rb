include Fruit
include Mutex
include Snake
include Thread

class Map
  def initialize
    @@maxX=640
    @@maxY=480
    @mGrid=Array.new(@@maxX)
    @mGrid.each do |row|
      row=Array.new(@@maxY)
    end
    @mThreads = [ "map"       => Thread.new { thread_map },
                  "movement"  => Thread.new { thread_move }] 
    @mSnake=Snake.new(@@maxX,@@maxY)
    @mFruitsPresent = 0
    @mFruits=[]
    @mHeader=nil
    @mScore=0
    @mMutex= [ "grid"   => Mutex.new,
               "header" => Mutex.new,
               "map"    => Mutex.new, 
               "score"  => Mutex.new,               
               "snake"  => Mutex.new ]
    @mLegend="Legenda:  SNAKE = *   FRUIT = #"
    i=0
    while i<609
      @mLegend+=" "
      i+=1
    end
  end
  
  def draw_map
    @mMutex["header"].synchronize {
      draw_header
    }
    @mMutex["snake"].synchronize {
      draw_snake
    }
    if @mFruitsPresent != 0
      draw_fruits
    end
    puts @mLegend
  end
  
  def draw_header
    score = String.new
    i=0
    while i<625
      score.+(" ")
      i+=1
    end
    score.+("SCORE ")
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
        while i<l
          score.+("0")
          i+=1
        end
      end
      score.+(s)
    @mMutex["header"].synchronize {
      @mHeader=score
    }
    return false
  end 
  
  def draw_snake
    @mMutex["snake"].synchronize {
      @mSnake.getPosition().each do |pos|
        @mMutex["grid"].synchronize {
          @mGrid[pos[0]][pos[1]]="*"
        }
      end
    }
  end
  
  def draw_fruit
    @mFruits.each do |f|
      pos=f.getPosition()
      @mMutex["grid"].synchronize {
        @mGrid[pos[0]][pos[1]]="#"
      }
    end
  end
  
  def print_map
    @mMutex["score"].synchronize() {
      puts @mScore
    }
    @mMutex["grid"].synchronize() {
      @Grid.each do |row|
        r = String.new()
        row.each do |e|
          if e == nil
            r+=" "
          else
            r+=e
            e = nil
          end
        end
        puts "#{r}\n"    
      end
    }
  end
  
  def thread_map
    loop do
      system("clear")
      @mMutex["map"].synchronize {
        draw_map
        print_map
      }
      sleep(1)
    end
  end
  
  def thread_move
    loop do
      @mMutex["snake"].synchronize {
        @mSnake.move(@@maxX,@@maxY)
      }
      @mMutex[ "score" ].synchronize {
        @mScore+=1
      }
    end
  end
end