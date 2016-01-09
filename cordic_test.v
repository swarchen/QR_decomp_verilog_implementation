`timescale 1 ns/100 ps

module cordic_r_test;

localparam  SZ = 16; // bits of accuracy

reg  [SZ-1:0] Xin, Yin;
reg  [31:0] angle;
wire [SZ:0] Xout, Yout;
reg         CLK_100MHZ;
//
// Waveform generator
//
localparam FALSE = 1'b0;
localparam TRUE = 1'b1;

localparam VALUE = 32000/1.647; // reduce by a factor of 1.647 since thats the gain of the system

reg signed [63:0] i;
reg      start;

initial
begin
   start = FALSE;
   $write("Starting sim");
   CLK_100MHZ = 1'b0;
   angle = 0;
   Xin = VALUE;                     // Xout = 32000*cos(angle)
   Yin = 1'd0;                      // Yout = 32000*sin(angle)
	$display ("X = %b",Xin);
   #1000;
   @(posedge CLK_100MHZ);
   start = TRUE;


   @(posedge CLK_100MHZ);
   start = FALSE;
   angle = ((1 << 32)*(64'd45))/360;    // example: 45 deg = 45/360 * 2^32 = 32'b00100000000000000000000000000000 = 45.000 degrees -> atan(2^0)
   $display ("angle = %d, %d",i, angle);

   #500
   $write("Simulation has finished");
   $stop;
end

CORDIC_R rotation (CLK_100MHZ, angle, Xin, Yin, Xout, Yout);

parameter CLK100_SPEED = 10;  // 100Mhz = 10nS

initial
begin
  CLK_100MHZ = 1'b0;
  $display ("CLK_100MHZ started");
  #5;
  forever
  begin
    #(CLK100_SPEED/2) CLK_100MHZ = 1'b1;
    #(CLK100_SPEED/2) CLK_100MHZ = 1'b0;
  end
end

endmodule