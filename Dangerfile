# File for the Danger bot: https://danger.systems/ruby/
# Used to inspect pull requests for us to prevent issues. 
require 'dotenv/load'

ReleaseFile = Struct.new(:relative_file_path, :warn_or_fail, :deployment_instruction)

$source_code_location = ENV["SOURCE_CODE_DIRECTORY"]
$info_plist_location = "#{$source_code_location}/Info.plist"
$files_to_update_for_releases = [ # we will also check the version changed in Info.plist. Don't include here. 
  # Edit your Info.plist 
  ReleaseFile.new('CHANGELOG.md', 'fail', "Add a new changelog entry detailing for future developers what has been done in the app."),
  ReleaseFile.new('demo_list.txt', 'warn', "Add a new entry describing the demo that you created for this release. If no demo to show, say so in the file."),
  ReleaseFile.new('fastlane/release_notes.txt', 'fail', "Write the public release notes that will be shown in TestFlight and the App Store."),
  ReleaseFile.new('fastlane/latest_demo.txt', 'fail', "Create demo and put notes in there. If no demo to show, say so.")
]

$deployment_instructions = [
  "#{$info_plist_location}: Edit the version number to the new version of your app. Do not worry about changing the build number."
]
$deployment_instructions += $files_to_update_for_releases.map { |release_file| "#{release_file.relative_file_path}: #{release_file.deployment_instruction}" }

def determineIfRelease
  num_files_updated = 0

  $files_to_update_for_releases.each { |release_file_array|
    release_file_relative_path = release_file_array[0]
    release_file_warn_or_fail = release_file_array[1]

    if git.diff_for_file(release_file_relative_path) 
      if num_files_updated == 0        
        message "🚀 I am going to assume that this *is a release* pull request because you have edited a file that would be updated for releases. 🚀"
        ios_version_change.assert_version_changed($info_plist_location)
      end 

      num_files_updated += 1
    else
      if release_file_warn_or_fail == 'warn'
        warn "You did not update #{release_file_relative_path}"
      else 
        fail "You did not update #{release_file_relative_path}"
      end 
    end 
  }

  if num_files_updated == 0
    message "I am going to assume that this is *not* a release pull request."
  end 
end 

if ENV["CI"]   
  swiftformat.binary_path = "Pods/SwiftFormat/CommandLineTool/swiftformat"
  swiftformat.check_format(fail_on_error: true)

  swiftlint.binary_path = 'Pods/SwiftLint/swiftlint'
  swiftlint.lint_files fail_on_error: true
  swiftlint.config_file = '.swiftlint.yml'
  swiftlint.max_num_violations = 0

  junit.parse "reports/report.junit"
  junit.show_skipped_tests = true
  if junit.failures.empty?
    message("#{junit.passes.length} tests passed!")
  else 
    junit.report
  end

  if github.branch_for_base == "master"
    if !(github.pr_title + github.pr_body).include?("#non-release")
      determineIfRelease()
    end
  end
else 
  puts "It looks like you are looking for instructions on how to deploy your app, huh? Well, edit these files with these instructions: \n\n"
  puts $deployment_instructions  
end 

