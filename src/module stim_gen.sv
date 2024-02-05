module stim_gen (
   // Outputs
   clk, data
   );
   output clk;
   output [63:0] data;
   reg    clk;
   reg [63:0] data;
   integer   fd;
   integer   code, dummy;
   reg [8*10:1] str;
   
   initial begin
      fd = $fopen("_input.dat","r"); 
      clk = 0;
      data = 0;
      code = 1;
      $monitor("data = %x", data);
      while (code) begin
         code = $fgets(str, fd);
         dummy = $sscanf(str, "%x", data);
         @(posedge clk);
      end
      $finish;
   end // initial begin
   always #5 clk = ~clk;
endmodule // stim_gen