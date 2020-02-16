require 'rspec'
require 'ffi/udis86/version'

include FFI
include FFI::UDis86

module Helpers
  FIXTURES_DIR = File.expand_path("../fixtures",__FILE__)

  def fixture_path(path)
    File.join(FIXTURES_DIR,path.to_s)
  end

  def ud_file(name,&block)
    FFI::UDis86::UD.open(fixture_path(name),&block)
  end

  def ud_operands(name)
    ud_file(name) do |ud|
      ud.next_insn

      return ud.operands
    end
  end
end

RSpec.configure do |c|
  c.include Helpers
end
