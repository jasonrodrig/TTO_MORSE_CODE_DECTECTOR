class morse_passive_agent extends uvm_agent;
  // declaring the handle for morse_passive_monitor
	morse_passive_monitor morse_passive_mon;

	// registering the morse_passive_agent component to the factory	
	`uvm_component_utils(morse_passive_agent)

	//------------------------------------------------------//
	//  Creating a new constructor for morse_passive_agent    //  
	//------------------------------------------------------//

	function new(string name = "morse_passive_agent", uvm_component parent = null);
		super.new(name, parent);
	endfunction 

	//------------------------------------------------------//
	//       building morse_passive_monitor component         //  
	//------------------------------------------------------//

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(get_is_active() == UVM_PASSIVE) begin	
			morse_passive_mon = morse_passive_monitor::type_id::create("morse_passive_mon", this);
		end
	endfunction
endclass  
