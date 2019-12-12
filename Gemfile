# frozen_string_literal: true

source "https://rubygems.org"

git_source(:github) {|repo_name| "https://github.com/#{repo_name}" }

gem "trent", "~> 0.5.0"
gem 'fastlane'
plugins_path = File.join(File.dirname(__FILE__), 'fastlane', 'Pluginfile')
eval_gemfile(plugins_path) if File.exist?(plugins_path)

gem "danger-ios_version_change", "~> 0.1.6"
gem "danger", "~> 6"
gem "danger-swiftformat", "~> 0.5.0"
gem "danger-swiftlint", "~> 0.22.0"
gem "dotenv", "~> 2.7"

gem "danger-junit", "~> 1.0"

gem "dotenv-ios", "~> 0.1.1"
