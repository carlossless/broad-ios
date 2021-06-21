source 'https://rubygems.org'

group :development do
    gem "synx"
end

gem "fastlane"
gem "slather"
gem "nokogiri", ">= 1.11.0" # CVE-2019-5477

plugins_path = File.join(File.dirname(__FILE__), 'fastlane', 'Pluginfile')
eval_gemfile(plugins_path) if File.exist?(plugins_path)
