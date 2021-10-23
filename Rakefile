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
    sh "yasm -f bin -a x86 -m x86 -o #{t.name} -p gas #{t.prerequisites.first}"
  end

  task 'spec:fixtures' => bin
end
task :spec => 'spec:fixtures'

require 'rake/clean'
CLEAN.include(
  %w[
      spec/fixtures/operands_index_scale
      spec/fixtures/operands_memory
      spec/fixtures/operands_offset
      spec/fixtures/operands_simple
      spec/fixtures/simple
  ]
)

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new
task :test => :spec
task :default => :spec

require 'yard'
YARD::Rake::YardocTask.new  
