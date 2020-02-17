require 'rubygems'

begin
  require 'bundler/setup'
rescue LoadError => error
  abort error.message
end

require 'rubygems/tasks'
Gem::Tasks.new

Dir['spec/fixtures/*.s'].each do |asm|
  bin = asm.chomp('.s')

  file bin => asm do |t|
    sh "yasm -f bin -m amd64 -o #{t.name} -p gas #{t.prerequisites.first}"
  end

  task 'spec:fixtures' => bin
end
task :spec => 'spec:fixtures'

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new
task :test => :spec
task :default => :spec

require 'yard'
YARD::Rake::YardocTask.new  
