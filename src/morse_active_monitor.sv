
class morse_active_monitor extends uvm_monitor;

	// declaring interface handle for active monitor
	virtual morse_interface.MON vif;

	// declaring the analysis port for active monitor
	uvm_analysis_port#(morse_sequence_item) active_mon_port;

	// declaring the morse_sequence_item class handle
	morse_sequence_item received_item;

	// registering the morse_active_monitor component to the factory
	`uvm_component_utils(morse_active_monitor)

	//------------------------------------------------------//
	//                  new constructor                     //
	//------------------------------------------------------//

    function new (string name = "morse_active_monitor", uvm_component parent);
      super.new(name, parent);
      received_item = new("received_item");
      active_mon_port = new("active_mon_port", this);
    endfunction

	//------------------------------------------------------//
	//                   build phase                        //
	//------------------------------------------------------//

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db#(virtual morse_interface)::get(this, "", "vif", vif))
			`uvm_fatal("NOVIF",{"virtual interface must be set for: MORSE ACTIVE MONITOR ",get_full_name(),".vif"});
	endfunction

	//------------------------------------------------------//
	//                     run phase                        //
	//------------------------------------------------------//

    task run_phase(uvm_phase phase);
      repeat(4) @(posedge vif.mon_cb);
      forever begin
	receive_inputs();
      end
    endtask

	//------------------------------------------------------//
	//                ACTIVE_MONITOR CODE                   //
	//------------------------------------------------------//

    task receive_inputs();
      //repeat(1) @(posedge vif.mon_cb);
      get_inp_from_if();
      if(received_item.rst) begin
        if(received_item.char_space_inp && !received_item.dot_inp && !received_item.dash_inp && !received_item.word_space_inp) begin
          repeat(1) @(posedge vif.mon_cb);
        end
        else if(!received_item.char_space_inp && !received_item.dot_inp && !received_item.dash_inp && received_item.word_space_inp) begin
          repeat(5) @(posedge vif.mon_cb);
        end
      end
      active_mon_port.write(received_item);
      `uvm_info("INP_MON", $sformatf("rst = %0d, char_space = %0d, dot = %0d, dash = %0d, word_space = %0d", received_item.rst, received_item.char_space_inp, received_item.dot_inp, received_item.dash_inp, received_item.word_space_inp), UVM_LOW);
      repeat(2) @(posedge vif.mon_cb);
    endtask
  
    //------------------------------------------------------//
	//    capturing the input signals from the interface    //
	//------------------------------------------------------//
  
    task get_inp_from_if();
      received_item.rst 	   = vif.mon_cb.rst;
      received_item.dot_inp 	   = vif.mon_cb.dot_inp;
      received_item.dash_inp 	   = vif.mon_cb.dash_inp;
      received_item.char_space_inp = vif.mon_cb.char_space_inp;
      received_item.word_space_inp = vif.mon_cb.word_space_inp;
    endtask

endclass

