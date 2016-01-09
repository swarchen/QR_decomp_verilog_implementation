`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:56:55 01/09/2016 
// Design Name: 
// Module Name:    cordic_v_test 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
`timescale 1 ns/100 ps

module cordic_v_test;

localparam  SZ = 16; // bits of accuracy

reg  [SZ-1:0] Xin, Yin;
wire  [31:0] angle;
wire [SZ:0] Xout, Yout;
reg         CLK_100MHZ;
//
// Waveform generator
//
localparam FALSE = 1'b0;
localparam TRUE = 1'b1;

localparam VALUE_X = 22622/1.647; // reduce by a factor of 1.647 since thats the gain of the system
localparam VALUE_Y = -22623/1.647; // reduce by a factor of 1.647 since thats the gain of the system

reg signed [63:0] i;
reg      start;

initial
begin
   start = FALSE;
   $write("Starting sim");
   CLK_100MHZ = 1'b0;
   Xin = VALUE_X;                     // Xout = 32000*cos(angle)
   Yin = VALUE_Y;                      // Yout = 32000*sin(angle)
	$display ("X = %b Y = %b",Xin,Yin);
   #1000;
   @(posedge CLK_100MHZ);
   start = TRUE;


   @(posedge CLK_100MHZ);
   start = FALSE;

   #500
   $write("Simulation has finished");
   $stop;
end

CORDIC_V vector(CLK_100MHZ, Xin, Yin, Xout, Yout, angle);

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