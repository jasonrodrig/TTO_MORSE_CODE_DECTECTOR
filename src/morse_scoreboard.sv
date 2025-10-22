`uvm_analysis_imp_decl(_active_mon_scb)
`uvm_analysis_imp_decl(_passive_mon_scb)

class morse_scoreboard extends uvm_scoreboard;
	// handle decleration for morse_sequnce item using queues
	morse_sequence_item active_mon_queue[$];
	morse_sequence_item passive_mon_queue[$];

	// handle decleration for morse_sequnce item sorting input and output transaction signals 	
	morse_sequence_item inp_mon_item;
	morse_sequence_item out_mon_item;

	// registering the morse_scoareboard to the factory	
	`uvm_component_utils(morse_scoreboard)

	// analysis import declaration for both active_monitor and passive_monitor	
	uvm_analysis_imp_active_mon_scb#(morse_sequence_item, morse_scoreboard) active_scb_port;
	uvm_analysis_imp_passive_mon_scb#(morse_sequence_item, morse_scoreboard) passive_scb_port;

	// Creating PASS AND FAIL decleration
	int PASS, FAIL;

	//------------------------------------------------------//
	//     Creating New constructor for morse_scoreboard      //   
	//------------------------------------------------------//

	function new(string name = "morse_scoreboard", uvm_component parent);
		super.new(name, parent);
		active_scb_port  = new("active_scb_port" , this);
		passive_scb_port = new("passive_scb_port", this); 
	endfunction

	//------------------------------------------------------//
	//      Captures the passive monitor transaction and    //
	// temporary storing the outputs in the packet_1 queue  //   
	//------------------------------------------------------//

	function void write_passive_mon_scb(morse_sequence_item packet_1);
		passive_mon_queue.push_back(packet_1);
	endfunction

	//------------------------------------------------------//
	//      Captures the active monitor transaction and     //
	//   temporary storing the inputs in the packet_2 queue //   
	//------------------------------------------------------//

	function void write_active_mon_scb(morse_sequence_item packet_2);
		active_mon_queue.push_back(packet_2);
	endfunction

	//------------------------------------------------------//
	//    Reporting Pass and failure for each testcases     //   
	//------------------------------------------------------//

	function void report_phase(uvm_phase phase);
		super.report_phase(phase);
		$display("Passes = %0d | Fails = %0d", PASS, FAIL);
	endfunction

	//------------------------------------------------------//
	//          Running the morse_reference model             //
	//------------------------------------------------------//

	task run_phase(uvm_phase phase);
		forever begin
			// waiting when the passive_mon_queue and active_mon_queue has the transaction 
			// stored in both the queue and assign the outputs from the passive monitor to the out_mon_item
			// andassign the inputs from the active monitor to the inp_mon_item
			wait(active_mon_queue.size() > 0 && passive_mon_queue.size() > 0);
			inp_mon_item = active_mon_queue.pop_front();
			out_mon_item = passive_mon_queue.pop_front();
			compare(inp_mon_item, out_mon_item);
		end
	endtask

	//----------------------------------------------------------//
	// mimicing the design functionlaity and perform comparison //
	//----------------------------------------------------------//

	task compare(morse_sequence_item inp_item, morse_sequence_item out_item);
		// morse refrence_model
	endtask

endclass
