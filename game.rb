#!/usr/bin/ruby

require 'curses'
require 'io/console'
require './map'

include Curses


init_screen
cbreak
noecho                      #does not show input of getch
stdscr.nodelay = 1          #the getch doesn't system_pause while waiting for instructions
#stdscr.keypad(true)         #enable arrow keys
curs_set(0)                 #the cursor is invisible.

begin
  
  game = Map.new

  while !game.end 
  end
  
  ensure
    
  game.map_release
  
  close_screen
end