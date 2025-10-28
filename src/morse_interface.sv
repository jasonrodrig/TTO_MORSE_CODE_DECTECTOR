interface morse_interface(input bit clk);

  //===========================================================
  //  MORSE SIGNAL DECLARATIONS
  //===========================================================
  // morse input signals
  logic rst;
  logic dot_inp, dash_inp;
  logic char_space_inp, word_space_inp;

  // morse output signals
  logic [7:0] sout;

  //===========================================================
  //  CLOCKING BLOCKS
  //===========================================================
  // Clocking block for Driver
  clocking drv_cb @(posedge clk);
    default input #0 output #0;
    output rst;
    output dot_inp, dash_inp;
    output char_space_inp, word_space_inp;
  endclocking

  // Clocking block for Monitor
  clocking mon_cb @(posedge clk);
    default input #0 output #0;
    input rst;
    input dot_inp, dash_inp;
    input char_space_inp, word_space_inp;
    input sout;
  endclocking

  //===========================================================
  //  MODPORTS
  //===========================================================
  modport DRV (clocking drv_cb);
  modport MON (clocking mon_cb);

  //===========================================================
  //  ASSERTIONS
  //===========================================================

  // 1. s_out should never be unknown
  property SOUT_VALID_CHECK;
    @(posedge clk)
    disable iff (!rst)
    !$isunknown(sout);
  endproperty

  A1: assert property (SOUT_VALID_CHECK)
    else $error("ASSERTION FAILED: s_out is unknown at %0t", $time);

  // 2. Only one input high at a time
  property ILLEGAL_INPUT_CHECK;
    @(posedge clk)
    disable iff (!rst)
    (dot_inp + dash_inp + char_space_inp + word_space_inp) <= 1;
  endproperty

  A2: assert property (ILLEGAL_INPUT_CHECK)
    else $error("ASSERTION FAILED: Multiple inputs high at %0t", $time);

  // 3. After char_space_inp, no input for next 3 cycles
  property CHAR_SPACE_CHECK;
    @(posedge clk)
    disable iff (!rst)
    char_space_inp |=> (!dot_inp && !dash_inp && !word_space_inp) [*3];
  endproperty

  A3: assert property (CHAR_SPACE_CHECK)
    else $error("ASSERTION FAILED: Inputs active within 3 cycles after char_space at %0t", $time);

  // 4. After word_space_inp, no input for next 7 cycles
  property WORD_SPACE_CHECK;
    @(posedge clk)
    disable iff (!rst)
    word_space_inp |=> (!dot_inp && !dash_inp && !char_space_inp) [*7];
  endproperty

  A4: assert property (WORD_SPACE_CHECK)
    else $error("ASSERTION FAILED: Inputs active within 7 cycles after word_space at %0t", $time);

  // 5. When reset active (rst=0), s_out must be 0
  property RESET_ACTIVE_CHECK;
    @(posedge clk)
    !rst |-> (sout == 0);
  endproperty

  A5: assert property (RESET_ACTIVE_CHECK)
    else $error("ASSERTION FAILED: s_out not 0 when reset active at %0t", $time);

  // 6. When word_space_inp asserted, after 7 cycles s_out must be 0x20 (space)
  property WORD_OUTPUT_CHECK;
    @(posedge clk)
    disable iff (!rst)
    word_space_inp |=> ##7 (sout == 8'h20);
  endproperty

  A6: assert property (WORD_OUTPUT_CHECK)
    else $error("ASSERTION FAILED: s_out != 0x20 after 7 cycles of word_space_inp at %0t", $time);

endinterface

