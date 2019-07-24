# ------------- Edit variables -----------------
source_code_subdirectory = "iOSBlanky"
# ----------------------------------------------

require 'trent'

ci = Trent.new(:local => true)

ci.sh("./scripts/generate_license_credits.py --source #{File.expand_path("Pods/")} --output-plist ../#{source_code_subdirectory}/Settings.bundle/Credits.plist")
ci.sh("./Pods/SwiftFormat/CommandLineTool/swiftformat ./")
ci.sh("git add .")