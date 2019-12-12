#!/usr/bin/env ruby   

require 'trent'
require 'dotenv'
Dotenv.load('.env')

ci = Trent.new(:local => true)

ci.sh("bundle exec dotenv-ios --source #{ENV["SOURCE_CODE_DIRECTORY"]}")
ci.sh("bundle exec fastlane set_environment")