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

    # Syntaxes
    SYNTAX = {
      :att => :ud_translate_att,
      :intel => :ud_translate_intel
    }

    callback :ud_input_callback, [:pointer], :int
    callback :ud_translator_callback, [:pointer], :void
  end
end
