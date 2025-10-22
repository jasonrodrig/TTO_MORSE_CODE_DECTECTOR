class morse_sequencer extends uvm_sequencer#(morse_sequence_item);
	//------------------------------------------------------//
	// Registering the morse_sequencer componenet to factory  //  
	//------------------------------------------------------//

	`uvm_component_utils(morse_sequencer)

	//------------------------------------------------------//
	//    Creating a new constructor for morse_driver         //  
	//------------------------------------------------------//

	function new(string name = "morse_sequencer", uvm_component parent);
		super.new(name,parent);
	endfunction

endclass
