class morse_driver extends uvm_driver #(morse_sequence_item);

	// declaring interface handle
	virtual morse_interface vif;

	// registering the morse_driver to the factory
	`uvm_component_utils(morse_driver)

	//------------------------------------------------------//
	//    Creating a new constructor for morse_driver         //  
	//------------------------------------------------------//

	function new (string name = "morse_driver", uvm_component parent);
		super.new(name, parent);
	endfunction : new

	//------------------------------------------------------//
	//         building config_db in the morse_driver         //  
	//------------------------------------------------------//

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db#(virtual morse_interface)::get(this,"","vif", vif))
			`uvm_fatal("NO_VIF",{"virtual interface must be set for: MORSE_DRIVER ",get_full_name(),".vif"});
	endfunction

	//------------------------------------------------------//
	//                Running the driver                    //  
	//------------------------------------------------------//

	task run_phase(uvm_phase phase);
		forever begin  
			seq_item_port.get_next_item(req);
			morse_driver_code();   
			seq_item_port.item_done();
		end
	endtask

	//------------------------------------------------------//
	//                   Driver code                        //  
	//------------------------------------------------------//

	task morse_driver_code();
   //driver logic
	endtask 


endclass
