#!/usr/bin/env ruby

require 'trent'

ci = Trent.new(:local => true)

ci.sh("pod install")