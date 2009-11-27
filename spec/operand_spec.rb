require 'udis86/operand'
require 'udis86/ud'

require 'spec_helper'
require 'helpers/operands'

describe Operand do
  include Helpers

  it "should provide the type of the operand" do
    operands = ud_operands('operands_simple')

    operands[0].type.should == :ud_op_reg
    operands[1].type.should == :ud_op_imm
  end

  it "should provide the size of the operand" do
    operands = ud_operands('operands_simple')

    operands[1].size.should == 32
  end

  it "should provide the value of the operand" do
    operands = ud_operands('operands_simple')

    operands[1].value.signed_byte.should == 0x10
    operands[1].value.unsigned_byte.should == 0x10
  end

  it "should specify value as nil for register operands" do
    operands = ud_operands('operands_simple')

    operands[0].value.should be_nil
  end

  it "should provide the base of memory operands" do
    operands = ud_operands('operands_memory')

    operands[1].type.should == :ud_op_mem
    operands[1].base.should == :esp
  end

  it "should provide the index of memory operands" do
    operands = ud_operands('operands_index_scale')

    operands[1].type.should == :ud_op_mem
    operands[1].index.should == :eax
  end

  it "should provide the offset of memory operands" do
    operands = ud_operands('operands_offset')

    operands[1].type.should == :ud_op_mem
    operands[1].offset.byte.should == 0x10
  end

  it "should provide the scale of memory operands" do
    operands = ud_operands('operands_index_scale')

    operands[1].type.should == :ud_op_mem
    operands[1].scale.should == 2
  end

  it "should provide the register name for register operands" do
    operands = ud_operands('operands_simple')

    operands[0].reg.should == :eax
  end
end
