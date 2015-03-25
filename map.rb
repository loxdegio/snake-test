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
      @speed=0.1
      @mSnake=Snake.new(@mMaxX,@mMaxY-1)
      @mFruitsPresent = 1
      @mFruits= [ Fruit.new(rand(@mMaxX),rand(@mMaxY-1)) ]
      @mScore=0
      @mDir=0
      @mLegend = String.new("Legenda:  SNAKE = *   FRUTTA = #   MOVES: W = up  S = down  A = left  D = right")
      @mMutex= Mutex.new
      @mThreads = { "map"       =>  Thread.new { thread_map  },
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
  
  def exit_snake(end_reason = "Exit",thread = "map")
    clear_win
    @mWindow.box("|", "-") # border
    @mWindow.setpos(4, 4)
    @mWindow.addstr(end_reason)
    @mThreads.each do |k,t|
      unless k == thread
        Thread.kill(t)
        t.join
      end
    end
    sleep(5)
    @mEnd = true
  end
  
  def print_header
    s = @mScore
    if @mScore < 999999999
      score = String.new("SCORE ".+(s.to_s))
      score
    else
      exit_snake("YOU WIN!","map")
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
        @mWindow.setpos(i,j)        
        if draw_snake(j,i)==true
            @mWindow.addstr("*")
        elsif draw_fruit(j,i)==true
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
        move
      }
      sleep(@speed)
    end
  end
  
  def fruit_eaten(x = 0, y = 0)
    @mFruits.each do |f|
      if f.get_x == x && f.get_y == y
        f.teleport(rand(@mMaxX),rand(@mMaxY-2)+1)
      end  
    end
  end
  
  def move
        lastScore = @mScore
        @mSnake.move(@mMaxX,@mMaxY-1)
        if @mFruitsPresent > 0
          @mFruits.each do |f|
            h = @mSnake.get_head_position
            if h.get_x == f.get_x && h.get_y == f.get_y
              if @mSnake.eat_fruit
                exit_snake("YOU WIN!","movement")
              end
              fruit_eaten(f.get_x,f.get_y)
              @mScore+=5  
              break
            end
          end
        elsif @mSnake.collision
          exit_snake("YOU LOSE!","movement") 
        end
        unless (@mScore - lastScore) == 5
          @mScore+=1
        end
  end
  
  def set_dir
    d = @mDir
    changed = false
    e1 = (d == 1 || d == 3)
    e2 = (d == 0 || d == 2)
    case Curses.getch
      when 'a'
        if e1
          @mDir = 0
          changed = true
        end
      when 'w'
        if e2
          @mDir = 1
          changed = true
        end
      when 'd'
        if e1  
          @mDir = 2
          changed = true
        end
      when 's'
        if e2
          @mDir = 3
          changed = true
        end
      when 'q'
        exit_snake("You press (Q)uit button","turn")
    end
    changed
  end
  
  def thread_turn
    loop do
      @mMutex.synchronize {
        if set_dir
          @mSnake.set_direction(@mDir)
        end
      }
      sleep(@speed)
    end
  end
  
end