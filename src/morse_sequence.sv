class morse_sequence extends uvm_sequence#(morse_sequence_item);

	//------------------------------------------------------//
	//    registering morse_sequence object to the factory    //  
	//------------------------------------------------------//

	`uvm_object_utils(morse_sequence)

	//------------------------------------------------------//
	//    Creating a new constructor for morse_sequence       //  
	//------------------------------------------------------//

	function new(string name = "morse_sequence");
		super.new(name);
	endfunction

	//------------------------------------------------------//
	//  Task to generate, randomize, and send ALU sequence  //
	//         items repeatedly until completion            //  
	//------------------------------------------------------//

	task body();
		repeat(`no_of_items)begin
			req = morse_sequence_item::type_id::create("req");
			wait_for_grant();
			void'(req.randomize());
			send_request(req);
			wait_for_item_done();
		end
	endtask
endclass

//------------------------------------------------------//
//                     reset sequence                   //  
//------------------------------------------------------//

class reset_sequence extends uvm_sequence#(morse_sequence_item);
	`uvm_object_utils(reset_sequence)

	function new(string name = "reset_sequence");
		super.new(name);
	endfunction

	task body();
		`uvm_do_with(req,{ req.rst == 0; } )
	endtask
endclass 



