#!/usr/bin/env ruby

require  'io/wait'
require  'thread'
require  'curses'

require './fruit'
require './snake'

class Map
  
    def initialize
      @mMaxX = Curses.cols
      @mMaxY = Curses.lines
      @mWindow = Window.new(@mMaxY, @mMaxX, 0, 0)
      clear_win   
      @speed=0.5
      @mSnake=Snake.new(@mMaxX,@mMaxY-1)
      @mFruitsPresent = 0
      @mFruits=[]
      @mScore=0
      @mDir=0
      @mLegend = String.new("Legenda:  SNAKE = *   FRUTTA = #\n")
      @mMutex= Mutex.new
      @mThreads = { "map"       =>  Thread.new { thread_map  },
                    "movement"  =>  Thread.new { thread_move },
                    "turn"      =>  Thread.new { thread_turn } }
                      
      @mEnd = false
    end
    
  def end
      @mEnd
  end
  
  def map_release
    @mThreads.each do |k,t|
      Thread.kill(t)
      t.join
    end
  end
  
  private
  
  def exit_snake(end_reason)
    Thread.kill(@mThreads["map"])
    clear_win
    @mWindow.box("|", "-") # border
    @mWindow.setpos(4, 4)
    @mWindow.addstr(end_reason)
    sleep(3)
    @mEnd = true
  end
  
  def print_header
    s = @mScore
    if @mScore < 999999999
      score = String.new("SCORE ".+(s.to_s))
      score
    else
      exit_snake("YOU WIN!")
    end
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
    @mWindow.setpos(0,0)
    @mWindow.addstr(print_header)
    i=1
    while i<@mMaxY-1
      j=0
      while j<@mMaxX        
        if draw_snake(j,i)==true
          @mWindow.setpos(i,j)
          @mWindow.addstr("*")
        elsif draw_fruit(j,i)==true
          @mWindow.setpos(i,j)
          @mWindow.addstr("#")
        end
      j+=1
      end
      i+=1
    end
    @mWindow.setpos(@mMaxY-1,0)
    @mWindow.addstr(@mLegend)       
  end
  
  def clear_win
    @mWindow.refresh
    @mWindow.clear
  end
  
  def thread_map
    loop do
      clear_win
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
        @mSnake.move(@mMaxX,@mMaxY-1)
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
  
  def set_dir
    d = @mDir
    c = Curses.getch
    case c
      when 'a'
        @mDir = 0
      when 'w'
        @mDir = 1
      when 'd'
        @mDir = 2
      when 's'
        @mDir = 3
      when 'q'
        exit_snake("You press (Q)uit button")
    end
  end
  
  def thread_turn
    loop do
      set_dir
      @mMutex.synchronize {
        @mSnake.set_direction(@mDir)
      }
    end
  end
  
end