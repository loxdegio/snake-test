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
      srand
      @mFruits= [ Fruit.new(rand(@mMaxX),rand(@mMaxY-1)) ]
      @mScore=0
      @mDir=0
      @mLegend = String.new("Legenda:  SNAKE = *   FRUTTA = #   MOVES: W = up  S = down  A = left  D = right")
      @mMutex= Mutex.new
      @mThreads = { "map"       =>  Thread.new { thread_map  },
                    "turn"      =>  Thread.new { thread_turn },
                    "pause"     =>          nil               ,
                    "exit"      =>          nil                }
                      
      @mEnd = false
      @paused = false
    end
    
  def end?
      @mEnd
  end
  
  def map_release
    @mThreads.each do |k,t|
      unless t == nil
        Thread.kill(t)
        t.join
      end
    end
  end
  
  private
  
  def exit_snake(end_reason = "Exit",thread = "map")
    @mThreads.each do |k,t|
      unless k == thread || t == nil
        Thread.kill(t)
      end
    end
    @mThreads["exit"] = Thread.new(end_reason){ |msg| thread_exit(msg) }
    @mThreads[thread].kill
  end
  
  def thread_exit(end_reason)
    i=0
    while i<8
      clear_win
      @mWindow.box("|", "-") # border
      cy=(@mMaxY/2).to_i; cx=(@mMaxX/2).to_i; cx-=(end_reason.length/2).to_i; cx-=1
      @mWindow.setpos(cy-1,cx)
      @mWindow.addstr(end_reason)
      msg = "Exiting"
      cx=(@mMaxX/2).to_i; cx-=(msg.length/2).to_i; cx-=1
      @mWindow.setpos(cy+1,cx)
      @mWindow.addstr(msg.+("..."))
      i+=1
      sleep(@speed)
    end
    sleep(4.2)
    @mEnd = true
    exit
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
          @mWindow.addstr("@")
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
    srand
    @mFruits.each do |f|
      if f.get_x == x && f.get_y == y
        f.teleport(rand(@mMaxX),rand(@mMaxY-2)+1)
      end  
    end
  end
  
  def move
        lastScore = @mScore
        @mSnake.move(@mMaxX,@mMaxY-1)
        if @mSnake.collision
          exit_snake("YOU LOSE! ".+(print_header),"map") 
        end
        if @mFruitsPresent > 0
          @mFruits.each do |f|            
            if @mSnake.is_head_in(f.get_x,f.get_y)
              if @mSnake.eat_fruit
                exit_snake("YOU WIN! ".+(print_header),"map")
              end
              fruit_eaten(f.get_x,f.get_y)
              @mScore+=5  
              break
            end
          end
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
        if e1 && !changed
          @mDir = 0
          changed = true
        end
      when 'w'
        if e2 && !changed
          @mDir = 1
          changed = true
        end
      when 'd'
        if e1 && !changed 
          @mDir = 2
          changed = true
        end
      when 's'
        if e2 && !changed
          @mDir = 3
          changed = true
        end
      when 'q'
        exit_snake("You pressed (Q)uit button","turn")
      when 'p'
        if @paused == false
          @mThreads["pause"] = Thread.new { thread_pause }
          @mThreads["map"].kill
          @paused = true
        else
          @mThreads["pause"].kill
          @mThreads["map"] = Thread.new { thread_map }
          @paused = false
        end
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
  
  def thread_pause()
    loop do
      clear_win
      @mWindow.box("|", "-") # border
      cy=(@mMaxY/2).to_i; cx=((@mMaxX/2).to_i)-3
      @mWindow.setpos(cy,cx)
      @mWindow.addstr("PAUSE")
      sleep(1)  
    end
  end
  
end