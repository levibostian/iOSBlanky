#!/usr/bin/env ruby

require 'dotenv/load'
require 'trent'

ci = Trent.new(:local => true)

ci.sh("bundle update fastlane --minor")
ci.sh("git add Gemfile*")

ci.sh("./scripts/generate_license_credits.py -s \"#{File.expand_path("Pods/")}\" -o \"#{File.expand_path("#{ENV["SOURCE_CODE_DIRECTORY"]}/Settings.bundle/Credits.plist")}\"")