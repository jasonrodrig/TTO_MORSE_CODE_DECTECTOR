class morse_sequence_item extends uvm_sequence_item;

	//------------------------------------------------------//
	//             randomized input signals                 //  
	//------------------------------------------------------//
	rand logic rst;
	rand logic dot_inp , dash_inp;
	rand logic char_space_inp, word_space_inp;

	//------------------------------------------------------//
	//          non randomized output signals               //  
	//------------------------------------------------------//

	logic [ 7 : 0 ] sout ;

	//------------------------------------------------------//
	//         registering input signals and output         //
	//                signals to the factory                //  
	//------------------------------------------------------//

	`uvm_object_utils_begin(morse_sequence_item)
	`uvm_field_int(rst,UVM_ALL_ON)
	`uvm_field_int(dot_inp,UVM_ALL_ON)
	`uvm_field_int(dash_inp,UVM_ALL_ON)
	`uvm_field_int(char_space_inp,UVM_ALL_ON)
	`uvm_field_int(word_space_inp,UVM_ALL_ON)
	`uvm_field_int(sout,UVM_ALL_ON)
	`uvm_object_utils_end

	//------------------------------------------------------//
	//   Creating a new constructor for morse_sequence_item   //  
	//------------------------------------------------------//

	function new(string name = "morse_sequence_item");
		super.new(name);
	endfunction

endclass
