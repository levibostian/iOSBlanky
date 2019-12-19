#!/usr/bin/env ruby   

require 'trent'
require 'dotenv'
Dotenv.load('.env')

ci = Trent.new(:local => true)

env_options = [:development, :beta, :production]
envs = Hash.new 
envs[:development] = { :cici_args => "" }
envs[:beta] = { :cici_args => "--set beta" }
envs[:production] = { :cici_args => "--set production" }

help = lambda { 
  puts "Usage: set_environment.rb [env]"
  puts "  env - Options: #{env_options.join(", ")}"
  exit 1
} 

case ARGV[0]
when env_options[0]
  env = envs[env_options[0]]
when env_options[1]
  env = envs[env_options[1]]
else 
  if !ENV["TRAVIS_TAG"].nil?
    env = ENV["TRAVIS_TAG"].end_with?("-beta") ? :beta : :production
    env = envs[env]
  else 
    help.call
  end 
end 

ci.sh("cici decrypt #{env[:cici_args]} --verbose")
ci.sh("bundle exec fastlane set_environment")
