require 'ffi'

module FFI
  module UDis86
    extend FFI::Library

    enum :ud_mode, [
      :ud_mode_16, 16,
      :ud_mode_32, 32,
      :ud_mode_64, 64
    ]

    enum :ud_vendor, [:amd, :intel]

    enum :ud_type, [
      :ud_none,
      #
      # 8 bit GRPs
      #
      :ud_r_al,
      :ud_r_cl,
      :ud_r_dl,
      :ud_r_bl,
      :ud_r_ah,
      :ud_r_ch,
      :ud_r_dh,
      :ud_r_bh,
      :ud_r_spl,
      :ud_r_bpl,
      :ud_r_sil,
      :ud_r_dil,
      :ud_r_r8b,
      :ud_r_r9b,
      :ud_r_r10b,
      :ud_r_r11b,
      :ud_r_r12b,
      :ud_r_r13b,
      :ud_r_r14b,
      :ud_r_r15b,
      #
      # 16 bit GRPs
      #
      :ud_r_ax,
      :ud_r_cx,
      :ud_r_dx,
      :ud_r_bx,
      :ud_r_sp,
      :ud_r_bp,
      :ud_r_si,
      :ud_r_di,
      :ud_r_r8w,
      :ud_r_r9w,
      :ud_r_r10w,
      :ud_r_r11w,
      :ud_r_r12w,
      :ud_r_r13w,
      :ud_r_r14w,
      :ud_r_r15w,
      #
      # 32 bit GRPs
      #
      :ud_r_eax,
      :ud_r_ecx,
      :ud_r_edx,
      :ud_r_ebx,
      :ud_r_esp,
      :ud_r_ebp,
      :ud_r_esi,
      :ud_r_edi,
      :ud_r_r8d,
      :ud_r_r9d,
      :ud_r_r10d,
      :ud_r_r11d,
      :ud_r_r12d,
      :ud_r_r13d,
      :ud_r_r14d,
      :ud_r_r15d,
      #
      # 64 bit GRPs
      #
      :ud_r_rax,
      :ud_r_rcx,
      :ud_r_rdx,
      :ud_r_rbx,
      :ud_r_rsp,
      :ud_r_rbp,
      :ud_r_rsi,
      :ud_r_rdi,
      :ud_r_r8,
      :ud_r_r9,
      :ud_r_r10,
      :ud_r_r11,
      :ud_r_r12,
      :ud_r_r13,
      :ud_r_r14,
      :ud_r_r15,
      #
      # Segments registers
      #
      :ud_r_es,
      :ud_r_cs,
      :ud_r_ss,
      :ud_r_ds,
      :ud_r_fs,
      :ud_r_gs,
      #
      # Control registers
      #
      :ud_r_cr0,
      :ud_r_cr1,
      :ud_r_cr2,
      :ud_r_cr3,
      :ud_r_cr4,
      :ud_r_cr5,
      :ud_r_cr6,
      :ud_r_cr7,
      :ud_r_cr8,
      :ud_r_cr9,
      :ud_r_cr10,
      :ud_r_cr11,
      :ud_r_cr12,
      :ud_r_cr13,
      :ud_r_cr14,
      :ud_r_cr15,
      #
      # Debug registers
      #
      :ud_r_dr0,
      :ud_r_dr1,
      :ud_r_dr2,
      :ud_r_dr3,
      :ud_r_dr4,
      :ud_r_dr5,
      :ud_r_dr6,
      :ud_r_dr7,
      :ud_r_dr8,
      :ud_r_dr9,
      :ud_r_dr10,
      :ud_r_dr11,
      :ud_r_dr12,
      :ud_r_dr13,
      :ud_r_dr14,
      :ud_r_dr15,
      #
      # MMX registers
      #
      :ud_r_mm0,
      :ud_r_mm1,
      :ud_r_mm2,
      :ud_r_mm3,
      :ud_r_mm4,
      :ud_r_mm5,
      :ud_r_mm6,
      :ud_r_mm7,
      #
      # x87 registers
      #
      :ud_r_st0,
      :ud_r_st1,
      :ud_r_st2,
      :ud_r_st3,
      :ud_r_st4,
      :ud_r_st5,
      :ud_r_st6,
      :ud_r_st7,
      #
      # Extended multimedia registers
      #
      :ud_r_xmm0,
      :ud_r_xmm1,
      :ud_r_xmm2,
      :ud_r_xmm3,
      :ud_r_xmm4,
      :ud_r_xmm5,
      :ud_r_xmm6,
      :ud_r_xmm7,
      :ud_r_xmm8,
      :ud_r_xmm9,
      :ud_r_xmm10,
      :ud_r_xmm11,
      :ud_r_xmm12,
      :ud_r_xmm13,
      :ud_r_xmm14,
      :ud_r_xmm15,
      :ud_r_rip,
      #
      # Operand types
      #
      :ud_op_reg,
      :ud_op_mem,
      :ud_op_ptr,
      :ud_op_imm,
      :ud_op_jimm,
      :ud_op_const
    ]

    REGS = {
      :ud_r_al => :al,
      :ud_r_cl => :cl,
      :ud_r_dl => :dl,
      :ud_r_bl => :bl,
      :ud_r_ah => :ah,
      :ud_r_ch => :ch,
      :ud_r_dh => :dh,
      :ud_r_bh => :bh,
      :ud_r_spl => :spl,
      :ud_r_bpl => :bpl,
      :ud_r_sil => :sil,
      :ud_r_dil => :dil,
      :ud_r_r8b => :r8b,
      :ud_r_r9b => :r9b,
      :ud_r_r10b => :r10b,
      :ud_r_r11b => :r11b,
      :ud_r_r12b => :r12b,
      :ud_r_r13b => :r13b,
      :ud_r_r14b => :r14b,
      :ud_r_r15b => :r15b,
      #
      # 16 bit GRPs
      #
      :ud_r_ax => :ax,
      :ud_r_cx => :cx,
      :ud_r_dx => :dx,
      :ud_r_bx => :bx,
      :ud_r_sp => :sp,
      :ud_r_bp => :bp,
      :ud_r_si => :si,
      :ud_r_di => :di,
      :ud_r_r8w => :r8w,
      :ud_r_r9w => :r9w,
      :ud_r_r10w => :r10w,
      :ud_r_r11w => :r11w,
      :ud_r_r12w => :r12w,
      :ud_r_r13w => :r13w,
      :ud_r_r14w => :r14w,
      :ud_r_r15w => :r15w,
      #
      # 32 bit GRPs
      #
      :ud_r_eax => :eax,
      :ud_r_ecx => :ecx,
      :ud_r_edx => :edx,
      :ud_r_ebx => :ebx,
      :ud_r_esp => :esp,
      :ud_r_ebp => :ebp,
      :ud_r_esi => :esi,
      :ud_r_edi => :edi,
      :ud_r_r8d => :r8d,
      :ud_r_r9d => :r9d,
      :ud_r_r10d => :r10d,
      :ud_r_r11d => :r11d,
      :ud_r_r12d => :r12d,
      :ud_r_r13d => :r13d,
      :ud_r_r14d => :r14d,
      :ud_r_r15d => :r15d,
      #
      # 64 bit GRPs
      #
      :ud_r_rax => :rax,
      :ud_r_rcx => :rcx,
      :ud_r_rdx => :rdx,
      :ud_r_rbx => :rbx,
      :ud_r_rsp => :rsp,
      :ud_r_rbp => :rbp,
      :ud_r_rsi => :rsi,
      :ud_r_rdi => :rdi,
      :ud_r_r8 => :r8,
      :ud_r_r9 => :r9,
      :ud_r_r10 => :r10,
      :ud_r_r11 => :r11,
      :ud_r_r12 => :r12,
      :ud_r_r13 => :r13,
      :ud_r_r14 => :r14,
      :ud_r_r15 => :r15,
      #
      # Segments registers
      #
      :ud_r_es => :es,
      :ud_r_cs => :cs,
      :ud_r_ss => :ss,
      :ud_r_ds => :ds,
      :ud_r_fs => :fs,
      :ud_r_gs => :gs,
      #
      # Control registers
      #
      :ud_r_cr0 => :cr0,
      :ud_r_cr1 => :cr1,
      :ud_r_cr2 => :cr2,
      :ud_r_cr3 => :cr3,
      :ud_r_cr4 => :cr4,
      :ud_r_cr5 => :cr5,
      :ud_r_cr6 => :cr6,
      :ud_r_cr7 => :cr7,
      :ud_r_cr8 => :cr8,
      :ud_r_cr9 => :cr9,
      :ud_r_cr10 => :cr10,
      :ud_r_cr11 => :cr11,
      :ud_r_cr12 => :cr12,
      :ud_r_cr13 => :cr13,
      :ud_r_cr14 => :cr14,
      :ud_r_cr15 => :cr15,
      #
      # Debug registers
      #
      :ud_r_dr0 => :dr0,
      :ud_r_dr1 => :dr1,
      :ud_r_dr2 => :dr2,
      :ud_r_dr3 => :dr3,
      :ud_r_dr4 => :dr4,
      :ud_r_dr5 => :dr5,
      :ud_r_dr6 => :dr6,
      :ud_r_dr7 => :dr7,
      :ud_r_dr8 => :dr8,
      :ud_r_dr9 => :dr9,
      :ud_r_dr10 => :dr10,
      :ud_r_dr11 => :dr11,
      :ud_r_dr12 => :dr12,
      :ud_r_dr13 => :dr13,
      :ud_r_dr14 => :dr14,
      :ud_r_dr15 => :dr15,
      #
      # MMX registers
      #
      :ud_r_mm0 => :mm0,
      :ud_r_mm1 => :mm1,
      :ud_r_mm2 => :mm2,
      :ud_r_mm3 => :mm3,
      :ud_r_mm4 => :mm4,
      :ud_r_mm5 => :mm5,
      :ud_r_mm6 => :mm6,
      :ud_r_mm7 => :mm7,
      #
      # x87 registers
      #
      :ud_r_st0 => :st0,
      :ud_r_st1 => :st1,
      :ud_r_st2 => :st2,
      :ud_r_st3 => :st3,
      :ud_r_st4 => :st4,
      :ud_r_st5 => :st5,
      :ud_r_st6 => :st6,
      :ud_r_st7 => :st7,
      #
      # Extended multimedia registers
      #
      :ud_r_xmm0 => :xmm0,
      :ud_r_xmm1 => :xmm1,
      :ud_r_xmm2 => :xmm2,
      :ud_r_xmm3 => :xmm3,
      :ud_r_xmm4 => :xmm4,
      :ud_r_xmm5 => :xmm5,
      :ud_r_xmm6 => :xmm6,
      :ud_r_xmm7 => :xmm7,
      :ud_r_xmm8 => :xmm8,
      :ud_r_xmm9 => :xmm9,
      :ud_r_xmm10 => :xmm10,
      :ud_r_xmm11 => :xmm11,
      :ud_r_xmm12 => :xmm12,
      :ud_r_xmm13 => :xmm13,
      :ud_r_xmm14 => :xmm14,
      :ud_r_xmm15 => :xmm15,
      :ud_r_rip => :rip,
    }

    # Syntaxes
    SYNTAX = {
      :att => :ud_translate_att,
      :intel => :ud_translate_intel
    }

    callback :ud_input_callback, [:pointer], :int
    callback :ud_translator_callback, [:pointer], :void
  end
end
