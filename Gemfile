# frozen_string_literal: true

source "https://rubygems.org"

# be able to generate Environment swift file
gem "dotenv-ios", "~> 0.1.2"
gem "dotenv"

# Don't add fastlane to this file. We want to try and keep fastlane to only needing to be installed on the CI server as it needs updating often (if you install newest version on CI server always, it works better), it's used for running tests/building/deploy app on CI server so no need for it locally. If you need to use it locally, install it globally by using `gem install fastlane`

plugins_path = File.join(File.dirname(__FILE__), 'fastlane', 'Pluginfile')
eval_gemfile(plugins_path) if File.exist?(plugins_path)
