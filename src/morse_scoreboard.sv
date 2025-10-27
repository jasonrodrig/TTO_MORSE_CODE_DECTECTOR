// ---------signals-----------//
`define dot        3'b001
`define dash       3'b010
`define char_space 3'b011
`define word_space 3'b100
//------alphabets (a-z)-------//
`define a {`dot, `dash}
`define b {`dash, `dot, `dot, `dot}
`define c {`dash, `dot, `dash, `dot}
`define d {`dash, `dot, `dot}
`define e {`dot}
`define f {`dot, `dot, `dash, `dot}
`define g {`dash, `dash, `dot}
`define h {`dot, `dot, `dot, `dot}
`define i {`dot, `dot}
`define j {`dot, `dash, `dash, `dash}
`define k {`dash, `dot, `dash}
`define l {`dot, `dash, `dot, `dot}
`define m {`dash, `dash}
`define n {`dash, `dot}
`define o {`dash, `dash, `dash}
`define p {`dot, `dash, `dash, `dot}
`define q {`dash, `dash, `dot, `dash}
`define r {`dot, `dash, `dot}
`define s {`dot, `dot, `dot}
`define t {`dash}
`define u {`dot, `dot, `dash}
`define v {`dot, `dot, `dot, `dash}
`define w {`dot, `dash, `dash}
`define x {`dash, `dot, `dot, `dash}
`define y {`dash, `dot, `dash, `dash}
`define z {`dash, `dash, `dot, `dot}
//-------Numbers (0–9)---------//
`define zero  {`dash, `dash, `dash, `dash, `dash}
`define one   {`dot,  `dash, `dash, `dash, `dash}
`define two   {`dot,  `dot,  `dash, `dash, `dash}
`define three {`dot,  `dot,  `dot,  `dash, `dash}
`define four  {`dot,  `dot,  `dot,  `dot,  `dash}
`define five  {`dot,  `dot,  `dot,  `dot,  `dot}
`define six   {`dash, `dot,  `dot,  `dot,  `dot}
`define seven {`dash, `dash, `dot,  `dot,  `dot}
`define eight {`dash, `dash, `dash, `dot,  `dot}
`define nine  {`dash, `dash, `dash, `dash, `dot}

class morse_scoreboard extends uvm_scoreboard;

    // handle decleration for morse_sequnce item sorting input and output transaction signals   
    morse_sequence_item inp_mon_item;
    morse_sequence_item out_mon_item;

    // registering the morse_scoareboard to the factory 
    `uvm_component_utils(morse_scoreboard)

    // analysis fifo declaration for both active_monitor and passive_monitor    
    uvm_analysis_fifo#(morse_sequence_item) active_scb_fifo;
    uvm_analysis_fifo#(morse_sequence_item) passive_scb_fifo;

    // Creating PASS AND FAIL decleration
    int PASS, FAIL;
  
   //buffer to store the pattern
  bit [2:0]buffer[5];
  
   //to track the index
   bit [3:0] count;
  
   //to track size
   bit [2:0]size;

    //------------------------------------------------------//
    //     Creating New constructor for morse_scoreboard    //   
    //------------------------------------------------------//

    function new(string name = "morse_scoreboard", uvm_component parent);
        super.new(name, parent);
      active_scb_fifo  = new("active_scb_fifo" , this);
      passive_scb_fifo = new("passive_scb_fifo", this); 
      count=0;
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
    //          Actual comparision task                     //
    //------------------------------------------------------//
  
  task compare(morse_sequence_item expected,morse_sequence_item actual);
    
    if(expected.dot_inp==1 && expected.dash_inp==0 && expected.char_space==0 && expected.word_space==0)
      begin
        
        buffer[count]=`dot;
        count++;
        if(expected.s_out==0 && actual.s_out==0)
          begin
            `uvm_info("SCOREBOARD-DOT",$sformatf("s_out=0 in both actual and expectecd,PASS"),UVM_LOW);
            `uvm_info("SCOREBOARD-DOT",$sformatf("values in the buffer %0p",buffer),UVM_LOW);
            PASS++;
          end
        else
          begin
            `uvm_info("SCOREBOARD-DOT",$sformatf("s_out mismatch actual=%0d | expected = %0d, Fail",actual.s_out,expected.s_out),UVM_LOW);
            `uvm_info("SCOREBOARD-DOT",$sformatf("values in the buffer %0p",buffer),UVM_LOW);
            FAIL++;
          end
      end
    else if(expected.dash_inp==1 && expected.dot_inp==0 && expected.char_space==0 && expected.word_space==0)
      begin
        buffer[count]=`dash;
        count++;
        if(expected.s_out==0 && actual.s_out==0)
          begin
            `uvm_info("SCOREBOARD-DASH",$sformatf("s_out=0 in both actual and expectecd,PASS"),UVM_LOW);
            `uvm_info("SCOREBOARD-DASH",$sformatf("values in the buffer %0p",buffer),UVM_LOW);
            PASS++;
          end
        else
          begin
            `uvm_info("SCOREBOARD-DASH",$sformatf("s_out mismatch actual=%0d | expected = %0d, Fail",actual.s_out,expected.s_out),UVM_LOW);
            `uvm_info("SCOREBOARD-DASH",$sformatf("values in the buffer %0p",buffer),UVM_LOW);
            FAIL++;
          end       
        
      end
    else if(expected.dash_inp==0 && expected.dot_inp==0 && expected.char_space==1 && expected.word_space==0)
      begin
        size=buffer.size();
        
        case(size)
          1:begin
            if(buffer==`e)
              begin
              expected.s_out=8'h65;
                
              if(expected.s_out==actual.s_out)
                begin
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("s_out = %0h | actual=expected, MATCH",actual.s_out),UVM_LOW);
                   buffer.delete();
                   count=0;
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("buffer size = %0d",buffer.size()),UVM_LOW);
                  PASS++;
                end
              else
                begin      
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("actual = %0h | expected = %0h , MISMATCH",actual.s_out,expected.s_out),UVM_LOW);
                   buffer.delete();
                   count=0;
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("buffer size = %0d",buffer.size()),UVM_LOW);
                  FAIL++;                 
                end
               
              end
            else if(buffer==`t)
              begin
              expected.s_out=8'h74;
              if(expected.s_out==actual.s_out)
                begin
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("s_out = %0h | actual=expected, MATCH",actual.s_out),UVM_LOW);
                   buffer.delete();
                   count=0;
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("buffer size = %0d",buffer.size()),UVM_LOW);
                  PASS++;
                end
              else
                begin
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("actual = %0h | expected = %0h , MISMATCH",actual.s_out,expected.s_out),UVM_LOW);
                   buffer.delete();
                   count=0;
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("buffer size = %0d",buffer.size()),UVM_LOW);
                  FAIL++;                 
                end
              end
          end
                   
          2:begin
            if(buffer==`a)
              begin
              expected.s_out=8'h61;
              if(expected.s_out==actual.s_out)
                begin
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("s_out = %0h | actual=expected, MATCH",actual.s_out),UVM_LOW);
                   buffer.delete();
                   count=0;
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("buffer size = %0d",buffer.size()),UVM_LOW);
                  PASS++;
                end
              else
                begin
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("actual = %0h | expected = %0h , MISMATCH",actual.s_out,expected.s_out),UVM_LOW);
                   buffer.delete();
                   count=0;
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("buffer size = %0d",buffer.size()),UVM_LOW);
                  FAIL++;                 
                end                
              end
            else if(buffer==`i)
              begin
              expected.s_out=8'h69;
              if(expected.s_out==actual.s_out)
                begin
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("s_out = %0h | actual=expected, MATCH",actual.s_out),UVM_LOW);
                   buffer.delete();
                   count=0;
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("buffer size = %0d",buffer.size()),UVM_LOW);
                  PASS++;
                end
              else
                begin
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("actual = %0h | expected = %0h , MISMATCH",actual.s_out,expected.s_out),UVM_LOW);
                   buffer.delete();
                   count=0;
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("buffer size = %0d",buffer.size()),UVM_LOW);
                  FAIL++;                 
                end                
              end
            else if(buffer==`n)
              begin
              expected.s_out=8'h6E;
              if(expected.s_out==actual.s_out)
                begin
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("s_out = %0h | actual=expected, MATCH",actual.s_out),UVM_LOW);
                   buffer.delete();
                   count=0;
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("buffer size = %0d",buffer.size()),UVM_LOW);
                  PASS++;
                end
              else
                begin
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("actual = %0h | expected = %0h , MISMATCH",actual.s_out,expected.s_out),UVM_LOW);
                   buffer.delete();
                   count=0;
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("buffer size = %0d",buffer.size()),UVM_LOW);
                  FAIL++;                 
                end                
              end
            else if(buffer==`m)
              begin
              expected.s_out=8'h6D;
              if(expected.s_out==actual.s_out)
                begin
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("s_out = %0h | actual=expected, MATCH",actual.s_out),UVM_LOW);
                   buffer.delete();
                   count=0;
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("buffer size = %0d",buffer.size()),UVM_LOW);
                  PASS++;
                end
              else
                begin
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("actual = %0h | expected = %0h , MISMATCH",actual.s_out,expected.s_out),UVM_LOW);
                   buffer.delete();
                   count=0;
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("buffer size = %0d",buffer.size()),UVM_LOW);
                  FAIL++;                 
                end                
              end
        end
         3:begin
           if(buffer==`d)
             begin
              expected.s_out=8'h64;
              if(expected.s_out==actual.s_out)
                begin
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("s_out = %0h | actual=expected, MATCH",actual.s_out),UVM_LOW);
                   buffer.delete();
                   count=0;
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("buffer size = %0d",buffer.size()),UVM_LOW);
                  PASS++;
                end
              else
                begin
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("actual = %0h | expected = %0h , MISMATCH",actual.s_out,expected.s_out),UVM_LOW);
                   buffer.delete();
                   count=0;
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("buffer size = %0d",buffer.size()),UVM_LOW);
                   FAIL++;                 
                 end
             end
           else if(buffer==`g)
             begin
              expected.s_out=8'h67;
              if(expected.s_out==actual.s_out)
                begin
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("s_out = %0h | actual=expected, MATCH",actual.s_out),UVM_LOW);
                   buffer.delete();
                   count=0;
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("buffer size = %0d",buffer.size()),UVM_LOW);
                  PASS++;
                end
              else
                begin
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("actual = %0h | expected = %0h , MISMATCH",actual.s_out,expected.s_out),UVM_LOW);
                   buffer.delete();
                   count=0;
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("buffer size = %0d",buffer.size()),UVM_LOW);
                  FAIL++;                 
                end
             end
           else if(buffer==`r)
             begin
              expected.s_out=8'h72;
              if(expected.s_out==actual.s_out)
                begin
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("s_out = %0h | actual=expected, MATCH",actual.s_out),UVM_LOW);
                   buffer.delete();
                   count=0;
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("buffer size = %0d",buffer.size()),UVM_LOW);
                  PASS++;
                end
              else
                begin
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("actual = %0h | expected = %0h , MISMATCH",actual.s_out,expected.s_out),UVM_LOW);
                   buffer.delete();
                   count=0;
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("buffer size = %0d",buffer.size()),UVM_LOW);
                  FAIL++;                 
                end
             end
           else if(buffer==`s)
             begin
              expected.s_out=8'h73;
              if(expected.s_out==actual.s_out)
                begin
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("s_out = %0h | actual=expected, MATCH",actual.s_out),UVM_LOW);
                   buffer.delete();
                   count=0;
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("buffer size = %0d",buffer.size()),UVM_LOW);
                  PASS++;
                end
              else
                begin
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("actual = %0h | expected = %0h , MISMATCH",actual.s_out,expected.s_out),UVM_LOW);
                   buffer.delete();
                   count=0;
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("buffer size = %0d",buffer.size()),UVM_LOW);
                  FAIL++;                 
                end
             end
           else if(buffer==`o)
             begin
              expected.s_out=8'h6F;
              if(expected.s_out==actual.s_out)
                begin
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("s_out = %0h | actual=expected, MATCH",actual.s_out),UVM_LOW);
                   buffer.delete();
                   count=0;
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("buffer size = %0d",buffer.size()),UVM_LOW);
                  PASS++;
                end
              else
                begin
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("actual = %0h | expected = %0h , MISMATCH",actual.s_out,expected.s_out),UVM_LOW);
                   buffer.delete();
                   count=0;
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("buffer size = %0d",buffer.size()),UVM_LOW);
                  FAIL++;                 
                end
             end
           else if(buffer==`k)
             begin
              expected.s_out=8'h6B;
              if(expected.s_out==actual.s_out)
                begin
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("s_out = %0h | actual=expected, MATCH",actual.s_out),UVM_LOW);
                   buffer.delete();
                   count=0;
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("buffer size = %0d",buffer.size()),UVM_LOW);
                  PASS++;
                end
              else
                begin
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("actual = %0h | expected = %0h , MISMATCH",actual.s_out,expected.s_out),UVM_LOW);
                   buffer.delete();
                   count=0;
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("buffer size = %0d",buffer.size()),UVM_LOW);
                  FAIL++;                 
                end
             end
           else if(buffer==`u)
             begin
              expected.s_out=8'h75;
              if(expected.s_out==actual.s_out)
                begin
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("s_out = %0h | actual=expected, MATCH",actual.s_out),UVM_LOW);
                   buffer.delete();
                   count=0;
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("buffer size = %0d",buffer.size()),UVM_LOW);
                  PASS++;
                end
              else
                begin
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("actual = %0h | expected = %0h , MISMATCH",actual.s_out,expected.s_out),UVM_LOW);
                   buffer.delete();
                   count=0;
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("buffer size = %0d",buffer.size()),UVM_LOW);
                  FAIL++;                 
                end
             end
           else if(buffer==`w)
             begin
              expected.s_out=8'h77;
              if(expected.s_out==actual.s_out)
                begin
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("s_out = %0h | actual=expected, MATCH",actual.s_out),UVM_LOW);
                   buffer.delete();
                   count=0;
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("buffer size = %0d",buffer.size()),UVM_LOW);
                  PASS++;
                end
              else
                begin
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("actual = %0h | expected = %0h , MISMATCH",actual.s_out,expected.s_out),UVM_LOW);
                   buffer.delete();
                   count=0;
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("buffer size = %0d",buffer.size()),UVM_LOW);
                  FAIL++;                 
                end
             end
         end
         4:begin
           if(buffer==`b)
             begin
              expected.s_out=8'h62;
              if(expected.s_out==actual.s_out)
                begin
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("s_out = %0h | actual=expected, MATCH",actual.s_out),UVM_LOW);
                   buffer.delete();
                   count=0;
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("buffer size = %0d",buffer.size()),UVM_LOW);
                  PASS++;
                end
              else
                begin
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("actual = %0h | expected = %0h , MISMATCH",actual.s_out,expected.s_out),UVM_LOW);
                   buffer.delete();
                   count=0;
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("buffer size = %0d",buffer.size()),UVM_LOW);
                  FAIL++;                 
                end
             end
           else if(buffer==`c)
             begin
              expected.s_out=8'h63;
              if(expected.s_out==actual.s_out)
                begin
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("s_out = %0h | actual=expected, MATCH",actual.s_out),UVM_LOW);
                   buffer.delete();
                   count=0;
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("buffer size = %0d",buffer.size()),UVM_LOW);
                  PASS++;
                end
              else
                begin
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("actual = %0h | expected = %0h , MISMATCH",actual.s_out,expected.s_out),UVM_LOW);
                   buffer.delete();
                   count=0;
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("buffer size = %0d",buffer.size()),UVM_LOW);
                  FAIL++;                 
                end
             end
           else if(buffer==`f)
             begin
              expected.s_out=8'h66;
              if(expected.s_out==actual.s_out)
                begin
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("s_out = %0h | actual=expected, MATCH",actual.s_out),UVM_LOW);
                   buffer.delete();
                   count=0;
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("buffer size = %0d",buffer.size()),UVM_LOW);
                  PASS++;
                end
              else
                begin
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("actual = %0h | expected = %0h , MISMATCH",actual.s_out,expected.s_out),UVM_LOW);
                   buffer.delete();
                   count=0;
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("buffer size = %0d",buffer.size()),UVM_LOW);
                  FAIL++;                 
                end
             end
           else if(buffer==`h)
             begin
              expected.s_out=8'h68;
              if(expected.s_out==actual.s_out)
                begin
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("s_out = %0h | actual=expected, MATCH",actual.s_out),UVM_LOW);
                   buffer.delete();
                   count=0;
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("buffer size = %0d",buffer.size()),UVM_LOW);
                  PASS++;
                end
              else
                begin
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("actual = %0h | expected = %0h , MISMATCH",actual.s_out,expected.s_out),UVM_LOW);
                   buffer.delete();
                   count=0;
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("buffer size = %0d",buffer.size()),UVM_LOW);
                  FAIL++;                 
                end               
             end
           else if(buffer==`j)
             begin
              expected.s_out=8'h6A;
              if(expected.s_out==actual.s_out)
                begin
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("s_out = %0h | actual=expected, MATCH",actual.s_out),UVM_LOW);
                   buffer.delete();
                   count=0;
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("buffer size = %0d",buffer.size()),UVM_LOW);
                  PASS++;
                end
              else
                begin
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("actual = %0h | expected = %0h , MISMATCH",actual.s_out,expected.s_out),UVM_LOW);
                   buffer.delete();
                   count=0;
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("buffer size = %0d",buffer.size()),UVM_LOW);
                  FAIL++;                 
                end
             end
           else if(buffer==`l)
             begin
              expected.s_out=8'h6C;
              if(expected.s_out==actual.s_out)
                begin
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("s_out = %0h | actual=expected, MATCH",actual.s_out),UVM_LOW);
                   buffer.delete();
                   count=0;
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("buffer size = %0d",buffer.size()),UVM_LOW);
                  PASS++;
                end
              else
                begin
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("actual = %0h | expected = %0h , MISMATCH",actual.s_out,expected.s_out),UVM_LOW);
                   buffer.delete();
                   count=0;
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("buffer size = %0d",buffer.size()),UVM_LOW);
                  FAIL++;                 
                end               
             end
           else if(buffer==`p)
             begin
              expected.s_out=8'h70;
              if(expected.s_out==actual.s_out)
                begin
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("s_out = %0h | actual=expected, MATCH",actual.s_out),UVM_LOW);
                   buffer.delete();
                   count=0;
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("buffer size = %0d",buffer.size()),UVM_LOW);
                  PASS++;
                end
              else
                begin
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("actual = %0h | expected = %0h , MISMATCH",actual.s_out,expected.s_out),UVM_LOW);
                   buffer.delete();
                   count=0;
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("buffer size = %0d",buffer.size()),UVM_LOW);
                  FAIL++;                 
                end              
             end
           else if(buffer==`q)
             begin
              expected.s_out=8'h71;
              if(expected.s_out==actual.s_out)
                begin
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("s_out = %0h | actual=expected, MATCH",actual.s_out),UVM_LOW);
                   buffer.delete();
                   count=0;
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("buffer size = %0d",buffer.size()),UVM_LOW);
                  PASS++;
                end
              else
                begin
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("actual = %0h | expected = %0h , MISMATCH",actual.s_out,expected.s_out),UVM_LOW);
                   buffer.delete();
                   count=0;
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("buffer size = %0d",buffer.size()),UVM_LOW);
                  FAIL++;                 
                end
             end
           else if(buffer==`v)
             begin
              expected.s_out=8'h76;
              if(expected.s_out==actual.s_out)
                begin
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("s_out = %0h | actual=expected, MATCH",actual.s_out),UVM_LOW);
                   buffer.delete();
                   count=0;
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("buffer size = %0d",buffer.size()),UVM_LOW);
                  PASS++;
                end
              else
                begin
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("actual = %0h | expected = %0h , MISMATCH",actual.s_out,expected.s_out),UVM_LOW);
                   buffer.delete();
                   count=0;
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("buffer size = %0d",buffer.size()),UVM_LOW);
                  FAIL++;                 
                end
             end
           else if(buffer==`x)
             begin
              expected.s_out=8'h78;
              if(expected.s_out==actual.s_out)
                begin
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("s_out = %0h | actual=expected, MATCH",actual.s_out),UVM_LOW);
                   buffer.delete();
                   count=0;
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("buffer size = %0d",buffer.size()),UVM_LOW);
                  PASS++;
                end
              else
                begin
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("actual = %0h | expected = %0h , MISMATCH",actual.s_out,expected.s_out),UVM_LOW);
                   buffer.delete();
                   count=0;
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("buffer size = %0d",buffer.size()),UVM_LOW);
                  FAIL++;                 
                end               
             end
           else if(buffer==`y)
             begin
              expected.s_out=8'h79;
              if(expected.s_out==actual.s_out)
                begin
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("s_out = %0h | actual=expected, MATCH",actual.s_out),UVM_LOW);
                   buffer.delete();
                   count=0;
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("buffer size = %0d",buffer.size()),UVM_LOW);
                  PASS++;
                end
              else
                begin
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("actual = %0h | expected = %0h , MISMATCH",actual.s_out,expected.s_out),UVM_LOW);
                   buffer.delete();
                   count=0;
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("buffer size = %0d",buffer.size()),UVM_LOW);
                  FAIL++;                 
                end
             end
           else if(buffer==`z)
             begin
              expected.s_out=8'h7A;
              if(expected.s_out==actual.s_out)
                begin
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("s_out = %0h | actual=expected, MATCH",actual.s_out),UVM_LOW);
                   buffer.delete();
                   count=0;
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("buffer size = %0d",buffer.size()),UVM_LOW);
                  PASS++;
                end
              else
                begin
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("actual = %0h | expected = %0h , MISMATCH",actual.s_out,expected.s_out),UVM_LOW);
                   buffer.delete();
                   count=0;
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("buffer size = %0d",buffer.size()),UVM_LOW);
                  FAIL++;                 
                end
             end
           else
             begin
                expected.s_out=8'hFF;
                `uvm_info("SCOREBOARD-CHAR",$sformatf("PATTERN UNKNOWN"),UVM_LOW);
                if((expected.s_out==actual.s_out)
                   begin
                     `uvm_info("SCOREBOARD-CHAR",$sformatf("actual = %0h | expected = %0h , MATCH",actual.s_out,expected.s_out),UVM_LOW);
                      buffer.delete();
                      count=0;
                     `uvm_info("SCOREBOARD-CHAR",$sformatf("buffer size = %0d",buffer.size()),UVM_LOW);
                     PASS++;
                   end
              else
                begin
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("actual = %0h | expected = %0h , MISMATCH",actual.s_out,expected.s_out),UVM_LOW);
                      count=0;
                     `uvm_info("SCOREBOARD-CHAR",$sformatf("buffer size = %0d",buffer.size()),UVM_LOW);
                     PASS++;
                end               
             end
         end
         5:begin
           if(buffer==`zero)
             begin
              expected.s_out=8'h30;
              if(expected.s_out==actual.s_out)
                begin
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("s_out = %0h | actual=expected, MATCH",actual.s_out),UVM_LOW);
                   buffer.delete();
                   count=0;
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("buffer size = %0d",buffer.size()),UVM_LOW);
                  PASS++;
                end
              else
                begin
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("actual = %0h | expected = %0h , MISMATCH",actual.s_out,expected.s_out),UVM_LOW);
                   buffer.delete();
                   count=0;
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("buffer size = %0d",buffer.size()),UVM_LOW);
                  FAIL++;                 
                end

             end
           else if(buffer==`one)
             begin
              expected.s_out=8'h31;
              if(expected.s_out==actual.s_out)
                begin
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("s_out = %0h | actual=expected, MATCH",actual.s_out),UVM_LOW);
                   buffer.delete();
                   count=0;
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("buffer size = %0d",buffer.size()),UVM_LOW);
                  PASS++;
                end
              else
                begin
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("actual = %0h | expected = %0h , MISMATCH",actual.s_out,expected.s_out),UVM_LOW);
                   buffer.delete();
                   count=0;
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("buffer size = %0d",buffer.size()),UVM_LOW);
                  FAIL++;                 
                end               
             end
           else if(buffer==`two)
             begin
              expected.s_out=8'h32;
              if(expected.s_out==actual.s_out)
                begin
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("s_out = %0h | actual=expected, MATCH",actual.s_out),UVM_LOW);
                   buffer.delete();
                   count=0;
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("buffer size = %0d",buffer.size()),UVM_LOW);
                  PASS++;
                end
              else
                begin
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("actual = %0h | expected = %0h , MISMATCH",actual.s_out,expected.s_out),UVM_LOW);
                   buffer.delete();
                   count=0;
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("buffer size = %0d",buffer.size()),UVM_LOW);
                  FAIL++;                 
                end              
             end
           else if(buffer==`three)
             begin
              expected.s_out=8'h33;
              if(expected.s_out==actual.s_out)
                begin
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("s_out = %0h | actual=expected, MATCH",actual.s_out),UVM_LOW);
                   buffer.delete();
                   count=0;
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("buffer size = %0d",buffer.size()),UVM_LOW);
                  PASS++;
                end
              else
                begin
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("actual = %0h | expected = %0h , MISMATCH",actual.s_out,expected.s_out),UVM_LOW);
                   buffer.delete();
                   count=0;
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("buffer size = %0d",buffer.size()),UVM_LOW);
                  FAIL++;                 
                end              
             end
           else if(buffer==`four)
             begin
              expected.s_out=8'h34;
              if(expected.s_out==actual.s_out)
                begin
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("s_out = %0h | actual=expected, MATCH",actual.s_out),UVM_LOW);
                   buffer.delete();
                   count=0;
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("buffer size = %0d",buffer.size()),UVM_LOW);
                  PASS++;
                end
              else
                begin
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("actual = %0h | expected = %0h , MISMATCH",actual.s_out,expected.s_out),UVM_LOW);
                   buffer.delete();
                   count=0;
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("buffer size = %0d",buffer.size()),UVM_LOW);
                  FAIL++;                 
                end               
             end
           else if(buffer==`five)
             begin
              expected.s_out=8'h35;
              if(expected.s_out==actual.s_out)
                begin
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("s_out = %0h | actual=expected, MATCH",actual.s_out),UVM_LOW);
                   buffer.delete();
                   count=0;
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("buffer size = %0d",buffer.size()),UVM_LOW);
                  PASS++;
                end
              else
                begin
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("actual = %0h | expected = %0h , MISMATCH",actual.s_out,expected.s_out),UVM_LOW);
                   buffer.delete();
                   count=0;
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("buffer size = %0d",buffer.size()),UVM_LOW);
                  FAIL++;                 
                end              
             end
           else if(buffer==`six)
             begin
              expected.s_out=8'h36;
              if(expected.s_out==actual.s_out)
                begin
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("s_out = %0h | actual=expected, MATCH",actual.s_out),UVM_LOW);
                   buffer.delete();
                   count=0;
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("buffer size = %0d",buffer.size()),UVM_LOW);
                  PASS++;
                end
              else
                begin
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("actual = %0h | expected = %0h , MISMATCH",actual.s_out,expected.s_out),UVM_LOW);
                   buffer.delete();
                   count=0;
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("buffer size = %0d",buffer.size()),UVM_LOW);
                  FAIL++;                 
                end               
             end
           else if(buffer==`seven)
             begin
              expected.s_out=8'h37;
              if(expected.s_out==actual.s_out)
                begin
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("s_out = %0h | actual=expected, MATCH",actual.s_out),UVM_LOW);
                   buffer.delete();
                   count=0;
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("buffer size = %0d",buffer.size()),UVM_LOW);
                   PASS++;
                end
              else
                begin
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("actual = %0h | expected = %0h , MISMATCH",actual.s_out,expected.s_out),UVM_LOW);
                   buffer.delete();
                   count=0;
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("buffer size = %0d",buffer.size()),UVM_LOW);
                  FAIL++;                 
                end               
             end
           else if(buffer==`eight)
             begin
              expected.s_out=8'h38;
              if(expected.s_out==actual.s_out)
                begin
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("s_out = %0h | actual=expected, MATCH",actual.s_out),UVM_LOW);
                   buffer.delete();
                   count=0;
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("buffer size = %0d",buffer.size()),UVM_LOW);
                  PASS++;
                end
              else
                begin
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("actual = %0h | expected = %0h , MISMATCH",actual.s_out,expected.s_out),UVM_LOW);
                   buffer.delete();
                   count=0;
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("buffer size = %0d",buffer.size()),UVM_LOW);
                  FAIL++;                 
                end               
             end
           else if(buffer==`nine)
             begin
              expected.s_out=8'h39;
              if(expected.s_out==actual.s_out)
                begin
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("s_out = %0h | actual=expected, MATCH",actual.s_out),UVM_LOW);
                   buffer.delete();
                   count=0;
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("buffer size = %0d",buffer.size()),UVM_LOW);
                  PASS++;
                end
              else
                begin
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("actual = %0h | expected = %0h , MISMATCH",actual.s_out,expected.s_out),UVM_LOW);
                   buffer.delete();
                   count=0;
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("buffer size = %0d",buffer.size()),UVM_LOW);
                  FAIL++;                 
                end              
             end
           else
             begin
                expected.s_out=8'hFF;
                `uvm_info("SCOREBOARD-CHAR",$sformatf("PATTERN UNKNOWN"),UVM_LOW);
                if((expected.s_out==actual.s_out)
                   begin
                     `uvm_info("SCOREBOARD-CHAR",$sformatf("actual = %0h | expected = %0h , MATCH",actual.s_out,expected.s_out),UVM_LOW);
                      buffer.delete();
                      count=0;
                     `uvm_info("SCOREBOARD-CHAR",$sformatf("buffer size = %0d",buffer.size()),UVM_LOW);
                     PASS++;
                   end
              else
                begin
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("actual = %0h | expected = %0h , MISMATCH",actual.s_out,expected.s_out),UVM_LOW);
                      count=0;
                     `uvm_info("SCOREBOARD-CHAR",$sformatf("buffer size = %0d",buffer.size()),UVM_LOW);
                     PASS++;
                end               
             end       
         end
         default:begin
              expected.s_out=8'hFF;
              if(expected.s_out==actual.s_out)
                begin
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("s_out = %0h | actual=expected, MATCH",actual.s_out),UVM_LOW);
                   buffer.delete();
                   count=0;
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("buffer size = %0d",buffer.size()),UVM_LOW);
                  PASS++;
                end
              else
                begin
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("actual = %0h | expected = %0h , MISMATCH",actual.s_out,expected.s_out),UVM_LOW);
                   buffer.delete();
                   count=0;
                  `uvm_info("SCOREBOARD-CHAR",$sformatf("buffer size = %0d",buffer.size()),UVM_LOW);
                  FAIL++;                 
                end
         end
      endcase                
      end
    else if(expected.dash_inp==0 && expected.dot_inp==0 && expected.char_space==0 && expected.word_space==1)
      begin
        expected.s_out=8'h20;
        if(expected.s_out==actual.s_out)
          begin 
            `uvm_info("SCOREBOARD-WORD",$sformatf("s_out = %0h | actual=expected, MATCH",actual.s_out),UVM_LOW);
            `uvm_info("SCOREBOARD-WORD",$sformatf("buffer size = %0d",buffer.size()),UVM_LOW);
             PASS++;
          end
        else
          begin
            `uvm_info("SCOREBOARD-WORD",$sformatf("actual = %0h | expected = %0h , MISMATCH",actual.s_out,expected.s_out),UVM_LOW);
            `uvm_info("SC0REBOARD-WORD",$sformatf("buffer size = %0d",buffer.size()),UVM_LOW);
             FAIL++;                 
          end
      end
    else
      begin
        `uvm_info("SCOREBOARD",sformatf("Multiple inputs are high at same cycle"),UVM_LOW);
        `uvm_info("SCOREBOARD",$sformatf("buffer size = %0d actual= %0h | expected = %0h",buffer.size(),actual.s_out,expected.s_out),UVM_LOW);
      end
   endtask      
endclass
