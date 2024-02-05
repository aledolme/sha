`timescale 1ns / 1ps

module sha3_224_tb();

//----------------------------------------------------------------
// Internal constant and parameter definitions.
//----------------------------------------------------------------  
parameter CLK_HALF_PERIOD = 1;
parameter CLK_PERIOD      = 2 * CLK_HALF_PERIOD;

//----------------------------------------------------------------
// Register and Wire declarations.
//----------------------------------------------------------------
reg [1151:0]  tb_sha3_in;
reg [511:0]   tb_sha3_out;
reg [9:0]     tb_mode;
reg           tb_start;
reg           tb_clk;
reg           tb_reset_n;  
reg           tb_done;  


//----------------------------------------------------------------
// clk_gen
//
// Always running clock generator process.
//----------------------------------------------------------------
always
begin : clk_gen
  #CLK_HALF_PERIOD;
  tb_clk = !tb_clk;
end // clk_gen



//----------------------------------------------------------------
// init_sim()
//
// Initialize all counters and testbed functionality as well
// as setting the DUT inputs to defined values.
//----------------------------------------------------------------
task init_sim;
 begin
  tb_clk        = 0;
  tb_reset_n    = 1;
  tb_sha3_in    = 1152'b0;
  tb_mode       = 2'b0;
 end
endtask // init_sim



//----------------------------------------------------------------
// reset_dut()
//
// Toggle reset to put the DUT into a well known state.
//----------------------------------------------------------------
task reset_dut;
 begin
  $display("*** Toggle reset.");
  tb_reset_n = 0;
      #(2 * CLK_PERIOD);
  tb_reset_n = 1;
  $display("");
 end
endtask // reset_dut


//----------------------------------------------------------------
// start_dut()
//
// Toggle start to make DUT starts.
//----------------------------------------------------------------
task start_dut;
 begin
  $display("*** Toggle Start.");
  tb_start = 0;
      #(2 * CLK_PERIOD);
  tb_start = 1;
      #(1 * CLK_PERIOD);
  tb_start = 0;
  $display("");
 end
endtask // reset_dut


//----------------------------------------------------------------
// read_input()
//----------------------------------------------------------------
//task read_input;
// begin
//  $readmemh("din.txt" , tb_sha3_in);
//  #(CLK_PERIOD);
// end
//endtask // read_input

//----------------------------------------------------------------
// set_sha3()
//----------------------------------------------------------------
task set_sha3;
 begin
  $display("*** Set SHA3 mode.");
  tb_mode = 10'b000001010; //SHA3-224 2-blocks
  //tb_mode = 10'b000000010; //SHA3-224 single block
  #(2 * CLK_PERIOD);
  $display("");
 end
endtask // set_sha3

task monitor_done;
    // Wait until the done signal becomes 1
    wait(tb_done);
    $display("Done signal is now 1.");
endtask


//----------------------------------------------------------------
// main
//
// The main test functionality.
//----------------------------------------------------------------
initial
 begin : main
    $display("   -= Testbench for SHA3 started =-");
    $display("    ==============================");
    $display("");

    init_sim();
    reset_dut();
   
    //SHA3-224 WORKING
    tb_sha3_in = 1152'ha5eb2173f0beb96d8e845c3db33a40efca9b70d631a25832c05590f4f8e1bfa999000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000080;
    
    set_sha3();
    #CLK_PERIOD;
    start_dut();
    #(6*CLK_PERIOD);
    //SHA3-224 2nd block
    tb_sha3_in = 1152'h45eb2173f0beb96d8e845c3db33a40efca9b70d631a25832c05590f4f8e1bfa906000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000080;
    
    monitor_done;

    $display("");
    $display("Data in hexadecimal format: %h", tb_sha3_out);
    $display("*** SHA3 simulation done. ***");
    #(4*CLK_PERIOD);
    $finish;
 end // main



// -- UUT ---------------------------------------------
sha3 uut_sha3(
    .clk(tb_clk),
    .reset_n(tb_reset_n),
    .start(tb_start),
    .sha3_ctrl(tb_mode),
    .done(tb_done),
    .sha3_in(tb_sha3_in),
    .sha3_out(tb_sha3_out));


endmodule

