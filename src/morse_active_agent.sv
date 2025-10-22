class morse_active_agent extends uvm_agent;
	
	// declaring the handles for morse_driver , morse_sequencer , morse_active_monitor
	morse_driver          morse_active_driv;
	morse_sequencer       morse_active_seqr;
	morse_active_monitor  morse_active_mon;

	// registering the morse_active_agent component to the factory
	`uvm_component_utils(morse_active_agent)

	//------------------------------------------------------//
	//  Creating a new constructor for morse_active_agent     //  
	//------------------------------------------------------//

	function new (string name = "morse_active_agent", uvm_component parent);
		super.new(name, parent);
	endfunction 

	//------------------------------------------------------//
	//       building morse_driver, morse_sequencer and       //
	//            morse_active_monitor component              //  
	//------------------------------------------------------//

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(get_is_active() == UVM_ACTIVE) begin
			morse_active_driv = morse_driver::type_id::create("morse_active_driv", this);
			morse_active_seqr = morse_sequencer::type_id::create("morse_active_seqr", this);
		end
		  morse_active_mon = morse_active_monitor::type_id::create("morse_active_mon", this);
	endfunction

	//------------------------------------------------------//
	//         Connecting 2 component between morse_driver  //
	//                   and morse_sequencer                  //  
	//------------------------------------------------------//

	function void connect_phase(uvm_phase phase);
		if(get_is_active() == UVM_ACTIVE) begin
			morse_active_driv.seq_item_port.connect(morse_active_seqr.seq_item_export);
		end
	endfunction
endclass  
