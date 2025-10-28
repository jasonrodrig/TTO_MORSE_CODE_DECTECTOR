class morse_driver extends uvm_driver #(morse_sequence_item);

	// declaring interface handle
	virtual morse_interface.DRV vif;

	// registering the morse_driver to the factory
	`uvm_component_utils(morse_driver)

	//------------------------------------------------------//
	//    Creating a new constructor for morse_driver       //
	//------------------------------------------------------//

	function new (string name = "morse_driver", uvm_component parent);
  	  super.new(name, parent);
	endfunction : new

	//------------------------------------------------------//
	//                     build phase                      //
	//------------------------------------------------------//

	function void build_phase(uvm_phase phase);
	  super.build_phase(phase);
	  if(!uvm_config_db#(virtual morse_interface)::get(this,"","vif", vif))
	    `uvm_fatal("NO_VIF",{"virtual interface must be set for: MORSE_DRIVER ",get_full_name(),".vif"});
	endfunction

	//------------------------------------------------------//
	//                    Run phase                         //
	//------------------------------------------------------//

	task run_phase(uvm_phase phase);
          repeat(3) @(posedge vif.drv_cb);
	  forever begin
	    seq_item_port.get_next_item(req);
	    drive();
	    seq_item_port.item_done();
	  end
	endtask

	//------------------------------------------------------//
	//                   Driver code                        //
	//------------------------------------------------------//

    task drive();
      //driver logic
      send_to_interface();
      if(req.rst) begin
        if(req.char_space_inp && !req.dot_inp && !req.dash_inp && !req.word_space_inp) begin
          repeat(1) @(posedge vif.drv_cb);
        end
        else if(!req.char_space_inp && !req.dot_inp && !req.dash_inp && req.word_space_inp) begin
          repeat(5) @(posedge vif.drv_cb);
        end
      end
     // else begin
      repeat(2) @(posedge vif.drv_cb);
      //end
    endtask

    task send_to_interface();
      vif.drv_cb.rst 		<= req.rst;
      vif.drv_cb.dot_inp 	<= req.dot_inp;
      vif.drv_cb.dash_inp 	<= req.dash_inp;
      vif.drv_cb.char_space_inp <= req.char_space_inp;
      vif.drv_cb.word_space_inp <= req.word_space_inp;
      `uvm_info("DRV", $sformatf("rst = %0d, dot = %0d, dash = %0d, char_space = %0d, word_space = %0d", req.rst, req.dot_inp, req.dash_inp, req.char_space_inp, req.word_space_inp), UVM_LOW);
    endtask

endclass
