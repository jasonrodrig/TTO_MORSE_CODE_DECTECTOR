class morse_passive_monitor extends uvm_monitor;

	// declaring interface handle for passive monitor
	virtual morse_interface vif;

	// declaring the analysis port for passive monitor
	uvm_analysis_port#(morse_sequence_item) passive_mon_port;

	// declaring the morse_sequence_item class handle
	morse_sequence_item seq;

	// registering the morse_passive_monitor component to the factory
	`uvm_component_utils(morse_passive_monitor)

	//------------------------------------------------------//
	//  Creating a new constructor for morse_passive_monitor  //  
	//------------------------------------------------------//

	function new (string name = "morse_passive_monitor", uvm_component parent);
		super.new(name, parent);
		passive_mon_port = new("passive_mon_port", this);
	endfunction

	//------------------------------------------------------//
	//   building config_db in the morse_passive_monitor      //  
	//------------------------------------------------------//

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		seq = morse_sequence_item::type_id::create("morse_seq");
		if(!uvm_config_db#(virtual morse_interface)::get(this, "", "vif", vif))
			`uvm_fatal("NOVIF",{"virtual interface must be set for: MORSE PASSIVE MONITOR ",get_full_name(),".vif"});
	endfunction

	//------------------------------------------------------//
	//    capturing the output signals from the interface   //  
	//------------------------------------------------------//

	task run_phase(uvm_phase phase);
		forever begin
			morse_passive_monitor_code();				
			passive_mon_port.write(seq); 
		end
	endtask

	//------------------------------------------------------//
	//                PASSIVE_MONITOR CODE                  //  
	//------------------------------------------------------//

	task morse_passive_monitor_code();
		//passive_monitor code
	endtask


endclass
