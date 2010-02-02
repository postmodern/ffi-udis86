# -*- ruby -*-

require 'rubygems'
require 'hoe'

Hoe.plugin :yard

Hoe.spec('ffi-udis86') do
  self.developer('Postmodern','postmodern.mod3@gmail.com')

  self.rspec_options += ['--colour', '--format', 'specdoc']

  self.yard_option += ['--protected']
  self.remote_yard_dir = ''
  self.extra_deps = [['ffi', '>=0.6.0']]

  self.extra_dev_deps = [
    ['rspec', '>=1.1.12'],
    ['yard', '>=0.4.0']
  ]
end

# vim: syntax=Ruby
