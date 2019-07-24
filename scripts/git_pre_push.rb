require 'trent'

ci = Trent.new(:local => true)

ci.sh("./Pods/SwiftLint/swiftlint --strict")
ci.sh("./scripts/localized_strings_lint.sh")