# -*- mode: ruby -*-

require 'bundler/setup'
require 'rubocop/rake_task'
require 'foodcritic'

# Style tests. Rubocop and Foodcritic
namespace :style do
  desc 'Run Ruby style checks'
  RuboCop::RakeTask.new(:ruby)

  desc 'Run Chef style checks'
  FoodCritic::Rake::LintTask.new(:chef) do |t|
    t.options = {
      fail_tags: ['any'],
    }
  end
end

desc 'Run all style checks'
task style: ['style:chef', 'style:ruby']

desc 'Runs knife cookbook test'
task :knife do
  sh 'bundle exec knife cookbook test appdynamics -o ../'
end

task default: [:style, :knife]
