interface morse_interface(input bit clk);

	// morse input signals
	logic rst;
	logic dot_inp , dash_inp; 
	logic char_space_inp , word_space_inp;

	// morse output signals
	logic [ 7 : 0 ] sout ;

	// Clocking block morse_driver_cb synchronizes DUT inputs
	clocking drv_cb @(posedge clk);
	  default input #0 output #0;
	  output rst;
	  output dot_inp , dash_inp;
	  output char_space_inp , word_space_inp;
	endclocking

	// Clocking block morse_monitor_cb synchronizes DUT inputs and outputs
	clocking mon_cb @(posedge clk);
	  default input #0 output #0;
	  input rst;
	  input dot_inp , dash_inp;
	  input char_space_inp , word_space_inp;
	  input sout;
	endclocking

	// Modport driver and monitor decleration
    	modport DRV(clocking drv_cb);
    	modport MON(clocking mon_cb);

endinterface
