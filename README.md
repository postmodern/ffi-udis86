# ffi-udis86

* [github.com/sophsec/ffi-udis86](http://github.com/sophsec/ffi-udis86/)
* [github.com/sophsec/ffi-udis86/issue](http://github.com/sophsec/ffi-udis86/)
* Postmodern (postmodern.mod3 at gmail.com)

## Description

Ruby FFI bindings for udis86, a x86 and x86-64 disassembler.

## Features

* Supports x86 and x86-64 instructions.
* Supports 16 and 32 disassembly modes.
* Supports Intel and ATT syntax output.
* Supports disassembling files and arbitrary input.
* Supports input callbacks.

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

## Requirements

* [udis86](http://udis86.sourceforge.net/) >= 1.7
* [ffi](http://github.com/ffi/ffi) >= 0.6.0

## Install

    $ sudo gem install ffi-udis86

## License

See {file:LICENSE.txt} for license information.

