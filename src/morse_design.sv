module morse_top(
input wire clk,
input wire rst,
input wire dot_inp, 
input wire dash_inp, 
input wire char_space_inp, 
input wire word_space_inp,
output reg [7:0]sout);


wire [2:0] trans_out;
wire [7:0] serial_out;



trans_fsm trans (.clk(clk),.rst(rst),.dot_inp(dot_inp),.dash_inp(dash_inp),.char_space_inp(char_space_inp),.word_space_inp(word_space_inp),.parallel_out(trans_out));

  rec_fsm rec(.clk(clk),.p_in(trans_out),.rst(rst),.s_out1(serial_out));

always @(*) begin
sout = serial_out;
end
endmodule

/////////////////////////////////////////////////////////////////////////

module trans_fsm(
    dot_inp, 
    dash_inp, 
    char_space_inp, 
    word_space_inp,
    parallel_out, 
    clk,
    rst
);

input dot_inp;
input dash_inp;
input char_space_inp;
input word_space_inp;
input clk;
input rst;

output reg [2:0] parallel_out;

parameter [3:0] s_idle       = 4'b0000;
parameter [3:0] s_dot        = 4'b0001;
parameter [3:0] s_dash       = 4'b0010;

parameter [3:0] s_char_1     = 4'b0100;
parameter [3:0] s_char_2     = 4'b0101;
parameter [3:0] s_char_3     = 4'b0110;

parameter [3:0] s_word_1     = 4'b1000;
parameter [3:0] s_word_2     = 4'b1001;
parameter [3:0] s_word_3     = 4'b1010;
parameter [3:0] s_word_4     = 4'b1011;
parameter [3:0] s_word_5     = 4'b1100;
parameter [3:0] s_word_6     = 4'b1101;
parameter [3:0] s_word_7     = 4'b1110;

reg [3:0] state, next_state; 

always@(posedge clk or negedge rst)
begin
    if(!rst) begin
        state <= s_idle;
    end
    else begin
        state <= next_state;
    end
end

always@(*)
begin
    next_state = s_idle;
    parallel_out = 3'b000; 

    case(state)
        s_idle:
        begin
            parallel_out = 3'b000; 
            if (dot_inp)
                next_state = s_dot;
            else if (dash_inp)
                next_state = s_dash;
            else if (char_space_inp)
                next_state = s_char_1;
            else if (word_space_inp)
                next_state = s_word_1; 
            else
                next_state = s_idle;
        end

        s_dot:  begin parallel_out = 3'b001; next_state = s_idle; end
        s_dash: begin parallel_out = 3'b010; next_state = s_idle; end

        // --- Character Space Sequence (3 cycles) ---
        s_char_1: begin parallel_out = 3'b011; next_state = s_char_2; end
        s_char_2: begin parallel_out = 3'b011; next_state = s_char_3; end
        s_char_3: begin parallel_out = 3'b011; next_state = s_idle;   end

        // --- Word Space Sequence (7 cycles) ---
        s_word_1: begin parallel_out = 3'b100; next_state = s_word_2; end
        s_word_2: begin parallel_out = 3'b100; next_state = s_word_3; end
        s_word_3: begin parallel_out = 3'b100; next_state = s_word_4; end
        s_word_4: begin parallel_out = 3'b100; next_state = s_word_5; end
        s_word_5: begin parallel_out = 3'b100; next_state = s_word_6; end
        s_word_6: begin parallel_out = 3'b100; next_state = s_word_7; end
        s_word_7: begin parallel_out = 3'b100; next_state = s_idle;   end
        
        default:
        begin
            next_state = s_idle;
            parallel_out = 3'b000;
        end
    endcase
end

endmodule

///////////////////////////////////////////////////////////////////////

module rec_fsm(clk,p_in,rst,s_out1);

input rst;
input clk;
input [2:0] p_in; 

output reg [7:0] s_out1;

reg [7:0] state;
reg [7:0] next_state;
reg [7:0] s_out;

parameter [7:0] reset_state = 8'hff;
parameter [7:0] a = 8'h00;
parameter [7:0] b = 8'h01;
parameter [7:0] c = 8'h02;
parameter [7:0] d = 8'h03;
parameter [7:0] e = 8'h04;
parameter [7:0] f = 8'h05;
parameter [7:0] g = 8'h06;
parameter [7:0] h = 8'h07;
parameter [7:0] i = 8'h08;
parameter [7:0] j = 8'h09;
parameter [7:0] k = 8'h0a;
parameter [7:0] l = 8'h0b;
parameter [7:0] m = 8'h0c;
parameter [7:0] n = 8'h0d;
parameter [7:0] o = 8'h0e;
parameter [7:0] p = 8'h0f;
parameter [7:0] q = 8'h10;
parameter [7:0] r = 8'h11;
parameter [7:0] s = 8'h12;
parameter [7:0] t = 8'h13;
parameter [7:0] u = 8'h14;
parameter [7:0] v = 8'h15;
parameter [7:0] w = 8'h16;
parameter [7:0] x = 8'h17;
parameter [7:0] y = 8'h18;
parameter [7:0] z = 8'h19;

parameter [7:0] zero = 8'h20;
parameter [7:0] one = 8'h21;
parameter [7:0] two = 8'h22;
parameter [7:0] three = 8'h23;
parameter [7:0] four = 8'h24;
parameter [7:0] five = 8'h25;
parameter [7:0] six = 8'h26;
parameter [7:0] seven = 8'h27;
parameter [7:0] eight = 8'h28;
parameter [7:0] nine = 8'h29;

parameter [7:0] ds1 = 8'h2a;
parameter [7:0] ds2 = 8'h2b;
parameter [7:0] ds3 = 8'h2c;

always @(posedge clk or negedge rst) begin
    if (!rst)
        state <= reset_state;
    else
        state <= next_state;
end

always @(*) begin
    next_state = state;
    s_out = 8'hff;

    case (state)
        // ---------------- reset_state ----------------
        reset_state:
        case (p_in)
            3'b000: begin next_state = state; s_out = 8'hff; end
            3'b001: begin next_state = e; s_out = 8'hff; end
            3'b010: begin next_state = t; s_out = 8'hff; end
            3'b011: begin next_state = reset_state; s_out = 8'hff; end
            3'b100: begin next_state = reset_state; s_out = 8'hff; end 
            default: begin next_state = reset_state; s_out = 8'hff; end
        endcase

        // ---------------- a ----------------
        a:
        case (p_in)
            3'b000: begin next_state = state; s_out = 8'hff; end
            3'b001: begin next_state = r; s_out = 8'hff; end
            3'b010: begin next_state = w; s_out = 8'hff; end
            3'b011: begin next_state = reset_state; s_out = 8'h61; end
            3'b100: begin next_state = reset_state; s_out = 8'h20; end 
            default: begin next_state = reset_state; s_out = 8'hff; end
        endcase

        // ---------------- b ----------------
        b:
        case (p_in)
            3'b000: begin next_state = state; s_out = 8'hff; end
            3'b001: begin next_state = six; s_out = 8'hff; end
            3'b010: begin next_state = reset_state; s_out = 8'hff; end
            3'b011: begin next_state = reset_state; s_out = 8'h62; end
            3'b100: begin next_state = reset_state; s_out = 8'h20; end 
            default: begin next_state = reset_state; s_out = 8'hff; end
        endcase

        // ---------------- c ----------------
        c:
        case (p_in)
            3'b000: begin next_state = state; s_out = 8'hff; end
            3'b001: begin next_state = reset_state; s_out = 8'hff; end
            3'b010: begin next_state = reset_state; s_out = 8'hff; end
            3'b011: begin next_state = reset_state; s_out = 8'h63; end
            3'b100: begin next_state = reset_state; s_out = 8'h20; end 
            default: begin next_state = reset_state; s_out = 8'hff; end
        endcase

        // ---------------- d ----------------
        d:
        case (p_in)
            3'b000: begin next_state = state; s_out = 8'hff; end
            3'b001: begin next_state = b; s_out = 8'hff; end
            3'b010: begin next_state = x; s_out = 8'hff; end
            3'b011: begin next_state = reset_state; s_out = 8'h64; end
            3'b100: begin next_state = reset_state; s_out = 8'h20; end 
            default: begin next_state = reset_state; s_out = 8'hff; end
        endcase

        // ---------------- e ----------------
        e:
        case (p_in)
            3'b000: begin next_state = state; s_out = 8'hff; end
            3'b001: begin next_state = i; s_out = 8'hff; end
            3'b010: begin next_state = a; s_out = 8'hff; end
            3'b011: begin next_state = reset_state; s_out = 8'h65; end
            3'b100: begin next_state = reset_state; s_out = 8'h20; end 
            default: begin next_state = reset_state; s_out = 8'hff; end
        endcase

        // ---------------- f ----------------
        f:
        case (p_in)
            3'b000: begin next_state = state; s_out = 8'hff; end
            3'b001: begin next_state = reset_state; s_out = 8'hff; end
            3'b010: begin next_state = reset_state; s_out = 8'hff; end
            3'b011: begin next_state = reset_state; s_out = 8'h66; end
            3'b100: begin next_state = reset_state; s_out = 8'h20; end 
            default: begin next_state = reset_state; s_out = 8'hff; end
        endcase

        // ---------------- g ----------------
        g:
        case (p_in)
            3'b000: begin next_state = state; s_out = 8'hff; end
            3'b001: begin next_state = z; s_out = 8'hff; end
            3'b010: begin next_state = q; s_out = 8'hff; end
            3'b011: begin next_state = reset_state; s_out = 8'h67; end
            3'b100: begin next_state = reset_state; s_out = 8'h20; end 
            default: begin next_state = reset_state; s_out = 8'hff; end
        endcase

        // ---------------- h ----------------
        h:
        case (p_in)
            3'b000: begin next_state = state; s_out = 8'hff; end
            3'b001: begin next_state = five; s_out = 8'hff; end
            3'b010: begin next_state = four; s_out = 8'hff; end
            3'b011: begin next_state = reset_state; s_out = 8'h68; end
            3'b100: begin next_state = reset_state; s_out = 8'h20; end 
            default: begin next_state = reset_state; s_out = 8'hff; end
        endcase

        // ---------------- i ----------------
        i:
        case (p_in)
            3'b000: begin next_state = state; s_out = 8'hff; end
            3'b001: begin next_state = s; s_out = 8'hff; end
            3'b010: begin next_state = u; s_out = 8'hff; end
            3'b011: begin next_state = reset_state; s_out = 8'h69; end
            3'b100: begin next_state = reset_state; s_out = 8'h20; end 
            default: begin next_state = reset_state; s_out = 8'hff; end
        endcase

        // ---------------- j ----------------
        j:
        case (p_in)
            3'b000: begin next_state = state; s_out = 8'hff; end
            3'b001: begin next_state = reset_state; s_out = 8'hff; end
            3'b010: begin next_state = one; s_out = 8'hff; end
            3'b011: begin next_state = reset_state; s_out = 8'h6A; end
            3'b100: begin next_state = reset_state; s_out = 8'h20; end 
            default: begin next_state = reset_state; s_out = 8'hff; end
        endcase

        // ---------------- k ----------------
        k:
        case (p_in)
            3'b000: begin next_state = state; s_out = 8'hff; end
            3'b001: begin next_state = c; s_out = 8'hff; end
            3'b010: begin next_state = y; s_out = 8'hff; end
            3'b011: begin next_state = reset_state; s_out = 8'h6B; end
            3'b100: begin next_state = reset_state; s_out = 8'h20; end 
            default: begin next_state = reset_state; s_out = 8'hff; end
        endcase

        // ---------------- l ----------------
        l:
        case (p_in)
            3'b000: begin next_state = state; s_out = 8'hff; end
            3'b001: begin next_state = reset_state; s_out = 8'hff; end
            3'b010: begin next_state = reset_state; s_out = 8'hff; end
            3'b011: begin next_state = reset_state; s_out = 8'h6C; end
            3'b100: begin next_state = reset_state; s_out = 8'h20; end 
            default: begin next_state = reset_state; s_out = 8'hff; end
        endcase

        // ---------------- m ----------------
        m:
        case (p_in)
            3'b000: begin next_state = state; s_out = 8'hff; end
            3'b001: begin next_state = g; s_out = 8'hff; end
            3'b010: begin next_state = o; s_out = 8'hff; end
            3'b011: begin next_state = reset_state; s_out = 8'h6D; end
            3'b100: begin next_state = reset_state; s_out = 8'h20; end 
            default: begin next_state = reset_state; s_out = 8'hff; end
        endcase

        // ---------------- n ----------------
        n:
        case (p_in)
            3'b000: begin next_state = state; s_out = 8'hff; end
            3'b001: begin next_state = d; s_out = 8'hff; end
            3'b010: begin next_state = k; s_out = 8'hff; end
            3'b011: begin next_state = reset_state; s_out = 8'h6E; end
            3'b100: begin next_state = reset_state; s_out = 8'h20; end 
            default: begin next_state = reset_state; s_out = 8'hff; end
        endcase

        // ---------------- o ----------------
        o:
        case (p_in)
            3'b000: begin next_state = state; s_out = 8'hff; end
            3'b001: begin next_state = ds2; s_out = 8'hff; end
            3'b010: begin next_state = ds1; s_out = 8'hff; end
            3'b011: begin next_state = reset_state; s_out = 8'h6F; end
            3'b100: begin next_state = reset_state; s_out = 8'h20; end 
            default: begin next_state = reset_state; s_out = 8'hff; end
        endcase

        // ---------------- p ----------------
        p:
        case (p_in)
            3'b000: begin next_state = state; s_out = 8'hff; end
            3'b001: begin next_state = reset_state; s_out = 8'hff; end
            3'b010: begin next_state = reset_state; s_out = 8'hff; end
            3'b011: begin next_state = reset_state; s_out = 8'h70; end
            3'b100: begin next_state = reset_state; s_out = 8'h20; end 
            default: begin next_state = reset_state; s_out = 8'hff; end
        endcase

        // ---------------- q ----------------
        q:
        case (p_in)
            3'b000: begin next_state = state; s_out = 8'hff; end
            3'b001: begin next_state = reset_state; s_out = 8'hff; end
            3'b010: begin next_state = reset_state; s_out = 8'hff; end
            3'b011: begin next_state = reset_state; s_out = 8'h71; end
            3'b100: begin next_state = reset_state; s_out = 8'h20; end 
            default: begin next_state = reset_state; s_out = 8'hff; end
        endcase

        // ---------------- r ----------------
        r:
        case (p_in)
            3'b000: begin next_state = state; s_out = 8'hff; end
            3'b001: begin next_state = l; s_out = 8'hff; end
            3'b010: begin next_state = reset_state; s_out = 8'hff; end
            3'b011: begin next_state = reset_state; s_out = 8'h72; end
            3'b100: begin next_state = reset_state; s_out = 8'h20; end 
            default: begin next_state = reset_state; s_out = 8'hff; end
        endcase

        // ---------------- s ----------------
        s:
        case (p_in)
            3'b000: begin next_state = state; s_out = 8'hff; end
            3'b001: begin next_state = h; s_out = 8'hff; end
            3'b010: begin next_state = v; s_out = 8'hff; end
            3'b011: begin next_state = reset_state; s_out = 8'h73; end
            3'b100: begin next_state = reset_state; s_out = 8'h20; end 
            default: begin next_state = reset_state; s_out = 8'hff; end
        endcase

        // ---------------- t ----------------
        t:
        case (p_in)
            3'b000: begin next_state = state; s_out = 8'hff; end
            3'b001: begin next_state = n; s_out = 8'hff; end
            3'b010: begin next_state = m; s_out = 8'hff; end
            3'b011: begin next_state = reset_state; s_out = 8'h74; end
            3'b100: begin next_state = reset_state; s_out = 8'h20; end 
            default: begin next_state = reset_state; s_out = 8'hff; end
        endcase

        // ---------------- u ----------------
        u:
        case (p_in)
            3'b000: begin next_state = state; s_out = 8'hff; end
            3'b001: begin next_state = f; s_out = 8'hff; end
            3'b010: begin next_state = ds3; s_out = 8'hff; end
            3'b011: begin next_state = reset_state; s_out = 8'h75; end
            3'b100: begin next_state = reset_state; s_out = 8'h20; end 
            default: begin next_state = reset_state; s_out = 8'hff; end
        endcase

        // ---------------- v ----------------
        v:
        case (p_in)
            3'b000: begin next_state = state; s_out = 8'hff; end
            3'b001: begin next_state = reset_state; s_out = 8'hff; end
            3'b010: begin next_state = three; s_out = 8'hff; end
            3'b011: begin next_state = reset_state; s_out = 8'h76; end
            3'b100: begin next_state = reset_state; s_out = 8'h20; end 
            default: begin next_state = reset_state; s_out = 8'hff; end
        endcase

        // ---------------- w ----------------
        w:
        case (p_in)
            3'b000: begin next_state = state; s_out = 8'hff; end
            3'b001: begin next_state = p; s_out = 8'hff; end
            3'b010: begin next_state = j; s_out = 8'hff; end
            3'b011: begin next_state = reset_state; s_out = 8'h77; end
            3'b100: begin next_state = reset_state; s_out = 8'h20; end 
            default: begin next_state = reset_state; s_out = 8'hff; end
        endcase

        // ---------------- x ----------------
        x:
        case (p_in)
            3'b000: begin next_state = state; s_out = 8'hff; end
            3'b001: begin next_state = reset_state; s_out = 8'hff; end
            3'b010: begin next_state = reset_state; s_out = 8'hff; end
            3'b011: begin next_state = reset_state; s_out = 8'h78; end
            3'b100: begin next_state = reset_state; s_out = 8'h20; end 
            default: begin next_state = reset_state; s_out = 8'hff; end
        endcase

        // ---------------- y ----------------
        y:
        case (p_in)
            3'b000: begin next_state = state; s_out = 8'hff; end
            3'b001: begin next_state = reset_state; s_out = 8'hff; end
            3'b010: begin next_state = reset_state; s_out = 8'hff; end
            3'b011: begin next_state = reset_state; s_out = 8'h79; end
            3'b100: begin next_state = reset_state; s_out = 8'h20; end
            default: begin next_state = reset_state; s_out = 8'hff; end
        endcase

        // ---------------- z ----------------
        z:
        case (p_in)
            3'b000: begin next_state = state; s_out = 8'hff; end
            3'b001: begin next_state = seven; s_out = 8'hff; end
            3'b010: begin next_state = reset_state; s_out = 8'hff; end
            3'b011: begin next_state = reset_state; s_out = 8'h7A; end
            3'b100: begin next_state = reset_state; s_out = 8'h20; end 
            default: begin next_state = reset_state; s_out = 8'hff; end
        endcase

        // ---------------- one ----------------
        one:
        case (p_in)
            3'b000: begin next_state = state; s_out = 8'hff; end
            3'b001: begin next_state = reset_state; s_out = 8'hff; end
            3'b010: begin next_state = reset_state; s_out = 8'hff; end
            3'b011: begin next_state = reset_state; s_out = 8'h31; end
            3'b100: begin next_state = reset_state; s_out = 8'h20; end 
            default: begin next_state = reset_state; s_out = 8'hff; end
        endcase

        // ---------------- two ----------------
        two:
        case (p_in)
            3'b000: begin next_state = state; s_out = 8'hff; end
            3'b001: begin next_state = reset_state; s_out = 8'hff; end
            3'b010: begin next_state = reset_state; s_out = 8'hff; end
            3'b011: begin next_state = reset_state; s_out = 8'h32; end
            3'b100: begin next_state = reset_state; s_out = 8'h20; end 
            default: begin next_state = reset_state; s_out = 8'hff; end
        endcase

        // ---------------- three ----------------
        three:
        case (p_in)
            3'b000: begin next_state = state; s_out = 8'hff; end
            3'b001: begin next_state = reset_state; s_out = 8'hff; end
            3'b010: begin next_state = reset_state; s_out = 8'hff; end
            3'b011: begin next_state = reset_state; s_out = 8'h33; end
            3'b100: begin next_state = reset_state; s_out = 8'h20; end 
            default: begin next_state = reset_state; s_out = 8'hff; end
        endcase

        // ---------------- four ----------------
        four:
        case (p_in)
            3'b000: begin next_state = state; s_out = 8'hff; end
            3'b001: begin next_state = reset_state; s_out = 8'hff; end
            3'b010: begin next_state = reset_state; s_out = 8'hff; end
            3'b011: begin next_state = reset_state; s_out = 8'h34; end
            3'b100: begin next_state = reset_state; s_out = 8'h20; end 
            default: begin next_state = reset_state; s_out = 8'hff; end
        endcase

        // ---------------- five ----------------
        five:
        case (p_in)
            3'b000: begin next_state = state; s_out = 8'hff; end
            3'b001: begin next_state = reset_state; s_out = 8'hff; end
            3'b010: begin next_state = reset_state; s_out = 8'hff; end
            3'b011: begin next_state = reset_state; s_out = 8'h35; end
            3'b100: begin next_state = reset_state; s_out = 8'h20; end 
            default: begin next_state = reset_state; s_out = 8'hff; end
        endcase

        // ---------------- six ----------------
        six:
        case (p_in)
            3'b000: begin next_state = state; s_out = 8'hff; end
            3'b001: begin next_state = reset_state; s_out = 8'hff; end
            3'b010: begin next_state = reset_state; s_out = 8'hff; end
            3'b011: begin next_state = reset_state; s_out = 8'h36; end
            3'b100: begin next_state = reset_state; s_out = 8'h20; end 
            default: begin next_state = reset_state; s_out = 8'hff; end
        endcase

        // ---------------- seven ----------------
        seven:
        case (p_in)
            3'b000: begin next_state = state; s_out = 8'hff; end
            3'b001: begin next_state = reset_state; s_out = 8'hff; end
            3'b010: begin next_state = reset_state; s_out = 8'hff; end
            3'b011: begin next_state = reset_state; s_out = 8'h37; end
            3'b100: begin next_state = reset_state; s_out = 8'h20; end 
            default: begin next_state = reset_state; s_out = 8'hff; end
        endcase

        // ---------------- eight ----------------
        eight:
        case (p_in)
            3'b000: begin next_state = state; s_out = 8'hff; end
            3'b001: begin next_state = reset_state; s_out = 8'hff; end
            3'b010: begin next_state = reset_state; s_out = 8'hff; end
            3'b011: begin next_state = reset_state; s_out = 8'h38; end
            3'b100: begin next_state = reset_state; s_out = 8'h20; end 
            default: begin next_state = reset_state; s_out = 8'hff; end
        endcase

        // ---------------- nine ----------------
        nine:
        case (p_in)
            3'b000: begin next_state = state; s_out = 8'hff; end
            3'b001: begin next_state = reset_state; s_out = 8'hff; end
            3'b010: begin next_state = reset_state; s_out = 8'hff; end
            3'b011: begin next_state = reset_state; s_out = 8'h39; end
            3'b100: begin next_state = reset_state; s_out = 8'h20; end 
            default: begin next_state = reset_state; s_out = 8'hff; end
        endcase

        // ---------------- zero ----------------
        zero:
        case (p_in)
            3'b000: begin next_state = state; s_out = 8'hff; end
            3'b001: begin next_state = reset_state; s_out = 8'hff; end
            3'b010: begin next_state = reset_state; s_out = 8'hff; end
            3'b011: begin next_state = reset_state; s_out = 8'h30; end
            3'b100: begin next_state = reset_state; s_out = 8'h20; end 
            default: begin next_state = reset_state; s_out = 8'hff; end
        endcase

        // ---------------- ds1 ----------------
        ds1:
        case (p_in)
            3'b000: begin next_state = state; s_out = 8'hff; end
            3'b001: begin next_state = nine; s_out = 8'hff; end
            3'b010: begin next_state = zero; s_out = 8'hff; end
            3'b011: begin next_state = reset_state; s_out = 8'hff; end
            3'b100: begin next_state = reset_state; s_out = 8'hff; end 
            default: begin next_state = reset_state; s_out = 8'hff; end
        endcase

        // ---------------- ds2 ----------------
        ds2:
        case (p_in)
            3'b000: begin next_state = state; s_out = 8'hff; end
            3'b001: begin next_state = eight; s_out = 8'hff; end
            3'b010: begin next_state = reset_state; s_out = 8'hff; end
            3'b011: begin next_state = reset_state; s_out = 8'hff; end
            3'b100: begin next_state = reset_state; s_out = 8'hff; end 
            default: begin next_state = reset_state; s_out = 8'hff; end
        endcase

        // ---------------- ds3 ----------------
        ds3:
        case (p_in)
            3'b000: begin next_state = state; s_out = 8'hff; end
            3'b001: begin next_state = reset_state; s_out = 8'hff; end
            3'b010: begin next_state = two; s_out = 8'hff; end
            3'b011: begin next_state = reset_state; s_out = 8'hff; end
            3'b100: begin next_state = reset_state; s_out = 8'hff; end 
            default: begin next_state = reset_state; s_out = 8'hff; end
        endcase

        // ---------------- default ----------------
        default:
        case (p_in)
            3'b000: begin next_state = state; s_out = 8'hff; end
            3'b001: begin next_state = reset_state; s_out = 8'hff; end
            3'b010: begin next_state = reset_state; s_out = 8'hff; end
            3'b011: begin next_state = reset_state; s_out = 8'hff; end
            3'b100: begin next_state = reset_state; s_out = 8'hff; end 
            default: begin next_state = reset_state; s_out = 8'hff; end
        endcase
    endcase
end

always @(posedge clk or negedge rst) begin
if(!rst)
s_out1 <= 'b0;
else
s_out1 <= s_out;
end
endmodule
