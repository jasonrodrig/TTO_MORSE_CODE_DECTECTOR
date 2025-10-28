class morse_base_sequence extends uvm_sequence#(morse_sequence_item);

	//------------------------------------------------------//
	//    registering morse_sequence object to the factory    //  
	//------------------------------------------------------//

	`uvm_object_utils(morse_base_sequence)

	//------------------------------------------------------//
	//    Creating a new constructor for morse_sequence       //  
	//------------------------------------------------------//

	function new(string name = "morse_base_sequence");
		super.new(name);
	endfunction

	//------------------------------------------------------//
	//  Task to generate, randomize, and send dot, dash ,   //
	//  char space and word space sequence items repeatedly //
	//                  until completion                    //  
	//------------------------------------------------------//

	task send_dot();
		`uvm_do_with(req, {req.dot_inp==1; req.dash_inp==0; req.char_space_inp==0; req.word_space_inp==0;})
		req.print();
	endtask

	task send_dash();
		`uvm_do_with(req, {req.dot_inp==0; req.dash_inp==1; req.char_space_inp==0; req.word_space_inp==0;})
		req.print();
	endtask

	task send_char_space();
		`uvm_do_with(req, {req.dot_inp==0; req.dash_inp==0; req.char_space_inp==1; req.word_space_inp==0;})
		req.print();
	endtask

	task send_word_space();
		`uvm_do_with(req, {req.dot_inp==0; req.dash_inp==0; req.char_space_inp==0; req.word_space_inp==1;})
		req.print();
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

//------------------------------------------------------//
//              morse character sequence                //  
//------------------------------------------------------//

class morse_character_sequence extends morse_base_sequence;
	`uvm_object_utils(morse_character_sequence)

	//randomizing characters in a form of ascii values.
	rand int character_number;
	constraint aplhabet_range { character_number inside {[97:122]};}

	function new(string name="morse_character_sequence");
		super.new(name);
	endfunction

	task body();
		string morse_table[string];
		string letter;
		// Morse lookup table for letters
		morse_table["a"] = ".-";
		morse_table["b"] = "-...";
		morse_table["c"] = "-.-.";
		morse_table["d"] = "-..";
		morse_table["e"] = ".";
		morse_table["f"] = "..-.";
		morse_table["g"] = "--.";
		morse_table["h"] = "....";
		morse_table["i"] = "..";
		morse_table["j"] = ".---";
		morse_table["k"] = "-.-";
		morse_table["l"] = ".-..";
		morse_table["m"] = "--";
		morse_table["n"] = "-.";
		morse_table["o"] = "---";
		morse_table["p"] = ".--.";
		morse_table["q"] = "--.-";
		morse_table["r"] = ".-.";
		morse_table["s"] = "...";
		morse_table["t"] = "-";
		morse_table["u"] = "..-";
		morse_table["v"] = "...-";
		morse_table["w"] = ".--";
		morse_table["x"] = "-..-";
		morse_table["y"] = "-.--";
		morse_table["z"] = "--..";

		if (!randomize()) `uvm_fatal("RAND_FAIL", "Failed to randomize character_number")

		letter = $sformatf("%s", byte'(character_number));
		if (letter == " ") begin
			send_word_space(); // space between word
		end
		else if (morse_table.exists(letter)) begin
			string code = morse_table[letter];
			foreach (code[j]) begin
				if (code[j] == ".")
					send_dot();
				else if (code[j] == "-")
					send_dash();
			end
			send_char_space(); // space between characters
		end
	endtask
endclass

//------------------------------------------------------//
//              morse number sequence                   //  
//------------------------------------------------------//

class morse_number_sequence extends morse_base_sequence;
	`uvm_object_utils(morse_number_sequence)

	//randomizing morse numbers in a form of ascii values.
	rand int morse_number;
	constraint number_range { morse_number inside {[48:57]};}

	function new(string name="morse_number_sequence");
		super.new(name);
	endfunction

	task body();
		string morse_table[string];
		string number;
		// Morse lookup table for letters
		morse_table["1"] = ".----";
		morse_table["2"] = "..---";
		morse_table["3"] = "...--";
		morse_table["4"] = "....-";
		morse_table["5"] = ".....";
		morse_table["6"] = "-....";
		morse_table["7"] = "--...";
		morse_table["8"] = "---..";
		morse_table["9"] = "----.";
		morse_table["0"] = "-----";

		if (!randomize()) `uvm_fatal("RAND_FAIL", "Failed to randomize character_number")

		number = $sformatf("%s", byte'(morse_number));
		if (number == " ") begin
			send_word_space(); // space between word
		end
		else if (morse_table.exists(number)) begin
			string code = morse_table[number];
			foreach (code[j]) begin
				if (code[j] == ".")
					send_dot();
				else if (code[j] == "-")
					send_dash();
			end
			send_char_space(); // space between characters
		end
	endtask
endclass

//------------------------------------------------------//
//              morse alphanummeric sequence            //  
//------------------------------------------------------//

class morse_alphanumeric_sequence extends morse_base_sequence;
	`uvm_object_utils(morse_alphanumeric_sequence)

	//randomizing characters in a form of ascii values.
	rand int random_number;
	rand int character_number;
	rand int morse_number;

	rand int alphanumeric_number;

	constraint aplhabet_range { character_number inside {[97:122]};}
	constraint number_range   { morse_number inside {[48:57]};}
	constraint random_value   { random_number inside {[1:10]};}
	constraint condition      {
		if( random_number < 5) alphanumeric_number == character_number;
		else                   alphanumeric_number == morse_number;
	}

	function new(string name="morse_alphanumeric_sequence");
		super.new(name);
	endfunction

	task body();
		string morse_table[string];
		string alphanumeric;
		// Morse lookup table for letters
		morse_table["a"] = ".-";
		morse_table["b"] = "-...";
		morse_table["c"] = "-.-.";
		morse_table["d"] = "-..";
		morse_table["e"] = ".";
		morse_table["f"] = "..-.";
		morse_table["g"] = "--.";
		morse_table["h"] = "....";
		morse_table["i"] = "..";
		morse_table["j"] = ".---";
		morse_table["k"] = "-.-";
		morse_table["l"] = ".-..";
		morse_table["m"] = "--";
		morse_table["n"] = "-.";
		morse_table["o"] = "---";
		morse_table["p"] = ".--.";
		morse_table["q"] = "--.-";
		morse_table["r"] = ".-.";
		morse_table["s"] = "...";
		morse_table["t"] = "-";
		morse_table["u"] = "..-";
		morse_table["v"] = "...-";
		morse_table["w"] = ".--";
		morse_table["x"] = "-..-";
		morse_table["y"] = "-.--";
		morse_table["z"] = "--..";
		morse_table["1"] = ".----";
		morse_table["2"] = "..---";
		morse_table["3"] = "...--";
		morse_table["4"] = "....-";
		morse_table["5"] = ".....";
		morse_table["6"] = "-....";
		morse_table["7"] = "--...";
		morse_table["8"] = "---..";
		morse_table["9"] = "----.";
		morse_table["0"] = "-----";

		if (!randomize()) `uvm_fatal("RAND_FAIL", "Failed to randomize character_number")

		alphanumeric = $sformatf("%s", byte'(alphanumeric_number));
		if (alphanumeric == " ") begin
			send_word_space(); // space between word
		end
		else if (morse_table.exists(alphanumeric)) begin
			string code = morse_table[alphanumeric];
			foreach (code[j]) begin
				if (code[j] == ".")
					send_dot();
				else if (code[j] == "-")
					send_dash();
			end
			send_char_space(); // space between characters
		end
	endtask
endclass

//------------------------------------------------------//
//                 word paring sequence                 //  
//------------------------------------------------------//

class word_parsing_sequence extends morse_base_sequence;
	`uvm_object_utils(word_parsing_sequence)

	string text = "sos 123";

	function new(string name="word_parsing_sequence");
		super.new(name);
	endfunction

	task body();
		string morse_table[string];
		string alphanumeric;
		// Morse lookup table for letters
		morse_table["a"] = ".-";
		morse_table["b"] = "-...";
		morse_table["c"] = "-.-.";
		morse_table["d"] = "-..";
		morse_table["e"] = ".";
		morse_table["f"] = "..-.";
		morse_table["g"] = "--.";
		morse_table["h"] = "....";
		morse_table["i"] = "..";
		morse_table["j"] = ".---";
		morse_table["k"] = "-.-";
		morse_table["l"] = ".-..";
		morse_table["m"] = "--";
		morse_table["n"] = "-.";
		morse_table["o"] = "---";
		morse_table["p"] = ".--.";
		morse_table["q"] = "--.-";
		morse_table["r"] = ".-.";
		morse_table["s"] = "...";
		morse_table["t"] = "-";
		morse_table["u"] = "..-";
		morse_table["v"] = "...-";
		morse_table["w"] = ".--";
		morse_table["x"] = "-..-";
		morse_table["y"] = "-.--";
		morse_table["z"] = "--..";
		morse_table["1"] = ".----";
		morse_table["2"] = "..---";
		morse_table["3"] = "...--";
		morse_table["4"] = "....-";
		morse_table["5"] = ".....";
		morse_table["6"] = "-....";
		morse_table["7"] = "--...";
		morse_table["8"] = "---..";
		morse_table["9"] = "----.";
		morse_table["0"] = "-----";

		//text = "SOS 123";

		foreach(text[i]) begin
			alphanumeric = text.substr(i,i);
			if (alphanumeric == " ") begin
				send_word_space(); // space between word
			end
			else if (morse_table.exists(alphanumeric)) begin
				string code = morse_table[alphanumeric];
				foreach (code[j]) begin
					if (code[j] == ".")
						send_dot();
					else if (code[j] == "-")
						send_dash();
				end
				send_char_space(); // space between characters
			end
		end
	endtask
endclass

//------------------------------------------------------//
//                 word paring sequence                 //  
//------------------------------------------------------//

class word_sequence extends morse_base_sequence;
	`uvm_object_utils(word_sequence)

	rand int index;
	string text[5] = { "S O S" , "HELLO" , "9MORSE6" , "CODE123" , "555WORLD"  };

	constraint range{index inside {[0:4]};}

	function new(string name="word_sequence");
		super.new(name);
	endfunction

	task body();
		string morse_table[string];
		string alphanumeric;
		string selected_text;
		// Morse lookup table for letters
		morse_table["a"] = ".-";
		morse_table["b"] = "-...";
		morse_table["c"] = "-.-.";
		morse_table["d"] = "-..";
		morse_table["e"] = ".";
		morse_table["f"] = "..-.";
		morse_table["g"] = "--.";
		morse_table["h"] = "....";
		morse_table["i"] = "..";
		morse_table["j"] = ".---";
		morse_table["k"] = "-.-";
		morse_table["l"] = ".-..";
		morse_table["m"] = "--";
		morse_table["n"] = "-.";
		morse_table["o"] = "---";
		morse_table["p"] = ".--.";
		morse_table["q"] = "--.-";
		morse_table["r"] = ".-.";
		morse_table["s"] = "...";
		morse_table["t"] = "-";
		morse_table["u"] = "..-";
		morse_table["v"] = "...-";
		morse_table["w"] = ".--";
		morse_table["x"] = "-..-";
		morse_table["y"] = "-.--";
		morse_table["z"] = "--..";
		morse_table["1"] = ".----";
		morse_table["2"] = "..---";
		morse_table["3"] = "...--";
		morse_table["4"] = "....-";
		morse_table["5"] = ".....";
		morse_table["6"] = "-....";
		morse_table["7"] = "--...";
		morse_table["8"] = "---..";
		morse_table["9"] = "----.";
		morse_table["0"] = "-----";

		if (!randomize()) `uvm_fatal("RAND_FAIL", "Failed to randomize index")

		selected_text = text[index];
		//$display(" Randomly selected text = %s", selected_text);

		foreach(selected_text[i]) begin
			alphanumeric = selected_text.substr(i,i);

			if (alphanumeric == " ") begin
				send_word_space(); // space between word
			end
			else if (morse_table.exists(alphanumeric)) begin
				string code = morse_table[alphanumeric];
				foreach (code[j]) begin
					if (code[j] == ".")
						send_dot();
					else if (code[j] == "-")
						send_dash();
				end
				send_char_space(); // space between characters
			end
		end
	endtask
endclass

