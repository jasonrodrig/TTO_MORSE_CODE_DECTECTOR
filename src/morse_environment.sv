class morse_environment extends uvm_env;

	// declaring handle for morse_active_agent, morse_passive_agent,
	// morse_scoreboard and morse_coverage
	morse_passive_agent morse_passive_agt;
	morse_active_agent  morse_active_agt;
	morse_scoreboard    morse_scb;
	morse_coverage      morse_cov;

	// registering the morse_component to the factory
	`uvm_component_utils(morse_environment)

	//------------------------------------------------------//
	//  Creating a new constructor for morse_environment      //  
	//------------------------------------------------------//

	function new(string name = "morse_environment", uvm_component parent);
		super.new(name, parent);
	endfunction

	//------------------------------------------------------//
	//       building component for morse_active_agent,       //
	//  morse_passive_agent, morse_scoreboard and morse_coverage  //  
	//------------------------------------------------------//

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		morse_active_agt  = morse_active_agent::type_id::create("morse_active_agt", this);
		morse_passive_agt = morse_passive_agent::type_id::create("morse_passive_agt", this);
		morse_scb = morse_scoreboard::type_id::create("morse_scoreboard", this);
		morse_cov = morse_coverage::type_id::create("morse_coverage", this);
		set_config_int("morse_active_agt","is_active",UVM_ACTIVE);
		set_config_int("morse_passive_agt","is_active",UVM_PASSIVE);
	endfunction

	//------------------------------------------------------//
	//            Connecting 2 component:                   //
	//  1 ) morse_active_monitor to morse_scoreboard        //
	//  2 ) morse_active_monitor to morse_coverage          // 
	//  3 ) morse_passive_monitor to morse_scoreboard       //
	//  4 ) morse_passive_monitor to morse_coverage         //
	//------------------------------------------------------//

	function void connect_phase(uvm_phase phase);
		morse_active_agt.morse_active_mon.active_mon_port.connect(morse_scb.active_scb_port);
		morse_active_agt.morse_active_mon.active_mon_port.connect(morse_cov.cov_active_mon_port);
		morse_passive_agt.morse_passive_mon.passive_mon_port.connect(morse_scb.passive_scb_port);	
		morse_passive_agt.morse_passive_mon.passive_mon_port.connect(morse_cov.cov_passive_mon_port);
	endfunction
endclass


