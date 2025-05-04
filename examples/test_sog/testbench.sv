// SystemVerilog for Hardware Synthesis
// See https://youtu.be/A2b82ACe25g

// Author: John Aynsley, Doulos
// Date:   14-Mar-2016

module top;
  TB_blk  TB_blk_inst ();
  TB_flop TB_flop_inst ();
  TB_M1   TB_M1_inst ();
  TB_M2   TB_M2_inst ();
  TB_M3   TB_M3_inst ();
  TB_M4   TB_M4_inst ();
endmodule

module TB_blk;
  logic p, r, x, z;
  logic [3:0] q, y;

  blk #(.n(4), .m(4)) inst (p, q, r, x, y, z);
endmodule

module TB_flop;
  logic clock, r, d, q;

  flop inst (.ck(clock), .*);
endmodule

module TB_M1;
  logic [1:0] a, b, c, d, f;

  M1 inst (.a, .b, .c, .d, .f);

  initial
  begin
    {a, b, c, d} = 8'b01_01_10_11;
    #1 {a, b, c, d} = 8'b10_01_10_11;
    #1 {a, b, c, d} = 8'b11_01_10_11;
  end
endmodule

module TB_M2;
  logic [1:0] a, b, c, d, f;

  M2 inst (.*);

  initial
  begin
    {a, b, c, d} = 8'b01_01_10_11;
    #1 {a, b, c, d} = 8'b10_01_10_11;
    #1 {a, b, c, d} = 8'b11_01_10_11;
  end
endmodule

module TB_M3;
  logic [3:0] state;
  logic [1:0] f;

  M3 inst (.state, .f);

  initial
  begin
    state = 4'b1000;
    #1 state = 4'b0100;
    #1 state = 4'b0010;
    #1 state = 4'b0001;
  end
endmodule

module TB_M4;
  logic [3:0] state;
  logic [1:0] f;

  M4 inst (.*);

  initial
  begin
    state = 4'b1000;
    #1 state = 4'b0100;
    #1 state = 4'b0010;
    #1 state = 4'b0001;
  end
endmodule
