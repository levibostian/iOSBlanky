# frozen_string_literal: true

source "https://rubygems.org"

git_source(:github) {|repo_name| "https://github.com/#{repo_name}" }

gem "trent", "~> 0.4.0"
gem "cocoacache", "~> 0.1.0"
gem 'fastlane', "~> 2.128.0"
plugins_path = File.join(File.dirname(__FILE__), 'fastlane', 'Pluginfile')
eval_gemfile(plugins_path) if File.exist?(plugins_path)

gem "danger-ios_version_change", "~> 0.1.6"
gem "danger", "~> 6.0.9"
gem "rest-client", "~> 2.0" # Required for "mailgun" fastlane action
gem "cocoapods", "~> 1.5"