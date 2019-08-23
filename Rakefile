require 'rake'
require 'rspec/core/rake_task'

task :spec    => 'spec:all'
task :default => :spec

namespace :spec do
  RSpec::Core::RakeTask.new(:all) do |tests|
    tests.pattern = './spec/*_spec.rb'
  end
end

