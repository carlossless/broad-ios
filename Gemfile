source 'https://rubygems.org'

group :development do
    gem "synx"
end

gem "fastlane"
gem "slather"

plugins_path = File.join(File.dirname(__FILE__), 'fastlane', 'Pluginfile')
eval_gemfile(plugins_path) if File.exist?(plugins_path)
