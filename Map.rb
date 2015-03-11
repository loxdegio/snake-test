include Fruit
include Snake

class Map
  def initialize
    @@maxX=640
    @@maxY=480
    @grid=Array.new(maxY)
    for i in @grid do
      i=Array.new(maxX)
    end
    @snake=Snake.new(maxX,maxY)
    @nFruits = 0
    @nFruits=nil
  end
  
  
end