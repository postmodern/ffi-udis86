require 'rubygems'
require 'rake'
require './lib/udis86/version.rb'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = 'ffi-udis86'
    gem.version = FFI::UDis86::VERSION
    gem.summary = %Q{Ruby FFI bindings for udis86, a x86 and x86-64 disassembler.}
    gem.description = %Q{Ruby FFI bindings for udis86, a x86 and x86-64 disassembler.}
    gem.email = 'postmodern.mod3@gmail.com'
    gem.homepage = 'http://github.com/sophsec/ffi-udis86'
    gem.authors = ['Postmodern']
    gem.add_dependency 'ffi', '>= 0.6.2'
    gem.add_development_dependency 'rspec', '>= 1.3.0'
    gem.add_development_dependency 'yard', '>= 0.5.3'
    gem.has_rdoc = 'yard'
  end
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.libs += ['lib', 'spec']
  spec.spec_files = FileList['spec/**/*_spec.rb']
  spec.spec_opts = ['--options', '.specopts']
end

task :spec => :check_dependencies
task :default => :spec

begin
  require 'yard'

  YARD::Rake::YardocTask.new
rescue LoadError
  task :yard do
    abort "YARD is not available. In order to run yard, you must: gem install yard"
  end
end
