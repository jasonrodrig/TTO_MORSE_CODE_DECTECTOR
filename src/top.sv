
`include "morse_defines.sv"
`include "morse_design.sv"
`include "morse_interface.sv"
`include "morse_packages.sv"
`include "morse_assertions.sv"

import uvm_pkg::*;
import morse_pkg::*;

// Testbench Top module block 
module top;

	//clock generation
	bit clk = 0;
	always #5 clk = ~clk;

	// interface instantiation
	morse_interface vif(clk);

	// design instantiation
	morse_top DUT(
		.clk(vif.clk),
		.rst(vif.rst),
		.dot_inp(vif.dot_inp),
		.dash_inp(vif.dash_inp),
		.char_space_inp(vif.char_space_inp),
		.word_space_inp(vif.word_space_inp),
		.sout(vif.sout)
	);
	
	// instantiating assertion signals
/*	bind vif morse_assertions ASSERT(
		.clk(vif.clk),
		.rst(vif.rst),
		.dot_inp(vif.dot_inp),
		.dash_inp(vif.dash_inp),
		.char_space_inp(vif.char_space_inp),
		.word_space_inp(vif.word_space_inp),
		.sout(vif.sout)
	);
*/
	// setting the config_db at the top module 
	initial begin 
		uvm_config_db#(virtual morse_interface)::set(null,"*","vif",vif);
		$dumpfile("dump.vcd");
		$dumpvars;
	end

	// initatiating morse_regresion_test 
	initial begin 
	//	run_test("morse_test");
	//	run_test("reset_test");
	//   run_test("morse_character_test");
  //  run_test("morse_number_test");
  //  run_test("morse_alphanumeric_test");
   	run_test("word_parsing_test");
	//	run_test("word_test");
		#1000 $finish;
	end
endmodule
