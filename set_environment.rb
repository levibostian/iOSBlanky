#!/usr/bin/env ruby   

require 'trent'
require 'dotenv'
Dotenv.load('.env')

ci = Trent.new(:local => true)

env_options = ["development", "production"]
envs = Hash.new 
envs[env_options[0]] = { :cici_args => "" }
envs[env_options[1]] = { :cici_args => "--set production" }

help = lambda { 
  puts "Usage: set_environment.rb [env]"
  puts "  env - Options: #{env_options.join(", ")}"
  exit 1
}

if ARGV.empty?
  help.call
end 

case ARGV[0]
when env_options[0]
  env = envs[env_options[0]]
when env_options[1]
  env = envs[env_options[1]]
else 
  help.call
end 

ci.sh("cici decrypt #{env[:cici_args]} --verbose")
ci.sh("bundle exec fastlane set_environment")
