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
  property svc;
    @(posedge clk)
      // disable iff (!rst)
      rst |-> !$isunknown(sout);
  endproperty

  SOUT_VALID_CHECK : assert property (svc)
    $info("SOUT_VALID_CHECK PASSED");
    else
      $error("ASSERTION FAILED: sout is unknown at time %0t", $time);

  //========================================================
  // assertion name  : CHAR_SPACE_CHECK
  // description : after char_space_inp high, no new input for next 3 cycles
  //========================================================
  property prop3;
     @(posedge clk)
     disable iff (!rst)
     (char_space_inp && !dot_inp && !dash_inp) |=> (
       (!dot_inp && !dash_inp && !word_space_inp) [*3]
     );
  endproperty

  CHAR_SPACE_CHECK : assert property (prop3)
    $info("CHAR_SPACE_CHECK PASSED");
    else
      $error("CHAR_SPACE_ASSERTION FAILED: Inputs active within 3 cycles after char_space at time %0t", $time);

  //========================================================
  // assertion name  : WORD_SPACE_CHECK
  // description : after word_space_inp high, no new input for next 7 cycles
  //========================================================
  property prop4;
     @(posedge clk)
     disable iff (!rst)
     (!char_space_inp && !dot_inp && !dash_inp && word_space_inp) |=> (
       (!dot_inp && !dash_inp && !char_space_inp) [*7]
     );
  endproperty

  WORD_SPACE_CHECK : assert property (prop4)
    $info("WORD_SPACE_CHECK PASSED");
    else
      $error("ASSERTION FAILED: Inputs active within 7 cycles after word_space at time %0t", $time);

  //========================================================
  // assertion name  : RESET_ACTIVE_CHECK
  // description : when reset is ACTIVE (rst=0), sout must be 0
  //========================================================
  property prop5;
     @(posedge clk)
     !rst |-> (sout == 8'hff);
  endproperty

  RESET_ACTIVE_CHECK: assert property (prop5)
    $info("RESET_ACTIVE_CHECK PASSED");
    else
      $error("RESET_ACTIVE_ASSERTION FAILED: sout is not 0 when reset is active (rst=0) at time %0t", $time);

  //========================================================
  // ASSERTION NAME  : WORD_OUTPUT_CHECK
  // DESCRIPTION     : When word_space_inp is asserted,
  //                   sout must be 0x20 exactly after 7 cycles.
  //========================================================
  property prop6;
    @(posedge clk)
    disable iff (!rst)
    (!char_space_inp && !dot_inp && !dash_inp && word_space_inp) |=> ##7 (sout == 8'h20);
  endproperty

  WORD_OUTPUT_CHECK : assert property (prop6)
    $info("WORD_OUTPUT_CHECK PASSED: sout correctly 0x20 after 7 cycles of word_space_inp");
    else
      $error("ASSERTION FAILED: sout != 0x20 after 7 cycles of word_space_inp at time %0t", $time);

endinterface
 
