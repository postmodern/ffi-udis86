require 'ffi/udis86/operand'
require 'ffi/udis86/ud'

require 'spec_helper'
require 'helpers/operands'

describe Operand do
  include Helpers

  it "should provide the type of the operand" do
    operands = ud_operands('operands_simple')

    expect(operands[0].type).to eq(:ud_op_reg)
    expect(operands[1].type).to eq(:ud_op_imm)
  end

  it "should provide the size of the operand" do
    operands = ud_operands('operands_simple')

    expect(operands[1].size).to eq(32)
  end

  it "should provide the value of the operand" do
    operands = ud_operands('operands_simple')

    expect(operands[1].value.signed_byte).to eq(0x10)
    expect(operands[1].value.unsigned_byte).to eq(0x10)
  end

  it "should specify value as nil for register operands" do
    operands = ud_operands('operands_simple')

    expect(operands[0].value).to be_nil
  end

  it "should provide the base of memory operands" do
    operands = ud_operands('operands_memory')

    expect(operands[1].type).to eq(:ud_op_mem)
    expect(operands[1][:base]).to eq(:ud_r_esp)
    expect(operands[1].base).to eq(:esp)
  end

  it "should provide the index of memory operands" do
    operands = ud_operands('operands_index_scale')

    expect(operands[1].type).to eq(:ud_op_mem)
    expect(operands[1][:index]).to eq(:ud_r_eax)
    expect(operands[1].index).to eq(:eax)
  end

  it "should provide the offset of memory operands" do
    operands = ud_operands('operands_offset')

    expect(operands[1].type).to eq(:ud_op_mem)
    expect(operands[1].offset.byte).to eq(0x10)
  end

  it "should provide the scale of memory operands" do
    operands = ud_operands('operands_index_scale')

    expect(operands[1].type).to eq(:ud_op_mem)
    expect(operands[1].scale).to eq(2)
  end

  it "should provide the register name for register operands" do
    operands = ud_operands('operands_simple')

    expect(operands[0][:base]).to eq(:ud_r_eax)
    expect(operands[0].reg).to eq(:eax)
  end
end
