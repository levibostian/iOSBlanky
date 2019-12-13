#!/usr/bin/env ruby

require 'dotenv/load'
require 'trent'

ci = Trent.new(:local => true)

ci.sh("bundle update fastlane --minor")
ci.sh("git add Gemfile*")

ci.sh("./set_environment.rb")

ci.sh("./scripts/generate_license_credits.py -s \"#{File.expand_path("Pods/")}\" -o \"#{File.expand_path("#{ENV["SOURCE_CODE_DIRECTORY"]}/Settings.bundle/Credits.plist")}\"")
ci.sh("./Pods/SwiftFormat/CommandLineTool/swiftformat ./")

ci.sh("echo '########### NOTE #########'")
ci.sh("echo 'You may need to git add files that have been changed.'")