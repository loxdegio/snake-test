include  Mutex
include  Thread

require './Fruit'
require './Snake'

class Map
  def initialize(x = 640, y = 480)
    super
    
    init(x,y)
  end
  
  private
  
  def init_map(maxX,maxY)
    @maxX=maxX
    @maxY=maxY
    @mGrid=Array.new(maxY)
    i=0
    while i<@maxY do
      @mGrid[i]=Array.new(@maxX)
      i+=1
    end
    @mThreads = [ "map"       => Thread.new { thread_map },
                  "movement"  => Thread.new { thread_move }] 
    @mSnake=Snake.new(@maxX,@maxY)
    @mFruitsPresent = 0
    @mFruits=[]
    @mHeader=nil
    @mScore=0
    @mMutex= [ "fruit"  => Mutex.new,
               "map"   => Mutex.new,
               "header" => Mutex.new, 
               "score"  => Mutex.new,               
               "snake"  => Mutex.new ]
    @mLegend="Legenda:  SNAKE = *   FRUTTA = #"
    i=0
    while i<@@maxX-@Legend.length do
      @mLegend+=" "
      i+=1
    end
    @mLegend+="\n"
  end
  
  def draw_map
    @mMutex["header"].synchronize {
      draw_header
    }
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
      score.+(s)
    @mMutex["header"].synchronize {
      @mHeader=score
    }
    return false
  end 
  
  def draw_snake 
      pos=@mSnake.getPosition
      pos.each do |p|
        y=p.last
        x=p.first
        @mGrid[p.last][p.first] = "*"
      end
  end
  
  def draw_fruit
      @mFruits.each do |f|
        pos=f.getPosition()
        @mGrid[pos.last][pos.first] = "#"
      end
  end
  
  def print_map
    @mMutex["score"].synchronize() {
      puts @mScore
    }
    i=0
    j=0
    while i<@maxX
      while j<@maxY do
        r = String.new
        e = @Grid[i][j]
          if e == nil
            r+=" "
          else
            r+=e
            e = nil
          end
      j+=1
      end
    i+=1  
    end
    puts "#{r}\n"   
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
      lastScore = @mScore
      @Mutex["fruit"].synchronize {
        if @mFruitsPresent > 0
          @mFruits.each do |f|
            @mMutex["snake"].synchronize {
              @mSnake.move(@@maxX,@@maxY)
              h = @mSnake.getHeadPosition
            }
            p = f.getPosition
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