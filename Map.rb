include Fruit
include Mutex
include Snake
include Thread

class Map
  def initialize(x,y)
    super
    
    init(640,480)
  end
  
  def init_map(maxX,maxY)
    @maxX=maxX
    @maxY=maxY
    @mGrid=Array.new(@@maxX)
    @mGrid.each do |row|
      row=Array.new(@@maxY)
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
    while i<@@maxX-@Legend.length
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
      @mSnake.getPosition().each do |pos|
        @mGrid[pos[0]][pos[1]]="*"
      end
  end
  
  def draw_fruit
      @mFruits.each do |f|
        pos=f.getPosition()
        @mGrid[pos[0]][pos[1]]="#"
      end
  end
  
  def print_map
    @mMutex["score"].synchronize() {
      puts @mScore
    }
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
      @Mutex["fruit"].synchronize {
        if @mFruitsPresent > 0
          @mFruits.each do |f|
            @mMutex["snake"].synchronize {
              @mSnake.move(@@maxX,@@maxY)
              h = @mSnake.getHeadPosition
            }
            p = f.getPosition
            if ( h[0] == p[0] ) && ( h[1] == p[1] )
              @mMutex[ "score" ].synchronize {
                @mScore+=5
              }
              return
            end
          end
        end
      }
      @mMutex[ "score" ].synchronize {
        @mScore+=5
      }
  end
  
  private init_map
  private draw_map
  private draw_header
  private draw_snake
  private draw_fruit
  private thread_map
  private thread_move
end