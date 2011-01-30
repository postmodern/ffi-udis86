# ffi-udis86

* [Source](http://github.com/sophsec/ffi-udis86/)
* [Issue](http://github.com/sophsec/ffi-udis86/)
* Postmodern (postmodern.mod3 at gmail.com)

## Description

Ruby FFI bindings for udis86, a x86 and x86-64 disassembler.

## Features

* Supports x86 and x86-64 instructions.
* Supports 16 and 32 disassembly modes.
* Supports Intel and ATT syntax output.
* Supports disassembling files and arbitrary input.
* Supports using input buffers.
* Supports using input callbacks.
* Supports fully disassembling instructions and operands.

## Examples

Create a new disassembler:

    include FFI::UDis86
    
    ud = UD.create(:syntax => :att, :mode => 64)

Set the input buffer:

    ud.input_buffer = "\x90\x90\xc3"

Add an input callback:

    ud.input_callback { |ud| ops.shift || -1 }

Read a file:

    UD.open(path) do |ud|
      ...
    end

Disassemble and print instructions:

    ud.disas do |insn|
      puts insn
    end

Disassemble and print information about the instruction and operands:

    asm = "\x75\x62\x48\x83\xc4\x20\x5b\xc3\x48\x8d\x0d\x23\x0c\x01\x00\x49\x89\xf0"
    
    ud = FFI::UDis86::UD.create(
      :buffer => asm,
      :mode => 64,
      :vendor => :amd,
      :syntax => :att
    )
    
    ud.disas do |insn|
      puts insn
      puts "  * Offset: #{insn.insn_offset}"
      puts "  * Length: #{insn.insn_length}"
      puts "  * Mnemonic: #{insn.mnemonic}"
    
      operands = insn.operands.reverse.map do |operand|
        if operand.is_mem?
          ptr = [operand.base]
          ptr << operand.index if operand.index
          ptr << operand.scale if operand.scale
    
          "Memory Access (#{ptr.join(',')})"
        elsif operand.is_imm?
          'Immediate Data'
        elsif operand.is_jmp_imm?
          'Relative Offset'
        elsif operand.is_const?
          'Constant'
        elsif operand.is_reg?
          "Register (#{operand.reg})"
        end
      end
    
      puts '  * Operands: ' + operands.join(' -> ')
    end

## Requirements

* [udis86](http://udis86.sourceforge.net/) >= 1.7
* [ffi](http://github.com/ffi/ffi) ~> 0.6.0, ~> 1.0.0

## Install

    $ sudo gem install ffi-udis86

## License

See {file:LICENSE.txt} for license information.

