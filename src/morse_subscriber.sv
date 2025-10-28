`uvm_analysis_imp_decl(_active_mon_cg)
`uvm_analysis_imp_decl(_passive_mon_cg)

class morse_coverage extends uvm_component;

	//registering morse_coverage componenet with the factory
	`uvm_component_utils(morse_coverage)

	// analysis import declearation for coverage
	uvm_analysis_imp_active_mon_cg#(morse_sequence_item, morse_coverage) cov_active_mon_port;
	uvm_analysis_imp_passive_mon_cg#(morse_sequence_item, morse_coverage) cov_passive_mon_port;

	// handle declaration for morse_sequence_item
	morse_sequence_item active_mon, passive_mon;

	// declaring overall coverage result variable for inputs and outputs 
	real active_mon_cov_results, passive_mon_cov_results;

	//------------------------------------------------------//
	//               input covergroup                       //  
	//------------------------------------------------------//

    covergroup input_coverage;
    RESET_CP : coverpoint active_mon.reset {
        bins reset_bin[] = {0, 1};
    }
    DOT_INP_CP :coverpoint active_mon.dot_inp {
        bins dot_inp_bin[] ={0,1};
    }
    DASH_INP_CP:coverpoint active_mon.dash_inp {
        bins dash_inp_bin[] = {0,1};
    }
    CHAR_SPACE_INP_CP : coverpoint active_mon.char_space_inp {
        bins char_space_inp_bin[] = {0,1};
    }
    WORD_SPACE_INP_CP : coverpoint active_mon.word_space_inp {
        bins word_space_inp_bin[] = {0,1};
    }
    cross DOT_INP_CP, DASH_INP_CP;
    cross CHAR_SPACE_INP_CP, WORD_SPACE_INP_CP;
    endgroup

    //------------------------------------------------------//
    //                 output covergroup                    //  
    //------------------------------------------------------//

    covergroup output_coverage;
      SOUT_CP: coverpoint passive_mon.sout {
      	bins alpahabet[] = { [ 97 : 122 ] };
      	bins numbers[] = { [ 48 : 57 ] };
     	bins word_space = { 32 };
      	bins ig_bin = default;
      }	
    endgroup

	//------------------------------------------------------//
	//      Creating New constructor for morse_coverage       //   
	//------------------------------------------------------//

	function new(string name = "morse_coverage", uvm_component parent);
		super.new(name, parent);
		output_coverage = new();
		input_coverage  = new();
		cov_active_mon_port    = new("cov_active_mon_port", this);
		cov_passive_mon_port   = new("cov_passive_mon_port", this);
	endfunction

	//------------------------------------------------------//
	//      Captures the active monitor transaction and     //
	//            triggers input coverage sampling          //   
	//------------------------------------------------------//

	function void write_active_mon_cg(morse_sequence_item active_mon_seq);
		active_mon = active_mon_seq;
		input_coverage.sample();
	endfunction

	//------------------------------------------------------//
	//      Captures the passive monitor transaction and    //
	//            triggers output coverage sampling         //   
	//------------------------------------------------------//

	function void write_passive_mon_cg(morse_sequence_item passive_mon_seq);
		passive_mon = passive_mon_seq;
		output_coverage.sample();
	endfunction

	//------------------------------------------------------//
	//     extracting input and output coverage results     // 
	//------------------------------------------------------//

	function void extract_phase(uvm_phase phase);
		super.extract_phase(phase);
		active_mon_cov_results   = input_coverage.get_coverage();
		passive_mon_cov_results  = output_coverage.get_coverage();
	endfunction

	//------------------------------------------------------//
	//         display input coverage result and            //
	//             output coverage reesults                 //   
	//------------------------------------------------------//

	function void report_phase(uvm_phase phase);
		super.report_phase(phase);
		`uvm_info(get_type_name, $sformatf("[ACTIVE_MONITOR] Coverage ------> %0.2f%%,", active_mon_cov_results), UVM_MEDIUM);
		`uvm_info(get_type_name, $sformatf("[PASSIVE_MONITOR] Coverage ------> %0.2f%%", passive_mon_cov_results), UVM_MEDIUM);
	endfunction
endclass
