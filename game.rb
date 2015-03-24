#!/usr/bin/ruby

require "io/console"
require 'thread'
require './map'
  
r, c = IO.console.winsize
  
game = Map.new( c, r-3 )

game.map_release