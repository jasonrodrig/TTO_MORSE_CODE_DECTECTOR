class morse_passive_monitor extends uvm_monitor;

	// declaring interface handle for passive monitor
	virtual morse_interface.MON vif;

	// declaring the analysis port for passive monitor
	uvm_analysis_port#(morse_sequence_item) passive_mon_port;

	// declaring the morse_sequence_item class handle
	morse_sequence_item seq_item;

	// registering the morse_passive_monitor component to the factory
	`uvm_component_utils(morse_passive_monitor)

	//--------------------------------------------------------//
	//  Creating a new constructor for morse_passive_monitor--//
	//--------------------------------------------------------//

	function new (string name = "morse_passive_monitor", uvm_component parent);
		super.new(name, parent);
		passive_mon_port = new("passive_mon_port", this);
	endfunction

	//------------------------------------------------------//
	//   building config_db in the morse_passive_monitor    //
	//------------------------------------------------------//

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		seq_item = morse_sequence_item::type_id::create("seq_item");
		if(!uvm_config_db#(virtual morse_interface)::get(this, "", "vif", vif))
			`uvm_fatal("NOVIF",{"virtual interface must be set for: MORSE PASSIVE MONITOR ", get_full_name(), ".vif"});
	endfunction

	//------------------------------------------------------//
	//    capturing the output signals from the interface   //
	//------------------------------------------------------//

	task run_phase(uvm_phase phase);
		repeat(3) @(posedge vif.mon_cb);
		forever begin
			receive_outputs();
		end
	endtask

	//------------------------------------------------------//
	//                PASSIVE_MONITOR CODE                  //
	//------------------------------------------------------//

	task receive_outputs();
		repeat(1) @(posedge vif.mon_cb);

		//inp_mon();
		/*   if(seq_item.rst) begin
			if(seq_item.char_space_inp && !seq_item.dot_inp && !seq_item.dash_inp && !seq_item.word_space_inp) begin
			repeat(1) @(posedge vif.mon_cb);
			end
			else if(!seq_item.char_space_inp && !seq_item.dot_inp && !seq_item.dash_inp && seq_item.word_space_inp) begin
			repeat(5) @(posedge vif.mon_cb);
			end
		end
			*/  
			seq_item.sout = vif.mon_cb.sout;            //capture output
			//passive_mon_port.write(seq_item);
			`uvm_info("OUT_MON", $sformatf("rst = %0d, char_space = %0d, dot = %0d, dash = %0d, word_space = %0d", seq_item.rst, seq_item.char_space_inp, seq_item.dot_inp, seq_item.dash_inp, seq_item.word_space_inp), UVM_LOW);
			passive_mon_port.write(seq_item);
			//repeat(2) @(posedge vif.mon_cb);
	endtask

	/*  task inp_mon();
	seq_item.rst            = vif.mon_cb.rst;
	seq_item.dot_inp        = vif.mon_cb.dot_inp;
	seq_item.dash_inp       = vif.mon_cb.dash_inp;
	seq_item.char_space_inp = vif.mon_cb.char_space_inp;
	seq_item.word_space_inp = vif.mon_cb.word_space_inp;
	endtask
	*/
endclass

