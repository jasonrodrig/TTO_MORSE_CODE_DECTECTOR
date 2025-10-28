interface morse_assertions(clk , rst , dot_inp , dash_inp , char_space_inp , word_space_inp , sout);

  input clk;
  input rst;
  input dot_inp;
  input dash_inp;
  input char_space_inp;
  input word_space_inp;
  input [7:0] sout;

  //==========================================================
  // assertion name : SOUT_VALID_CHECK
  // Description    : sout should never be unknown(x or z)
  //==========================================================
  property SOUT_VALID_CHECK;
    @(posedge clk)
      disable iff (!rst)
      !$isunknown(sout);
  endproperty

  A1: assert property (SOUT_VALID_CHECK)
    $info("ASSERTION-1 PASSED");
    else
      $error("ASSERTION FAILED: sout is unknown at time %0t", $time);

  //========================================================
  // assertion name  : ILLEGAL_INPUT_CHECK
  // description : check only one input high at same time
  //==========================================================
  property ILLEGAL_INPUT_CHECK;
     @(posedge clk)
     disable iff (!rst)
     (dot_inp + dash_inp + char_space_inp + word_space_inp) <= 1;
  endproperty

  A2: assert property(ILLEGAL_INPUT_CHECK)
    $info("ASSERTION-2 PASSED");
    else
      $error("ASSERTION FAILED: Multiple inputs high at time %0t", $time);

  //========================================================
  // assertion name  : CHAR_SPACE_CHECK
  // description : after char_space_inp high, no new input for next 3 cycles
  //========================================================
  property CHAR_SPACE_CHECK;
     @(posedge clk)
     disable iff (!rst)
     char_space_inp |=> (
       (!dot_inp && !dash_inp && !word_space_inp) [*3]
     );
  endproperty

  A3: assert property (CHAR_SPACE_CHECK)
    $info("ASSERTION-3 PASSED");
    else
      $error("ASSERTION FAILED: Inputs active within 3 cycles after char_space at time %0t", $time);

  //========================================================
  // assertion name  : WORD_SPACE_CHECK
  // description : after word_space_inp high, no new input for next 7 cycles
  //========================================================
  property WORD_SPACE_CHECK;
     @(posedge clk)
     disable iff (!rst)
     word_space_inp |=> (
       (!dot_inp && !dash_inp && !char_space_inp) [*7]
     );
  endproperty

  A4: assert property (WORD_SPACE_CHECK)
    $info("ASSERTION-4 PASSED");
    else
      $error("ASSERTION FAILED: Inputs active within 7 cycles after word_space at time %0t", $time);

  //========================================================
  // assertion name  : RESET_ACTIVE_CHECK
  // description : when reset is ACTIVE (rst=0), sout must be 0
  //========================================================
  property RESET_ACTIVE_CHECK;
     @(posedge clk)
     !rst |-> (sout == 0);
  endproperty

  A5: assert property (RESET_ACTIVE_CHECK)
    $info("ASSERTION-5 PASSED");
    else
      $error("ASSERTION FAILED: sout is not 0 when reset is active (rst=0) at time %0t", $time);

  //========================================================
  // ASSERTION NAME  : WORD_OUTPUT_CHECK
  // DESCRIPTION     : When word_space_inp is asserted,
  //                   sout must be 0x20 exactly after 7 cycles.
  //========================================================
  property WORD_OUTPUT_CHECK;
    @(posedge clk)
    disable iff (!rst)
    word_space_inp |=> ##7 (sout == 8'h20);
  endproperty

  A6: assert property (WORD_OUTPUT_CHECK)
    $info("ASSERTION-6 PASSED: sout correctly 0x20 after 7 cycles of word_space_inp");
    else
      $error("ASSERTION FAILED: sout != 0x20 after 7 cycles of word_space_inp at time %0t", $time);

endinterface

