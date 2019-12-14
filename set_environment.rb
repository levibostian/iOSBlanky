#!/usr/bin/env ruby   

require 'trent'
require 'dotenv'
Dotenv.load('.env')

ci = Trent.new(:local => true)

ci.sh("bundle exec fastlane set_environment")
ci.sh("cp GoogleServices/#{ENV["GOOGLE_SERVICES_FILE_NAME"]} Src/GoogleService-Info.plist")