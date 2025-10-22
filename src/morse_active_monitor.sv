class morse_active_monitor extends uvm_monitor;

	// declaring interface handle for active monitor
	virtual morse_interface vif;

	// declaring the analysis port for active monitor
	uvm_analysis_port#(morse_sequence_item) active_mon_port;

	// declaring the morse_sequence_item class handle
	morse_sequence_item seq;

	// registering the morse_active_monitor component to the factory
	`uvm_component_utils(morse_active_monitor)

	//------------------------------------------------------//
	//  Creating a new constructor for morse_active_monitor   //  
	//------------------------------------------------------//

	function new (string name = "morse_active_monitor", uvm_component parent);
		super.new(name, parent);
		active_mon_port = new("active_mon_port", this);
	endfunction

	//------------------------------------------------------//
	//   building config_db in the morse_active_monitor       //  
	//------------------------------------------------------//

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		seq = morse_sequence_item::type_id::create("morse_seq");
		if(!uvm_config_db#(virtual morse_interface)::get(this, "", "vif", vif))
			`uvm_fatal("NOVIF",{"virtual interface must be set for: MORSE ACTIVE MONITOR ",get_full_name(),".vif"});
	endfunction

	//------------------------------------------------------//
	//    capturing the input signals from the interface    //  
	//------------------------------------------------------//

	task run_phase(uvm_phase phase);
		forever begin
			morse_active_monitor_code();
		end
	endtask

	//------------------------------------------------------//
	//                ACTIVE_MONITOR CODE                   //  
	//------------------------------------------------------//

	task morse_active_monitor_code();
		//active_monitor code
	endtask

endclass

