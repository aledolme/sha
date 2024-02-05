module vsx(
    input wire [1151:0]   vsx_in_message,
    input wire [1599:0]   vsx_in_state,
    input wire [1:0]      vsx_mode,
    output wire [1599:0]  vsx_out
);
	

reg[1151:0] xored_state;	
reg[1599:0] vsx_state;
genvar row, col, i;


assign xored_state= vsx_in_state[1151:0] ^ vsx_in_message;
            
	
always @*
    begin
        case(vsx_mode) // @suppress "Default clause missing from case statement"
            2'b00: begin //SHA3-512
                vsx_state[1599:576] = vsx_in_state[1599:576] ; //c=1024
                vsx_state[575:0] = xored_state[575:0];
            end
           2'b01: begin //SHA3-384
                vsx_state[1599:832] = vsx_in_state[1599:832] ; //c=768
                vsx_state[831:0] = xored_state[831:0];
           end
           2'b10: begin //SHA3-224
                vsx_state[1599:1152] = vsx_in_state[1599:1152] ; // c=448
                vsx_state[1151:0] = xored_state;
           end
           2'b11: begin //SHA3-256
                vsx_state[1599:1088] = vsx_in_state[1599:1088] ; // c=512
                vsx_state[1087:0] = xored_state;
           end
           
        endcase
    end	
	
	
 assign vsx_out = vsx_state;
 
endmodule : vsx
