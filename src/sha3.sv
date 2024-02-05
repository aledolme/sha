module sha3(
    // Clock and reset.
    input wire           clk,
    input wire           reset_n,
    input wire           start,
    // Control.
    input wire [9:0] sha3_ctrl,
    //00-SHA3-512, 01-SHA3-384, 11-SHA3-256, 10-SHA3-224
    output wire done,
    
    // Data ports.
    input wire [1151:0] sha3_in,
    output wire [511:0] sha3_out
);


    //----------------------------------------------------------------
    // Internal constant and parameter definitions.
    //----------------------------------------------------------------
    localparam CTRL_IDLE    = 3'h0;
    localparam CTRL_DONE    = 3'h1;
    localparam CTRL_PERMUTE = 3'h2;
    localparam CTRL_XORED   = 3'h3;
    //localparam CTRL_WAIT    = 3'h4;
    localparam CTRL_LAST   = 3'h5;
    
    //----------------------------------------------------------------
    // Registers including update variables and write enable.
    //----------------------------------------------------------------
    reg [2:0]    sha3_ctrl_reg;
    reg [2:0]    sha3_ctrl_new;
    reg          sha3_ctrl_we;

    reg          done_reg;
    reg          done_new;
    reg          done_we;
    
    reg [1599:0] state_reg;
    reg [1599:0] state_new;
    reg          state_we;
    
    reg [4:0]    round_number_reg;
    reg [4:0]    round_number_new;
    reg          round_number_we;
    
    
    reg [1599:0] xored_state;
    reg [1599:0] xored_value;
    reg [1599:0] xored_zeros;
    reg          input_keccak_mux;
    
    reg [7:0]    permutation_number;
    reg [7:0]    permutation_ref; 
    reg          permutation_done;
    
    
    reg [4:0][4:0][63:0]    round_in;
    reg [7:0]               round_constant_signal_out;
    reg [4:0]               round_number;
    reg [4:0][4:0][63:0]    round_out;
    
    reg         state_mux_sel;
    
    reg y0, y1, y2, y3, y4, y5, y6, y7;
    reg [7:0] RC;
    
    //----------------------------------------------------------------
    // Multiplers to properly select the input depening on which 
    // primitive is required. 
    ////----------------------------------------------------------------
    reg [1599:0] state;
    

    //----------------------------------------------------------------
    // UUT 
    //----------------------------------------------------------------
    input_pattern uut_input_pattern(
        .input_pattern_in(sha3_in),
        .input_pattern_mode(sha3_ctrl[1:0]),
        .input_pattern_out(state)
    );
    
    keccak_round uut_keccak(
        .round_in(round_in),
        .round_constant_signal(RC),
        .round_out(round_out)
    );
    
    
//    keccak_round_constants_gen uut_RC(
//        .round_number(round_number_new),
//        .round_constant_signal_out(round_constant_signal_out)
//    );
    
    //y = A'C + CE' + BDE' + A'B'D'E'
    assign y0 = (!round_number_new[4] & round_number_new[2]) | (round_number_new[2] & !round_number_new[0]) | (round_number_new[3] & round_number_new[1] & !round_number_new[0]) | (!round_number_new[4] & !round_number_new[3] & !round_number_new[1] & !round_number_new[0]);
    //y = BD'E' + BDE + BCD' + AC'E' + AC'D + B'C'DE' + A'CD'E' + A'B'C'D'E
    assign y1 = (round_number_new[3] & !round_number_new[1] & !round_number_new[0]) | (round_number_new[3] & round_number_new[1] & round_number_new[0]) | (round_number_new[3] & round_number_new[2] & !round_number_new[1]) | (round_number_new[4] & !round_number_new[2] & !round_number_new[0]) | (round_number_new[4] & !round_number_new[2] & round_number_new[1]) | (!round_number_new[3] & !round_number_new[2] & round_number_new[1] & !round_number_new[0]) | (!round_number_new[4] & round_number_new[2] & !round_number_new[1] & !round_number_new[0]) | (!round_number_new[4] & !round_number_new[3] & !round_number_new[2] & !round_number_new[1] & round_number_new[0]);
    assign y2 = 0;
    //y = BC' + BD' + BE' + C'DE' + AC'D + A'CD'E' + B'CDE
    assign y3 = (round_number_new[3] & !round_number_new[2]) | (round_number_new[3] & !round_number_new[1]) | (round_number_new[3] & !round_number_new[0]) | (!round_number_new[2] & round_number_new[1] & !round_number_new[0]) | (round_number_new[4] & !round_number_new[2] & round_number_new[1]) | (!round_number_new[4] & round_number_new[2] & !round_number_new[1] & !round_number_new[0]) | (!round_number_new[3] & round_number_new[2] & round_number_new[1] & round_number_new[0]);
    //y = BD' + A'CE' + ACD' + C'D'E + A'B'DE'
    assign y4 = (round_number_new[3] & !round_number_new[1]) | (!round_number_new[4] & round_number_new[2] & !round_number_new[0]) | (round_number_new[4] & round_number_new[2] & !round_number_new[1]) | (!round_number_new[2] & !round_number_new[1] & round_number_new[0]) | (!round_number_new[4] & !round_number_new[3] & round_number_new[1] & !round_number_new[0]);
    //y = A'DE' + A'CE' + CDE + AC'E' + ACD' + A'B'C'E
    assign y5 = (!round_number_new[4] & round_number_new[1] & !round_number_new[0]) | (!round_number_new[4] & round_number_new[2] & !round_number_new[0]) | (round_number_new[2] & round_number_new[1] & round_number_new[0]) | (round_number_new[4] & !round_number_new[2] & !round_number_new[0]) | (round_number_new[4] & round_number_new[2] & !round_number_new[1]) | (!round_number_new[4] & !round_number_new[3] & !round_number_new[2] & round_number_new[0]);
    //y = C'DE + BC'D + ADE + ACE' + B'CDE' + BCD'E' + A'B'CD'E
    assign y6 = (!round_number_new[2] & round_number_new[1] & round_number_new[0]) | (round_number_new[3] & !round_number_new[2] & round_number_new[1]) | (round_number_new[4] & round_number_new[1] & round_number_new[0]) | (round_number_new[4] & round_number_new[2] & !round_number_new[0]) | (!round_number_new[3] & round_number_new[2] & round_number_new[1] & !round_number_new[0]) | (round_number_new[3] & round_number_new[2] & !round_number_new[1] & !round_number_new[0]) | (!round_number_new[4] & !round_number_new[3] & round_number_new[2] & !round_number_new[1] & round_number_new[0]);
    //y = AD' + AE + A'B'D + A'CD + BCE
    assign y7 = (round_number_new[4] & !round_number_new[1]) | (round_number_new[4] & round_number_new[0]) | (!round_number_new[4] & !round_number_new[3] & round_number_new[1]) | (!round_number_new[4] & round_number_new[2] & round_number_new[1]) | (round_number_new[3] & round_number_new[2] & round_number_new[0]);
    
    assign RC = {y7, y6, y5, y4,y3,y2,y1,y0};
    
    vsx uut_vsx(
        .vsx_in_message(state[1151:0]),
        .vsx_in_state(xored_value),
        .vsx_mode(sha3_ctrl[1:0]),
        .vsx_out(xored_state)
    );
    
    output_pattern uut_output_pattern (
        .output_pattern_in(state_reg[511:0]),
        .output_pattern_out(sha3_out)
    );

    //----------------------------------------------------------------
    // Concurrent connectivity for ports etc.
    //----------------------------------------------------------------
    assign xored_zeros = 1599'h0;
    assign xored_value = (input_keccak_mux == 0) ? xored_zeros : round_out;
    //assign xored_state = xored_value ^ state;
    
    assign permutation_ref = sha3_ctrl[9:2];
    assign permutation_done = (permutation_number == permutation_ref) ? 1'b1 : 1'b0;
   
    
    assign done        = done_reg;
    assign round_in    = state_reg;
    assign state_new   = (sha3_ctrl_reg == 2'b00 | state_mux_sel==1'b1) ? xored_state  : round_out;
    // assign state_new   = (sha3_ctrl_reg == 2'b00 | sha3_ctrl_reg == 2'b10) ? xored_state  : round_out;
    //assign state_new   = (state_mux_sel==1'b0) ? xored_state  : round_out; 
    
    
     //----------------------------------------------------------------
     // reg_update
     //
     // Update functionality for all registers in the core.
     // All registers are positive edge triggered with asynchronous
     // active low reset. All registers have write enable.
     //----------------------------------------------------------------
     always @ (posedge clk or negedge reset_n)
     begin: reg_update
       if (!reset_n)begin
           done_reg  <= 1'b0;
           sha3_ctrl_reg <= CTRL_IDLE;
           state_reg <= 1600'b0;
       end else begin
           // Update the register with input data
           if (done_we)
            done_reg <= done_new;
           
           if (sha3_ctrl_we)
            sha3_ctrl_reg <= sha3_ctrl_new;
           
           if (state_we)
           state_reg <= state_new;
           
           if (round_number_we)
            round_number_reg <= round_number_new;
     
        end
    end // reg_update


    
    //----------------------------------------------------------------
    // sha3_ctrl_FSM
    //
    // Control FSM for sha3 core. Basically tracks if we are in
    // key init, encipher or decipher modes and connects the
    // different submodules to shared resources and interface ports.
    //----------------------------------------------------------------
      always @ (posedge clk or negedge reset_n)
      begin : sha3_ctrl_FSM
      
      if (!reset_n) begin
        done_we   = 1'b0;
        done_new = 1'b0;
        sha3_ctrl_new = CTRL_IDLE;
        sha3_ctrl_we = 1'b0;
        state_we = 1'b0;
        input_keccak_mux = 1'b0;
        state_mux_sel = 1'b0;
        permutation_number = 7'b0;
        
        round_number_we = 1'b0;
        round_number_new = 5'b0;
        
      end else begin
          case (sha3_ctrl_reg)
            
            CTRL_IDLE:
              begin
                
                if (start==1) begin
                    done_new  = 1'b0;
                    done_we   = 1'b1;
                    sha3_ctrl_new = CTRL_PERMUTE;
                    sha3_ctrl_we  = 1'b1;
                    state_we = 1'b1;
                    round_number_we = 1'b1;
                    round_number_new = 5'b0;
                    //state_mux_sel = 1'b1;
                    //state_new = state;
                    $display("Data in hexadecimal format: %h", round_in);
                    //round_in = state_reg;
                end
            end
            
            CTRL_XORED:
            begin
                done_new  = 1'b0;
                done_we   = 1'b1;
                sha3_ctrl_new = CTRL_PERMUTE;
                sha3_ctrl_we  = 1'b1;

                round_number_new = round_number_new + 1;
                state_we = 1'b1;
                round_number_we = 1'b1;
                //state_mux_sel = 1'b1;
            end
            
            CTRL_PERMUTE:
              begin
                if (round_number_new<22) begin
                    //round_in = state_reg;
                    
                    done_new         = 1'b0;
                    done_we          = 1'b1;
                    sha3_ctrl_new = CTRL_PERMUTE;
                    sha3_ctrl_we  = 1'b1;
                    round_number_new = round_number_new + 1;
                    state_we = 1'b1;
                    input_keccak_mux = 1'b1;
                    //state_mux_sel = 1'b1;

                    end else if (round_number_new == 22) begin
                    round_number_new = round_number_new + 1;
                   
                    
                        if (permutation_done) begin 
                            done_new         = 1'b1;
                            done_we          = 1'b1;
                            state_we = 1'b1;
                            sha3_ctrl_new = CTRL_IDLE;
                            state_mux_sel = 1'b0;
                        end else begin
                            sha3_ctrl_new = CTRL_XORED;
                            sha3_ctrl_we  = 1'b1;
                            state_we = 1'b1;
                            input_keccak_mux = 1'b1;
                            state_mux_sel = 1'b1;
                        end
                        
                        
                
                    end else begin
                    
                        sha3_ctrl_we  = 1'b1;
                        input_keccak_mux = 1'b1;
                        state_we = 1'b1;
                        round_number_new = 5'b0;
                        round_number_we = 1'b1;
                        permutation_number = permutation_number +1;
                        state_mux_sel = 1'b0;
                        
                end
            
              end //CTRL_PERMUTE 
            
            CTRL_LAST: 
            begin
                 if (permutation_done==1) begin 
                        done_new         = 1'b0;    
                        done_we          = 1'b0;
                        sha3_ctrl_new = CTRL_IDLE;
                        sha3_ctrl_we  = 1'b1;
                        round_number = 5'b0;
                        state_we = 1'b0;
                        
                    end else begin
                        done_new         = 1'b0;    
                        done_we          = 1'b1;
                        sha3_ctrl_new = CTRL_XORED;
                        sha3_ctrl_we  = 1'b1;
                        round_number = 5'b0;
                        state_we = 1'b1;
                        input_keccak_mux = 1'b1;
                        
                    end
            end
           
            default:
              begin
                // nothing to do
              end
          endcase // case (sha3_ctrl_reg)
      end //if_statement
    end // sha3_ctrl
                
endmodule //sha3