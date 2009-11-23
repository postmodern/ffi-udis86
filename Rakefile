# -*- ruby -*-

require 'rubygems'
require 'hoe'
require './tasks/spec.rb'
require './tasks/yard.rb'

Hoe.spec('ffi-udis86') do
  self.rubyforge_name = 'ffi-udis86'
  self.developer('Postmodern','postmodern.mod3@gmail.com')
  self.remote_rdoc_dir = ''
  self.extra_deps = [['ffi', '>=0.4.0']]

  self.extra_dev_deps = [
    ['rspec', '>=1.1.12'],
    ['yard', '>=0.4.0']
  ]

  self.spec_extras = {:has_rdoc => 'yard'}
end

# vim: syntax=Ruby
