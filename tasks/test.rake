# frozen_string_literal: true

require 'rspec/core/rake_task'

namespace :test do
  desc 'Run all tests'
  RSpec::Core::RakeTask.new(:all) do |t|
    t.pattern = '../spec/**/*_spec.rb'
  end

  desc 'Run tests and generate coverage report'
  task :coverage do
    ENV['COVERAGE'] = 'true'
    Rake::Task['test:all'].invoke
  end
end

desc 'Run all tests'
task test: 'test:all'
