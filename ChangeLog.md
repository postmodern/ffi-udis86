### 0.1.3 / 2012-05-11

* Require ffi ~> 1.0.
* Load `libudis86.so.0` if `libudis86.so` does not exist.
* Temporarily drop support for Rubinius due to [missing FFI::Union](https://github.com/rubinius/rubinius/issues/1717).

### 0.1.2 / 2011-02-02

* Opted into gem-tester.org.
* Require ffi >= 0.6.0 and <= 1.1.0.
  * JRuby requires ffi >= 1.0.0.
  * A lot of projects still require ~> 0.6.0.
* Fixed typos in the YARD Documentation.

### 0.1.1 / 2010-11-06

* Added an external requirement for udis86 >= 1.7.
* Renamed `udis86.rb` to `ffi/udis86.rb`.
  * Kept `udis86.rb` for backwards compatibility.
* Fixed failing specs on JRuby.
* Clarified documentation for {FFI::UDis86::Operand#base} and
  {FFI::UDis86::Operand#index}.

### 0.1.0 / 2010-02-19

* Initial release:
  * Supports x86 and x86-64 instructions.
  * Supports 16 and 32 disassembly modes.
  * Supports Intel and ATT syntax output.
  * Supports disassembling files and arbitrary input.
  * Supports using input buffers.
  * Supports using input callbacks.

