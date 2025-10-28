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

endinterface

