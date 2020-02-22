require 'spec_helper'

require 'ffi/udis86'

describe FFI::UDis86 do
  it "should have a VERSION constant" do
    expect(described_class.const_defined?('VERSION')).to eq(true)
  end

  describe "types" do
    it "should define syntices" do
      expect(described_class::SYNTAX[:att]).to eq(:ud_translate_att)
      expect(described_class::SYNTAX[:intel]).to eq(:ud_translate_intel)
    end
  end
end
