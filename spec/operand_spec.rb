require 'spec_helper'

require 'ffi/udis86/operand'
require 'ffi/udis86/ud'

describe FFI::UDis86::Operand do
  it "should provide the type of the operand" do
    operands = ud_operands('operands_simple')

    expect(operands[0].type).to eq(:ud_op_reg)
    expect(operands[1].type).to eq(:ud_op_imm)
  end

  it "should provide the size of the operand" do
    operands = ud_operands('operands_simple')

    expect(operands[1].size).to be == 32
  end

  it "should provide the value of the operand" do
    operands = ud_operands('operands_simple')

    expect(operands[1].value.signed_byte).to be == 0x10
    expect(operands[1].value.unsigned_byte).to be == 0x10
  end

  it "should specify value as nil for register operands" do
    operands = ud_operands('operands_simple')

    expect(operands[0].value).to be_nil
  end

  it "should provide the base of memory operands" do
    operands = ud_operands('operands_memory')

    expect(operands[1].type).to be(:ud_op_mem)
    expect(operands[1][:base]).to be(:ud_r_esp)
    expect(operands[1].base).to be(:esp)
  end

  it "should provide the index of memory operands" do
    operands = ud_operands('operands_index_scale')

    expect(operands[1].type).to be(:ud_op_mem)
    expect(operands[1][:index]).to be(:ud_r_eax)
    expect(operands[1].index).to be(:eax)
  end

  it "should provide the offset of memory operands" do
    operands = ud_operands('operands_offset')

    expect(operands[1].type).to be(:ud_op_mem)
    expect(operands[1].offset.byte).to be == 0x10
  end

  it "should provide the scale of memory operands" do
    operands = ud_operands('operands_index_scale')

    expect(operands[1].type).to be(:ud_op_mem)
    expect(operands[1].scale).to be == 2
  end

  it "should provide the register name for register operands" do
    operands = ud_operands('operands_simple')

    expect(operands[0][:base]).to be(:ud_r_eax)
    expect(operands[0].reg).to be(:eax)
  end
end
