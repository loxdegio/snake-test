include Fruit
include Snake
include Thread

class Map
  def initialize
    @@maxX=640
    @@maxY=480
    @mGrid=Array.new(@@maxX)
    for i in @mGrid do
      i=Array.new(@@maxY)
      end
    end
    @mGridThread = Thread.new { system("clear") 
                                print_map
                                sleep(1) }
    @mSnake=Snake.new(@@maxX,@@maxY)
    @mFruitsPresent = 0
    @mFruits=nil
    @mHeader=nil
    @mScore=0
  end
  
  def draw_map
    draw_header
    draw_snake
    if mFruitsPresent != 0
      draw_fruits
    end
  end
  
  def draw_header
    score = String.new
    for i in (1...625) do
      score.+(" ")
      end
    end
    score.+("SCORE ")
    if @mScore >= 0 &&  @mScore < 10
      for i in (1...8) do
        score.+("0")
      end
    else if @mScore >= 10 &&  @mScore < 100
      for i in (1...7) do
        score.+("0")
      end 
    else if @mScore >= 100 &&  @mScore < 1000
      for i in (1...6)
        score.+("0")
      end
    else if @mScore >= 1000 &&  @mScore < 10000
      for i in (1...5)
        score.+("0")
      end
    else if @mScore >= 10000 &&  @mScore < 100000
      for i in (1...4)
        score.+("0")
      end
    else if @mScore >= 100000 &&  @mScore < 1000000
      for i in (1...3)
          score.+("0")
      end
    else if @mScore >= 1000000 &&  @mScore < 10000000
      for i in (1...2)
        score.+("0")
      end
    else if @mScore >= 1000000 &&  @mScore < 10000000
      score.+("0")
    else if @mScore >= 999999999
      system("clear")
      puts "YOU WIN!!"
    end
    score.+(@mScore)
    @mHeader=score
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
    puts @mScore
    @Grid.each do |row|
      puts row
    end
  end
  
  def thread_map
    draw_map
    print_map
  end
end