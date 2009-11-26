require 'spec/rake/spectask'

desc "Run all specifications"
Spec::Rake::SpecTask.new(:spec) do |t|
  t.libs += ['lib', 'spec']
  t.spec_opts = ['--colour', '--format', 'specdoc']
end

task :test => :spec
task :default => :spec

namespace :spec do
  namespace :helpers do
    def yasm(src,dest)
      sh "yasm -p gas #{src} -o #{dest}"
    end

    def yasm_file(src,dest=src.gsub(/\.s$/,'.o'))
      file dest => [src] do
        yasm(src,dest)
      end
    end

    yasm_file 'spec/helpers/files/simple.s'
    yasm_file 'spec/helpers/files/operands_simple.s'

    task :files => [
      'spec/helpers/files/simple.o',
      'spec/helpers/files/operands_simple.o'
    ]
  end
end

task :spec => ['spec:helpers:files']
