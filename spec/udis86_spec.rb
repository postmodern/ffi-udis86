require 'spec_helper'

require 'ffi/udis86'

describe FFI::UDis86 do
  it "should have a VERSION constant" do
    expect(described_class.const_defined?('VERSION')).to eq(true)
  end
end
