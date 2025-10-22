class morse_test extends uvm_test;

	// registering morse_test with the fatcory
	`uvm_component_utils(morse_test)

	// handle declaration for morse_environment and morse_test
	morse_environment morse_env;
	morse_sequence seq;

	//------------------------------------------------------//
	//    Creating a new constructor for morse_test           //  
	//------------------------------------------------------//

	function new(string name = "morse_test", uvm_component parent);
		super.new(name,parent);
	endfunction : new

	//------------------------------------------------------//
	//         building components for morse_environment      //
	//         and object for morse_sequence                  //  
	//------------------------------------------------------//

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		morse_env = morse_environment::type_id::create("morse_environment", this);
		seq = morse_sequence::type_id::create("morse_seq");
	endfunction : build_phase

	//------------------------------------------------------//
	//       Printing the ALU architecture toptoplogy       //  
	//------------------------------------------------------//

	function void end_of_elaboration();
		uvm_top.print_topology();
	endfunction

	//------------------------------------------------------//
	//             running the test sequence                //  
	//------------------------------------------------------//

	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		seq.start(morse_env.morse_active_agt.morse_active_seqr);
		phase.drop_objection(this);
	endtask
endclass

//------------------------------------------------------//
//                    reset test                        //  
//------------------------------------------------------//

class reset_test extends morse_test;

	`uvm_component_utils( reset_test)
	reset_sequence seq0;

	function new(string name = " rst_ce_test", uvm_component parent);
		super.new(name,parent);
	endfunction : new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		seq0 = reset_sequence ::type_id::create("morse_seq0");
	endfunction : build_phase

	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		seq0.start(morse_env.morse_active_agt.morse_active_seqr);
		phase.drop_objection(this);
	endtask
endclass
