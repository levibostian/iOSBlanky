require 'trent'
require 'dotenv'
Dotenv.load(".env")

ci = Trent.new(:local => true)
ci.config_github(ENV['DANGER_GITHUB_API_TOKEN'])

def upload_results(dirname, test_type, test_results_local_path, index_html_file)
  remote_results_path = "/#{ENV["AWS_S3_BUCKET_PATH_TEST_RESULTS"]}/#{ENV['TRAVIS_REPO_SLUG']}/#{ENV['TRAVIS_BUILD_NUMBER']}/#{ENV['TRAVIS_JOB_NUMBER']}/#{dirname}"

  ci.sh("curl -o- https://raw.githubusercontent.com/levibostian/ci-bootstrap/master/aws/s3-upload.sh | AWS_ACCESS_KEY_ID=#{ENV["AWS_IAM_ACCESS_KEY"]} AWS_SECRET_ACCESS_KEY=#{ENV["AWS_IAM_ACCESS_SECRET"]} BUCKET_NAME=#{ENV["AWS_S3_BUCKET_NAME_TEST_RESULTS"]} BUCKET_PATH=#{remote_results_path} UPLOAD_PATH=#{test_results_local_path} REGION=#{ENV["AWS_REGION"]} bash")

  s3_website_host_url = "http://#{ENV["AWS_S3_BUCKET_NAME_TEST_RESULTS"]}.s3-website-#{ENV["AWS_REGION"]}.amazonaws.com"
  tests_results_url = "#{s3_website_host_url}#{remote_results_path}/#{index_html_file}"
  tests_message = "#{test_type} results [available to view](#{tests_results_url})! Files will be deleted in 14 days."

  ci.github.comment(tests_message)
end 

# Unit/integration tests
ci.sh("bundle exec fastlane scan --scheme Tests --output_directory reports/unit_tests/", :fail_non_success => false)
upload_results("unit_tests", "Unit/integration tests", "reports/unit_tests/", "index.html")

# UI tests
ci.sh("bundle exec fastlane scan --scheme UITests --output_directory reports/ui_tests/", :fail_non_success => false)
upload_results("ui_tests", "UI tests", "reports/ui_tests/", "index.html")

# Screenshots 
ci.sh("fastlane frameit download_frames")
ci.sh("cp fastlane/frameit_files/* fastlane/screenshots/") # .gitignore has fastlane screenshots. These files are required to be in that folder. 
ci.sh("bundle exec fastlane take_screenshots", :fail_non_success => false)
upload_results("screenshots", "Screenshots", "fastlane/screenshots/", "screenshots.html")

