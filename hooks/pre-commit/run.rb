#!/usr/bin/env ruby

require 'dotenv/load'
require 'trent'

ci = Trent.new(:local => true)

ci.sh("bundle update fastlane --minor")
ci.sh("git add Gemfile*")

credits_file = File.expand_path("Src/Settings.bundle/Credits.plist")
ci.sh("./scripts/generate_license_credits.py -s \"#{File.expand_path("Pods/")}\" -o \"#{credits_file}\"")
ci.sh("git add #{credits_file}")