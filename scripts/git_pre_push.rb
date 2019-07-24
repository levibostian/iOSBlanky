require 'trent'

ci = Trent.new(:local => true)

ci.sh("./Pods/SwiftLint/swiftlint --strict")
ci.sh("./scripts/localized_strings_lint.sh")
ci.sh("./scripts/generate_license_credits.py --source #{File.expand_path("Pods/")} --output-plist ../#{ENV["SOURCE_CODE_SUBDIRECTORY"]}/Settings.bundle/Credits.plist")
ci.sh("git add .")