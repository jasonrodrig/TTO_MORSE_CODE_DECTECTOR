/*
class morse_scoreboard extends uvm_scoreboard;

    // handle decleration for morse_sequnce item sorting input and output transaction signals   
    morse_sequence_item inp_mon_item;
    morse_sequence_item out_mon_item;

    // registering the morse_scoareboard to the factory 
    `uvm_component_utils(morse_scoreboard)

    // analysis fifo declaration for both active_monitor and passive_monitor    
    uvm_tlm_analysis_fifo#(morse_sequence_item) active_scb_fifo;
    uvm_tlm_analysis_fifo#(morse_sequence_item) passive_scb_fifo;

    // Creating PASS AND FAIL decleration
    int PASS, FAIL;
  
   //buffer to store the pattern
  bit [2:0]buffer[$];
  //int buffer[$];
   //to track size
   bit [2:0]size;

    //------------------------------------------------------//
    //     Creating New constructor for morse_scoreboard    //   
    //------------------------------------------------------//

    function new(string name = "morse_scoreboard", uvm_component parent);
        super.new(name, parent);
      active_scb_fifo  = new("active_scb_fifo" , this);
      passive_scb_fifo = new("passive_scb_fifo", this); 
    endfunction


    //------------------------------------------------------//
    //    Reporting Pass and failure for each testcases     //   
    //------------------------------------------------------//

    function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        $display("Passes = %0d | Fails = %0d", PASS, FAIL);
    endfunction

    //------------------------------------------------------//
    //          Running the morse_reference model           //
    //------------------------------------------------------//

    task run_phase(uvm_phase phase);
        forever 
          begin
            fork
              active_scb_fifo.get(inp_mon_item);
              passive_scb_fifo.get(out_mon_item);
            join
            compare(inp_mon_item,out_mon_item);
          end
    endtask
  
    //------------------------------------------------------//
    //           comparision task for pass/fail                    //
    //------------------------------------------------------//   
    task automatic check_and_report(
      string tag,
      byte expected_val,
      byte actual_val,
      bit do_delete
    );
      if (expected_val == actual_val) begin
        `uvm_info(tag, $sformatf("actual=%0h | expected=%0h, MATCH", actual_val, expected_val), UVM_LOW);
        if (do_delete) buffer.delete();
        `uvm_info(tag, $sformatf("buffer size = %0d", buffer.size()), UVM_LOW);
        PASS++;
      end
      else begin
        `uvm_info(tag, $sformatf("actual = %0h | expected = %0h , MISMATCH", actual_val, expected_val), UVM_LOW);
        if (do_delete) buffer.delete();
        `uvm_info(tag, $sformatf("buffer size = %0d", buffer.size()), UVM_LOW);
        FAIL++;
    end
  endtask
  
  //------------------------------------------------------//
  //          Actual comparision task                     //
  //------------------------------------------------------//
  task compare(morse_sequence_item expected, morse_sequence_item actual);
    
     // RESET condition
    if (expected.rst == 0) begin
      check_and_report("SCOREBOARD-RESET", 8'hFF, actual.sout, 1); 
      `uvm_info("SCOREBOARD-RESET", "Reset detected | buffer cleared and sout=0xFF verified", UVM_LOW);
      return;
    end
    
    // DOT condition
    if (expected.dot_inp==1 && expected.dash_inp==0 && expected.char_space_inp==0 && expected.word_space_inp==0) begin
      buffer.push_back(`dot);
      check_and_report("SCOREBOARD-DOT", 8'hFF, actual.sout, 0);
      `uvm_info("SCOREBOARD-DOT",$sformatf("values in the buffer %0p",buffer),UVM_LOW);
    end

    // DASH condition
    else if (expected.dash_inp==1 && expected.dot_inp==0 && expected.char_space_inp==0 && expected.word_space_inp==0) begin
      buffer.push_back(`dash);
      check_and_report("SCOREBOARD-DASH", 8'hFF, actual.sout, 0);
      `uvm_info("SCOREBOARD-DASH",$sformatf("values in the buffer %0p",buffer),UVM_LOW);
    end
    
    // CHAR_SPACE condition
    else if (expected.char_space_inp==1 && expected.dot_inp==0 && expected.dash_inp==0 && expected.word_space_inp==0) begin
      size = buffer.size();

      case (size)
       1: begin
         if (buffer[0] == `e)
            check_and_report("SCOREBOARD-CHAR", 8'h65, actual.sout, 1); // 'e'
         else if (buffer[0] == `t)
            check_and_report("SCOREBOARD-CHAR", 8'h74, actual.sout, 1); // 't'
        end
       2: begin
         if ({buffer[0],buffer[1]} == `a)
           check_and_report("SCOREBOARD-CHAR", 8'h61, actual.sout, 1); // 'a'
         else if ({buffer[0],buffer[1]} == `i)
           check_and_report("SCOREBOARD-CHAR", 8'h69, actual.sout, 1); // 'i'
         else if ({buffer[0],buffer[1]} == `n)
           check_and_report("SCOREBOARD-CHAR", 8'h6E, actual.sout, 1); // 'n'
         else if ({buffer[0],buffer[1]} == `m)
           check_and_report("SCOREBOARD-CHAR", 8'h6D, actual.sout, 1); // 'm'
       end
       3: begin
         if ({buffer[0],buffer[1]} == `d)
           check_and_report("SCOREBOARD-CHAR", 8'h64, actual.sout, 1); // 'd'
         else if ({buffer[0],buffer[1],buffer[2]} == `g)
           check_and_report("SCOREBOARD-CHAR", 8'h67, actual.sout, 1); // 'g'
         else if ({buffer[0],buffer[1],buffer[2]} == `r)
           check_and_report("SCOREBOARD-CHAR", 8'h72, actual.sout, 1); // 'r'
         else if ({buffer[0],buffer[1],buffer[2]} == `s)
           check_and_report("SCOREBOARD-CHAR", 8'h73, actual.sout, 1); // 's'
         else if ({buffer[0],buffer[1],buffer[2]} == `o)
           check_and_report("SCOREBOARD-CHAR", 8'h6F, actual.sout, 1); // 'o'
         else if ({buffer[0],buffer[1],buffer[2]} == `k)
           check_and_report("SCOREBOARD-CHAR", 8'h6B, actual.sout, 1); // 'k'
         else if ({buffer[0],buffer[1],buffer[2]} == `u)
           check_and_report("SCOREBOARD-CHAR", 8'h75, actual.sout, 1); // 'u'
         else if ({buffer[0],buffer[1],buffer[2]} == `w)
           check_and_report("SCOREBOARD-CHAR", 8'h77, actual.sout, 1); // 'w'
       end
       4: begin
         if ({buffer[0],buffer[1],buffer[2],buffer[3]} == `b)
           check_and_report("SCOREBOARD-CHAR", 8'h62, actual.sout, 1); // 'b'
         else if ({buffer[0],buffer[1],buffer[2],buffer[3]} == `c)
           check_and_report("SCOREBOARD-CHAR", 8'h63, actual.sout, 1); // 'c'
         else if ({buffer[0],buffer[1],buffer[2],buffer[3]} == `f)
           check_and_report("SCOREBOARD-CHAR", 8'h66, actual.sout, 1); // 'f'
         else if ({buffer[0],buffer[1],buffer[2],buffer[3]} == `h)
            check_and_report("SCOREBOARD-CHAR", 8'h68, actual.sout, 1); // 'h'
         else if ({buffer[0],buffer[1],buffer[2],buffer[3]} == `j)
           check_and_report("SCOREBOARD-CHAR", 8'h6A, actual.sout, 1); // 'j'
         else if ({buffer[0],buffer[1],buffer[2],buffer[3]} == `l)
           check_and_report("SCOREBOARD-CHAR", 8'h6C, actual.sout, 1); // 'l'
         else if ({buffer[0],buffer[1],buffer[2],buffer[3]} == `p)
           check_and_report("SCOREBOARD-CHAR", 8'h70, actual.sout, 1); // 'p'
         else if ({buffer[0],buffer[1],buffer[2],buffer[3]} == `q)
           check_and_report("SCOREBOARD-CHAR", 8'h71, actual.sout, 1); // 'q'
         else if ({buffer[0],buffer[1],buffer[2],buffer[3]} == `v)
           check_and_report("SCOREBOARD-CHAR", 8'h76, actual.sout, 1); // 'v'
         else if ({buffer[0],buffer[1],buffer[2],buffer[3]} == `x)
           check_and_report("SCOREBOARD-CHAR", 8'h78, actual.sout, 1); // 'x'
         else if ({buffer[0],buffer[1],buffer[2],buffer[3]} == `y)
           check_and_report("SCOREBOARD-CHAR", 8'h79, actual.sout, 1); // 'y'
         else if ({buffer[0],buffer[1],buffer[2],buffer[3]} == `z)
           check_and_report("SCOREBOARD-CHAR", 8'h7A, actual.sout, 1); // 'z'
         else
           check_and_report("SCOREBOARD-CHAR", 8'hFF, actual.sout, 0); // Unknown or invalid
       end
       5: begin
         if ({buffer[0],buffer[1],buffer[2],buffer[3],buffer[4]} == `zero)
           check_and_report("SCOREBOARD-CHAR", 8'h30, actual.sout, 1); // '0'
         else if ({buffer[0],buffer[1],buffer[2],buffer[3],buffer[4]} == `one)
           check_and_report("SCOREBOARD-CHAR", 8'h31, actual.sout, 1); // '1'
         else if ({buffer[0],buffer[1],buffer[2],buffer[3],buffer[4]} == `two)
           check_and_report("SCOREBOARD-CHAR", 8'h32, actual.sout, 1); // '2'
         else if ({buffer[0],buffer[1],buffer[2],buffer[3],buffer[4]} == `three)
           check_and_report("SCOREBOARD-CHAR", 8'h33, actual.sout, 1); // '3'
         else if ({buffer[0],buffer[1],buffer[2],buffer[3],buffer[4]} == `four)
           check_and_report("SCOREBOARD-CHAR", 8'h34, actual.sout, 1); // '4'
         else if ({buffer[0],buffer[1],buffer[2],buffer[3],buffer[4]} == `five)
           check_and_report("SCOREBOARD-CHAR", 8'h35, actual.sout, 1); // '5'
         else if ({buffer[0],buffer[1],buffer[2],buffer[3],buffer[4]} == `six)
           check_and_report("SCOREBOARD-CHAR", 8'h36, actual.sout, 1); // '6'
         else if ({buffer[0],buffer[1],buffer[2],buffer[3],buffer[4]} == `seven)
           check_and_report("SCOREBOARD-CHAR", 8'h37, actual.sout, 1); // '7'
         else if ({buffer[0],buffer[1],buffer[2],buffer[3],buffer[4]} == `eight)
           check_and_report("SCOREBOARD-CHAR", 8'h38, actual.sout, 1); // '8'
         else if ({buffer[0],buffer[1],buffer[2],buffer[3],buffer[4]} == `nine)
           check_and_report("SCOREBOARD-CHAR", 8'h39, actual.sout, 1); // '9'
         else
           check_and_report("SCOREBOARD-CHAR", 8'hFF, actual.sout, 0); // Unknown or invalid
       end
       default: begin
         check_and_report("SCOREBOARD-CHAR", 8'hFF, actual.sout, 0); // Unknown or invalid pattern
       end
      endcase
    end
      
    // WORD_SPACE condition
    else if (expected.word_space_inp==1 && expected.dot_inp==0 && expected.dash_inp==0 && expected.char_space_inp==0) begin
      check_and_report("SCOREBOARD-WORD", 8'h20, actual.sout, 0); // ASCII space (' ')
      `uvm_info("SCOREBOARD-WORD", "Word boundary detected | buffer cleared", UVM_LOW);
    end
    else begin
      `uvm_info("SCOREBOARD",$sformatf("Multiple inputs are high at same cycle"),UVM_LOW);
      `uvm_info("SCOREBOARD",$sformatf("buffer size = %0d actual= %0h |   expected=%0h",buffer.size(),actual.sout,expected.sout),UVM_LOW);
    end
  endtask
endclass


*/


class morse_scoreboard extends uvm_scoreboard;

	// handle decleration for morse_sequnce item sorting input and output transaction signals
	morse_sequence_item inp_mon_item;
	morse_sequence_item out_mon_item;

	// registering the morse_scoareboard to the factory
	`uvm_component_utils(morse_scoreboard)

	// analysis fifo declaration for both active_monitor and passive_monitor
	uvm_tlm_analysis_fifo#(morse_sequence_item) active_scb_fifo;
	uvm_tlm_analysis_fifo#(morse_sequence_item) passive_scb_fifo;

	// Creating PASS AND FAIL decleration
	int PASS, FAIL;

	//buffer to store the pattern
	bit [2:0] buffer[$];
	//int buffer[$];
	//to track size
	bit [2:0]size;

	int char_temp = 1;
	int word_temp = 1;
	int char_count; 
	int word_count;
	//------------------------------------------------------//
	//     Creating New constructor for morse_scoreboard    //
	//------------------------------------------------------//

	function new(string name = "morse_scoreboard", uvm_component parent);
		super.new(name, parent);
		active_scb_fifo  = new("active_scb_fifo" , this);
		passive_scb_fifo = new("passive_scb_fifo", this);
	endfunction


	//------------------------------------------------------//
	//    Reporting Pass and failure for each testcases     //
	//------------------------------------------------------//

	function void report_phase(uvm_phase phase);
		super.report_phase(phase);
		$display("Passes = %0d | Fails = %0d", PASS, FAIL);
	endfunction

	//------------------------------------------------------//
	//          Running the morse_reference model           //
	//------------------------------------------------------//

	task run_phase(uvm_phase phase);
		forever
		begin
			fork
				active_scb_fifo.get(inp_mon_item);
				passive_scb_fifo.get(out_mon_item);
			join
			compare(inp_mon_item,out_mon_item);
		end
	endtask

	//------------------------------------------------------//
	//           comparision task for pass/fail                    //
	//------------------------------------------------------//
	task automatic check_and_report(
		string tag,
		byte expected_val,
		byte actual_val,
		bit do_delete
	);
		if (expected_val == actual_val) begin
			`uvm_info(tag, $sformatf("sout = %0h | actual=expected, MATCH", actual_val), UVM_LOW);
			$display("\n");
			if (do_delete) buffer.delete();
			`uvm_info(tag, $sformatf("buffer size = %0d", buffer.size()), UVM_LOW);
			PASS++;
		end
		else begin
			`uvm_info(tag, $sformatf("actual = %0h | expected = %0h , MISMATCH", actual_val, expected_val), UVM_LOW);
			$display("\n");
			if (do_delete) buffer.delete();
			`uvm_info(tag, $sformatf("buffer size = %0d", buffer.size()), UVM_LOW);
			FAIL++;
		end
	endtask

	//------------------------------------------------------//
	//          Actual comparision task                     //
	//------------------------------------------------------//
	task compare(morse_sequence_item expected, morse_sequence_item actual);

		// RESET condition
		if (expected.rst == 0) begin
			check_and_report("SCOREBOARD-RESET", 8'hFF, actual.sout, 1);
			`uvm_info("SCOREBOARD-RESET", "Reset detected | buffer cleared and sout=0xFF verified", UVM_LOW);
			return;
		end

		// DOT condition
		if (expected.dot_inp==1 && expected.dash_inp==0 && expected.char_space_inp==0 && expected.word_space_inp==0) begin
			buffer.push_back(`dot);
			check_and_report("SCOREBOARD-DOT", 8'hFF, actual.sout, 0);
			`uvm_info("SCOREBOARD-DOT",$sformatf("values in the buffer %0p",buffer),UVM_LOW);
			$display("\n");
		end

		// DASH condition
		else if (expected.dash_inp==1 && expected.dot_inp==0 && expected.char_space_inp==0 && expected.word_space_inp==0) begin
			buffer.push_back(`dash);
			check_and_report("SCOREBOARD-DASH", 8'hFF, actual.sout, 0);
			`uvm_info("SCOREBOARD-DASH",$sformatf("values in the buffer %0p",buffer),UVM_LOW);
			$display("\n");
		end

		// char input starts here 

		else if (expected.char_space_inp==1 && expected.dot_inp==0 && expected.dash_inp==0 && expected.word_space_inp==0 && char_temp == 1 ) begin
			char_temp = 0;
			char_count = 1;
			check_and_report("SCOREBOARD-CHAR DELAY", 8'hFF, actual.sout, 0);
		end

		else if (expected.char_space_inp==0 && expected.dot_inp==0 && expected.dash_inp==0 && expected.word_space_inp==0 && char_temp == 0  ) begin

			if(char_count == 2) begin
				// CHAR_SPACE conditin
				$display("character decodding at count = %d",char_count);
				char_temp = 1;
				char_count = 0;
				size = buffer.size();

				case (size)
					1: begin
						if (buffer[0] == `e)
							check_and_report("SCOREBOARD-CHAR", 8'h65, actual.sout, 1); // 'e'
						else if (buffer[0] == `t)
							check_and_report("SCOREBOARD-CHAR", 8'h74, actual.sout, 1); // 't'
					end
					2: begin
						if ({buffer[0],buffer[1]} == `a)
							check_and_report("SCOREBOARD-CHAR", 8'h61, actual.sout, 1); // 'a'
						else if ({buffer[0],buffer[1]} == `i)
							check_and_report("SCOREBOARD-CHAR", 8'h69, actual.sout, 1); // 'i'
						else if ({buffer[0],buffer[1]} == `n)
							check_and_report("SCOREBOARD-CHAR", 8'h6E, actual.sout, 1); // 'n'
						else if ({buffer[0],buffer[1]} == `m)
							check_and_report("SCOREBOARD-CHAR", 8'h6D, actual.sout, 1); // 'm'
					end
					3: begin
						if ({buffer[0],buffer[1],buffer[2]} == `d)
							check_and_report("SCOREBOARD-CHAR", 8'h64, actual.sout, 1); // 'd'
						else if ({buffer[0],buffer[1],buffer[2]} == `g)
							check_and_report("SCOREBOARD-CHAR", 8'h67, actual.sout, 1); // 'g'
						else if ({buffer[0],buffer[1],buffer[2]} == `r)
							check_and_report("SCOREBOARD-CHAR", 8'h72, actual.sout, 1); // 'r'
						else if ({buffer[0],buffer[1],buffer[2]} == `s)
							check_and_report("SCOREBOARD-CHAR", 8'h73, actual.sout, 1); // 's'
						else if ({buffer[0],buffer[1],buffer[2]} == `o)
							check_and_report("SCOREBOARD-CHAR", 8'h6F, actual.sout, 1); // 'o'
						else if ({buffer[0],buffer[1],buffer[2]} == `k)
							check_and_report("SCOREBOARD-CHAR", 8'h6B, actual.sout, 1); // 'k'
						else if ({buffer[0],buffer[1],buffer[2]} == `u)
							check_and_report("SCOREBOARD-CHAR", 8'h75, actual.sout, 1); // 'u'
						else if ({buffer[0],buffer[1],buffer[2]} == `w)
							check_and_report("SCOREBOARD-CHAR", 8'h77, actual.sout, 1); // 'w'
					end
					4: begin
						if ({buffer[0],buffer[1],buffer[2],buffer[3]} == `b)
							check_and_report("SCOREBOARD-CHAR", 8'h62, actual.sout, 1); // 'b'
						else if ({buffer[0],buffer[1],buffer[2],buffer[3]} == `c)
							check_and_report("SCOREBOARD-CHAR", 8'h63, actual.sout, 1); // 'c'
						else if ({buffer[0],buffer[1],buffer[2],buffer[3]} == `f)
							check_and_report("SCOREBOARD-CHAR", 8'h66, actual.sout, 1); // 'f'
						else if ({buffer[0],buffer[1],buffer[2],buffer[3]} == `h)
							check_and_report("SCOREBOARD-CHAR", 8'h68, actual.sout, 1); // 'h'
						else if ({buffer[0],buffer[1],buffer[2],buffer[3]} == `j)
							check_and_report("SCOREBOARD-CHAR", 8'h6A, actual.sout, 1); // 'j'
						else if ({buffer[0],buffer[1],buffer[2],buffer[3]} == `l)
							check_and_report("SCOREBOARD-CHAR", 8'h6C, actual.sout, 1); // 'l'
						else if ({buffer[0],buffer[1],buffer[2],buffer[3]} == `p)
							check_and_report("SCOREBOARD-CHAR", 8'h70, actual.sout, 1); // 'p'
						else if ({buffer[0],buffer[1],buffer[2],buffer[3]} == `q)
							check_and_report("SCOREBOARD-CHAR", 8'h71, actual.sout, 1); // 'q'
						else if ({buffer[0],buffer[1],buffer[2],buffer[3]} == `v)
							check_and_report("SCOREBOARD-CHAR", 8'h76, actual.sout, 1); // 'v'
						else if ({buffer[0],buffer[1],buffer[2],buffer[3]} == `x)
							check_and_report("SCOREBOARD-CHAR", 8'h78, actual.sout, 1); // 'x'
						else if ({buffer[0],buffer[1],buffer[2],buffer[3]} == `y)
							check_and_report("SCOREBOARD-CHAR", 8'h79, actual.sout, 1); // 'y'
						else if ({buffer[0],buffer[1],buffer[2],buffer[3]} == `z)
							check_and_report("SCOREBOARD-CHAR", 8'h7A, actual.sout, 1); // 'z'
						else
							check_and_report("SCOREBOARD-CHAR", 8'hFF, actual.sout, 1); // Unknown or invalid
					end
					5: begin
						if ({buffer[0],buffer[1],buffer[2],buffer[3],buffer[4]} == `zero)
							check_and_report("SCOREBOARD-CHAR", 8'h30, actual.sout, 1); // '0'
						else if ({buffer[0],buffer[1],buffer[2],buffer[3],buffer[4]} == `one)
							check_and_report("SCOREBOARD-CHAR", 8'h31, actual.sout, 1); // '1'
						else if ({buffer[0],buffer[1],buffer[2],buffer[3],buffer[4]} == `two)
							check_and_report("SCOREBOARD-CHAR", 8'h32, actual.sout, 1); // '2'
						else if ({buffer[0],buffer[1],buffer[2],buffer[3],buffer[4]} == `three)
							check_and_report("SCOREBOARD-CHAR", 8'h33, actual.sout, 1); // '3'
						else if ({buffer[0],buffer[1],buffer[2],buffer[3],buffer[4]} == `four)
							check_and_report("SCOREBOARD-CHAR", 8'h34, actual.sout, 1); // '4'
						else if ({buffer[0],buffer[1],buffer[2],buffer[3],buffer[4]} == `five)
							check_and_report("SCOREBOARD-CHAR", 8'h35, actual.sout, 1); // '5'
						else if ({buffer[0],buffer[1],buffer[2],buffer[3],buffer[4]} == `six)
							check_and_report("SCOREBOARD-CHAR", 8'h36, actual.sout, 1); // '6'
						else if ({buffer[0],buffer[1],buffer[2],buffer[3],buffer[4]} == `seven)
							check_and_report("SCOREBOARD-CHAR", 8'h37, actual.sout, 1); // '7'
						else if ({buffer[0],buffer[1],buffer[2],buffer[3],buffer[4]} == `eight)
							check_and_report("SCOREBOARD-CHAR", 8'h38, actual.sout, 1); // '8'
						else if ({buffer[0],buffer[1],buffer[2],buffer[3],buffer[4]} == `nine)
							check_and_report("SCOREBOARD-CHAR", 8'h39, actual.sout, 1); // '9'
						else
							check_and_report("SCOREBOARD-CHAR", 8'hFF, actual.sout, 1); // Unknown or invalid
					end
					default: begin
						check_and_report("SCOREBOARD-CHAR", 8'hFF, actual.sout, 0); // Unknown or invalid pattern
					end
				endcase
			end
			else
			begin
				char_count++;
				$display("count is  %d",char_count);
				check_and_report("SCOREBOARD-CHAR DELAY", 8'hFF, actual.sout, 0);
			end
		end
		//word space_started

		else if (expected.char_space_inp==0 && expected.dot_inp==0 && expected.dash_inp==0 && expected.word_space_inp==1 && word_temp == 1 ) begin
			word_temp = 0;
			word_count = 1;
			check_and_report("SCOREBOARD-WORD DELAY", 8'hFF, actual.sout, 0);
		end

		// WORD_SPACE condition
		else if (expected.word_space_inp==0 && expected.dot_inp==0 && expected.dash_inp==0 && expected.char_space_inp==0 && word_temp == 0) begin
			if(word_count == 6) begin
				$display("word decodding at word_count = %d",word_count);
				word_temp = 1;
				word_count = 0; 
				check_and_report("SCOREBOARD-WORD", 8'h20, actual.sout, 0); // ASCII space (' ')
				`uvm_info("SCOREBOARD-WORD", "Word boundary detected | buffer cleared", UVM_LOW);
			end
			else begin
				word_count++;
				$display("word count is  %d",word_count);
				check_and_report("SCOREBOARD-WORD DELAY", 8'hFF, actual.sout, 0);
			end
		end
		/*  else begin
			// `uvm_info("SCOREBOARD",$sformatf("Multiple inputs are high at same cycle"),UVM_LOW);
			check_and_report("SCOREBOARD-NO INPUT", 8'hFF, actual.sout, 0);   
			`uvm_info("SCOREBOARD",$sformatf("buffer size = %0d actual= %0h |   expected=%0h",buffer.size(),actual.sout,expected.sout),UVM_LOW);
		end
			*/endtask
endclass




