class morse_test extends uvm_test;

	// registering morse_test with the fatcory
	`uvm_component_utils(morse_test)

	// handle declaration for morse_environment and morse_test
	morse_environment morse_env;
	morse_base_sequence seq;

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
		seq = morse_base_sequence::type_id::create("morse_seq");
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

	function new(string name = " rst_test", uvm_component parent);
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

//------------------------------------------------------//
//                 morse character test                 //  
//------------------------------------------------------//

class morse_character_test extends morse_test;

	`uvm_component_utils( morse_character_test)
	 morse_character_sequence seq1;

	function new(string name = " morse_character_test", uvm_component parent);
		super.new(name,parent);
	endfunction : new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		seq1 = morse_character_sequence::type_id::create("seq1");
	endfunction : build_phase

	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		seq1.start(morse_env.morse_active_agt.morse_active_seqr);
		phase.drop_objection(this);
	endtask
endclass

//------------------------------------------------------//
//                 morse character test                 //  
//------------------------------------------------------//

class morse_number_test extends morse_test;

	`uvm_component_utils( morse_number_test)
	 morse_number_sequence seq2;

	function new(string name = " morse_number_test", uvm_component parent);
		super.new(name,parent);
	endfunction : new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		seq2 = morse_number_sequence::type_id::create("seq2");
	endfunction : build_phase

	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		seq2.start(morse_env.morse_active_agt.morse_active_seqr);
		phase.drop_objection(this);
	endtask
endclass

//------------------------------------------------------//
//              morse alphanumeric test                 //  
//------------------------------------------------------//

class morse_alphanumeric_test extends morse_test;

	`uvm_component_utils( morse_alphanumeric_test)
	 morse_alphanumeric_sequence seq3;

	function new(string name = "morse_alphanumeric_test", uvm_component parent);
		super.new(name,parent);
	endfunction : new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		seq3 = morse_alphanumeric_sequence::type_id::create("seq3");
	endfunction : build_phase

	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		seq3.start(morse_env.morse_active_agt.morse_active_seqr);
		phase.drop_objection(this);
	endtask
endclass


//------------------------------------------------------//
//                   word parsing test                  //  
//------------------------------------------------------//

class word_parsing_test extends morse_test;

	`uvm_component_utils( word_parsing_test)
	 word_parsing_sequence seq4;

	function new(string name = " word_parsing_test", uvm_component parent);
		super.new(name,parent);
	endfunction : new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		seq4 = word_parsing_sequence::type_id::create("seq4");
	endfunction : build_phase

	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		seq4.start(morse_env.morse_active_agt.morse_active_seqr);
		phase.drop_objection(this);
	endtask
endclass

//------------------------------------------------------//
//                   word test                          //  
//------------------------------------------------------//

class word_test extends morse_test;

	`uvm_component_utils( word_test)
	 word_sequence seq5;

	function new(string name = " word_test", uvm_component parent);
		super.new(name,parent);
	endfunction : new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		seq5 = word_sequence::type_id::create("seq5");
	endfunction : build_phase

	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		seq5.start(morse_env.morse_active_agt.morse_active_seqr);
		phase.drop_objection(this);
	endtask
endclass

//------------------------------------------------------//
//                   mid reset test                     //  
//------------------------------------------------------//

class mid_reset_test extends morse_test;

	`uvm_component_utils( mid_reset_test)
	 mid_reset_sequence seq6;

	function new(string name = "mid_reset_test", uvm_component parent);
		super.new(name,parent);
	endfunction : new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		seq6 = mid_reset_sequence::type_id::create("seq6");
	endfunction : build_phase

	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		seq6.start(morse_env.morse_active_agt.morse_active_seqr);
		phase.drop_objection(this);
	endtask
endclass

//------------------------------------------------------//
//                 cornercase1 test                     //  
//------------------------------------------------------//

class cornercase1_test extends morse_test;

	`uvm_component_utils( cornercase1_test)
	 cornercase1_sequence seq7;

	function new(string name = "cornercase1_test", uvm_component parent);
		super.new(name,parent);
	endfunction : new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		seq7 = cornercase1_sequence::type_id::create("seq7");
	endfunction : build_phase

	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		seq7.start(morse_env.morse_active_agt.morse_active_seqr);
		phase.drop_objection(this);
	endtask
endclass

//------------------------------------------------------//
//                 cornercase2 test                     //  
//------------------------------------------------------//

class cornercase2_test extends morse_test;

	`uvm_component_utils( cornercase2_test)
	 cornercase2_sequence seq8;

	function new(string name = "cornercase2_test", uvm_component parent);
		super.new(name,parent);
	endfunction : new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		seq8 = cornercase2_sequence::type_id::create("seq8");
	endfunction : build_phase

	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		seq8.start(morse_env.morse_active_agt.morse_active_seqr);
		phase.drop_objection(this);
	endtask
endclass

//------------------------------------------------------//
//                 cornercase3 test                     //  
//------------------------------------------------------//

class cornercase3_test extends morse_test;

	`uvm_component_utils( cornercase3_test)
	 cornercase3_sequence seq9;

	function new(string name = "cornercase3_test", uvm_component parent);
		super.new(name,parent);
	endfunction : new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		seq9 = cornercase3_sequence::type_id::create("seq9");
	endfunction : build_phase

	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		seq9.start(morse_env.morse_active_agt.morse_active_seqr);
		phase.drop_objection(this);
	endtask
endclass

//------------------------------------------------------//
//    invalid test for continuous dot and dash          //  
//------------------------------------------------------//

class invalid_test1 extends morse_test;

	`uvm_component_utils(invalid_test1)
	 invalid_sequence1 seq10;

	function new(string name = "invalid_test1", uvm_component parent);
		super.new(name,parent);
	endfunction : new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		seq10 = invalid_sequence1::type_id::create("seq10");
	endfunction : build_phase

	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		seq10.start(morse_env.morse_active_agt.morse_active_seqr);
		phase.drop_objection(this);
	endtask
endclass

//------------------------------------------------------//
//        invalid test for invlaid characters           //  
//------------------------------------------------------//

class invalid_test2 extends morse_test;

	`uvm_component_utils(invalid_test2)
	 invalid_sequence2 seq11;

	function new(string name = "invalid_test2", uvm_component parent);
		super.new(name,parent);
	endfunction : new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		seq11 = invalid_sequence2::type_id::create("seq11");
	endfunction : build_phase

	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		seq11.start(morse_env.morse_active_agt.morse_active_seqr);
		phase.drop_objection(this);
	endtask
endclass

//------------------------------------------------------//
//          invalid test for invlaid nuumbers           //  
//------------------------------------------------------//

class invalid_test3 extends morse_test;

	`uvm_component_utils(invalid_test3)
	 invalid_sequence3 seq12;

	function new(string name = "invalid_test3", uvm_component parent);
		super.new(name,parent);
	endfunction : new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		seq12 = invalid_sequence3::type_id::create("seq12");
	endfunction : build_phase

	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		seq12.start(morse_env.morse_active_agt.morse_active_seqr);
		phase.drop_objection(this);
	endtask
endclass


//------------------------------------------------------//
//              morse_regression test                   //  
//------------------------------------------------------//

class morse_regression_test extends morse_test;

	`uvm_component_utils(morse_regression_test)
	morse_regression reg_test;

	function new(string name = "morse_regression_test", uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		reg_test = morse_regression::type_id::create("reg_test");
	endfunction : build_phase

	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		reg_test.start(morse_env.morse_active_agt.morse_active_seqr);
		phase.drop_objection(this);
	endtask
endclass
