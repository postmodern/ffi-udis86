# ffi-udis86

* [Source](https://github.com/postmodern/ffi-udis86/)
* [Issue](https://github.com/postmodern/ffi-udis86/)
* [Documentation](https://rubydoc.info/gems/ffi-udis86/)
* [Email](postmodern.mod3 at gmail.com)

## Description

{FFI::UDis86} provides Ruby FFI bindings for the [libudis86] library, a x86 and
x86-64 disassembler.

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

Read from a file:

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

* [Ruby](https://ruby-lang.org/) >= 2.0.0 or
  [JRruby](https://jruby.org) >= 1.6
* [udis86](https://udis86.sourceforge.net/) >= 1.7.2
* [ffi](https://github.com/ffi/ffi) ~> 1.0

## Install

    $ sudo gem install ffi-udis86

## Crystal

[udis86.cr] is a [Crystal][crystal-lang] port of this library.

[udis86.cr]: https://github.com/postmodern/udis86.cr#readme
[crystal-lang]: https://www.crystal-lang.org/

## License

See {file:LICENSE.txt} for license information.

[libudis86]: https://udis86.sourceforge.net/
