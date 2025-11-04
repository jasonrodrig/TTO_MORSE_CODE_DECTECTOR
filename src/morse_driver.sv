/*
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
	int temp1 = 1 ;
	int temp2 = 1 ;
	int temp3 = 1 ;
	int temp4 = 1 ;

	//------------------------------------------------------//
	//                   Driver code                        //
	//------------------------------------------------------//

	task drive();
		//driver logic
		send_to_interface();
		if(req.rst) begin
			if(req.char_space_inp && !req.dot_inp && !req.dash_inp && !req.word_space_inp) begin
				temp1 = 0; 
				repeat(1) @(posedge vif.drv_cb);
			end
			else if(!req.char_space_inp && !req.dot_inp && !req.dash_inp && req.word_space_inp)begin
				temp2 = 0; 
				repeat(1) @(posedge vif.drv_cb);
			end
			else if( !req.char_space_inp && req.dot_inp && !req.dash_inp && !req.word_space_inp ) begin
				temp3 = 0; 
				repeat(1) @(posedge vif.drv_cb);
			end
			else if( !req.char_space_inp && !req.dot_inp && req.dash_inp && !req.word_space_inp ) begin
				temp4 = 0; 
				repeat(1) @(posedge vif.drv_cb);
			end
			else if( !req.char_space_inp && !req.dot_inp && !req.dash_inp && !req.word_space_inp && temp1 == 0 ) begin
				temp1 =1;
				repeat(4) @(posedge vif.drv_cb); 
			end
			else if( !req.char_space_inp && !req.dot_inp && !req.dash_inp && !req.word_space_inp && temp2 == 0 ) begin
				temp2 = 1;
				repeat(8) @(posedge vif.drv_cb); 
			end
			else if( !req.char_space_inp && !req.dot_inp && !req.dash_inp && !req.word_space_inp && temp3 == 0 ) begin
				temp3 = 1;
				repeat(1) @(posedge vif.drv_cb); 
			end
			else if( !req.char_space_inp && !req.dot_inp && !req.dash_inp && !req.word_space_inp && temp4 == 0 ) begin
				temp4 = 1; 
				repeat(1) @(posedge vif.drv_cb); 
			end
			else begin// all inputs high will drive
				repeat(1)@(posedge vif.drv_cb);
		  end
		end 
		else begin
			repeat(1) @(posedge vif.drv_cb);
		end
	endtask

	task send_to_interface();
		vif.drv_cb.rst            <= req.rst;
		vif.drv_cb.dot_inp        <= req.dot_inp;
		vif.drv_cb.dash_inp       <= req.dash_inp;
		vif.drv_cb.char_space_inp <= req.char_space_inp;
		vif.drv_cb.word_space_inp <= req.word_space_inp;
		`uvm_info("DRV", $sformatf("rst = %0d, dot = %0d, dash = %0d, char_space = %0d, word_space = %0d", req.rst, req.dot_inp, req.dash_inp, req.char_space_inp, req.word_space_inp), UVM_LOW);
	endtask

endclass
*/

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

	int char_temp1 = 1 ;
	int char_temp2 = 1 ;
	int char_temp3 = 1 ;
	int char_temp4 = 1 ;
    int char_temp5 = 1 ;

	int word_temp1 = 1 ;
	int word_temp2 = 1 ;
	int word_temp3 = 1 ;
	int word_temp4 = 1 ;
	int word_temp5 = 1 ;
	int word_temp6 = 1 ;
	int word_temp7 = 1 ;
	int word_temp8 = 1 ;
    int word_temp9 = 1 ;

	int dot_temp = 1;
	int dash_temp  = 1;
	//------------------------------------------------------//
	//                   Driver code                        //
	//------------------------------------------------------//

	task drive();
		//driver logic
		send_to_interface();
		//if(req.rst) begin

		if( !req.rst ) begin
			repeat(1) @(posedge vif.drv_cb);
		end

		else if(req.char_space_inp && !req.dot_inp && !req.dash_inp && !req.word_space_inp) begin
			char_temp1 = 0;      
			repeat(1) @(posedge vif.drv_cb);
		end

		else if(!req.char_space_inp && !req.dot_inp && !req.dash_inp && req.word_space_inp)begin
			word_temp1 = 0; 
			repeat(1) @(posedge vif.drv_cb);
		end

		else if( !req.char_space_inp && req.dot_inp && !req.dash_inp && !req.word_space_inp ) begin
			dot_temp = 0; 
			repeat(1) @(posedge vif.drv_cb);
		end

		else if( !req.char_space_inp && !req.dot_inp && req.dash_inp && !req.word_space_inp ) begin
			dash_temp = 0; 
			repeat(1) @(posedge vif.drv_cb);
		end

						//1st word count ->
		else if( !req.char_space_inp && !req.dot_inp && !req.dash_inp && !req.word_space_inp && char_temp1 == 0 ) begin
			char_temp1 = 1;
			char_temp2 = 0;
			repeat(1) @(posedge vif.drv_cb);  
		end

						//2nd word count ->
		else if( !req.char_space_inp && !req.dot_inp && !req.dash_inp && !req.word_space_inp && char_temp2 == 0 ) begin
			char_temp2 = 1;
			char_temp3 = 0;
			repeat(1) @(posedge vif.drv_cb);  
		end

						//3rd word count ->
		else if( !req.char_space_inp && !req.dot_inp && !req.dash_inp && !req.word_space_inp && char_temp3 == 0 ) begin
			char_temp3 = 1;
			char_temp4 = 0;
			repeat(1) @(posedge vif.drv_cb);  
		end

						//4th word count ->
		else if( !req.char_space_inp && !req.dot_inp && !req.dash_inp && !req.word_space_inp && char_temp4 == 0 ) begin
			char_temp4 = 1;
            char_temp5 = 0;
			repeat(1) @(posedge vif.drv_cb);  
		end
 
                 //5th word count ->       
      else if( !req.char_space_inp && !req.dot_inp && !req.dash_inp && !req.word_space_inp && char_temp5 == 0 ) begin
			char_temp5 = 1;
			repeat(1) @(posedge vif.drv_cb);  
		end
						//1st word count
		else if( !req.char_space_inp && !req.dot_inp && !req.dash_inp && !req.word_space_inp && word_temp1 == 0 ) begin
			word_temp1 = 1;
			word_temp2 = 0;
			repeat(1) @(posedge vif.drv_cb); 
		end
						// 2nd word count
		else if( !req.char_space_inp && !req.dot_inp && !req.dash_inp && !req.word_space_inp && word_temp2 == 0 ) begin
			word_temp2 = 1;
			word_temp3 = 0;
			repeat(1) @(posedge vif.drv_cb); 
		end

						//3rd word count
		else if( !req.char_space_inp && !req.dot_inp && !req.dash_inp && !req.word_space_inp && word_temp3 == 0 ) begin
			word_temp3 = 1;
			word_temp4 = 0;
			repeat(1) @(posedge vif.drv_cb); 
		end

						// 4th word count
		else if( !req.char_space_inp && !req.dot_inp && !req.dash_inp && !req.word_space_inp && word_temp4 == 0 ) begin
			word_temp4 = 1;
			word_temp5 = 0;
			repeat(1) @(posedge vif.drv_cb); 
		end

						//5th word count
		else if( !req.char_space_inp && !req.dot_inp && !req.dash_inp && !req.word_space_inp && word_temp5 == 0 ) begin
			word_temp5 = 1;
			word_temp6 = 0;
			repeat(1) @(posedge vif.drv_cb); 
		end
						// 6th word count
		else if( !req.char_space_inp && !req.dot_inp && !req.dash_inp && !req.word_space_inp && word_temp6 == 0 ) begin
			word_temp6 = 1;
			word_temp7 = 0;
			repeat(1) @(posedge vif.drv_cb); 
		end

						//7th word count
		else if( !req.char_space_inp && !req.dot_inp && !req.dash_inp && !req.word_space_inp && word_temp7 == 0 ) begin
			word_temp7 = 1;
			word_temp8 = 0;
			repeat(1) @(posedge vif.drv_cb); 
		end

						// 8th word count
		else if( !req.char_space_inp && !req.dot_inp && !req.dash_inp && !req.word_space_inp && word_temp8 == 0 ) begin
			word_temp8 = 1;
            word_temp9 = 0;
			repeat(1) @(posedge vif.drv_cb); 
		end
			
      // 9th word count
      else if( !req.char_space_inp && !req.dot_inp && !req.dash_inp && !req.word_space_inp && word_temp9 == 0 ) begin
			word_temp9 = 1;
			repeat(1) @(posedge vif.drv_cb); 
		end
      
      
		else if( !req.char_space_inp && !req.dot_inp && !req.dash_inp && !req.word_space_inp && dot_temp == 0 ) begin
			dot_temp = 1;
			repeat(1) @(posedge vif.drv_cb); 
		end

		else if( !req.char_space_inp && !req.dot_inp && !req.dash_inp && !req.word_space_inp && dash_temp == 0 ) begin
			dash_temp = 1; 
			repeat(1) @(posedge vif.drv_cb); 
		end

		else begin// all inputs high will drive
			repeat(1)@(posedge vif.drv_cb);
		end
		//end 
		//else begin
		//	repeat(1) @(posedge vif.drv_cb);
		//end
	endtask

	task send_to_interface();
		vif.drv_cb.rst            <= req.rst;
		vif.drv_cb.dot_inp        <= req.dot_inp;
		vif.drv_cb.dash_inp       <= req.dash_inp;
		vif.drv_cb.char_space_inp <= req.char_space_inp;
		vif.drv_cb.word_space_inp <= req.word_space_inp;
		`uvm_info("DRV", $sformatf("rst = %0d, dot = %0d, dash = %0d, char_space = %0d, word_space = %0d", req.rst, req.dot_inp, req.dash_inp, req.char_space_inp, req.word_space_inp), UVM_LOW);
	endtask

endclass
