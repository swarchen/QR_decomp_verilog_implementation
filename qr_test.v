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

reg  [SZ-1:0] H1R,H1I,H2R,H2I,H3R,H3I,H4R,H4I,Y1R,Y1I,Y2R,Y2I;

wire [SZ:0] X1R, X1I,X2R,X2I;
reg         CLK_100MHZ,rst_n;
//
// Waveform generator
//
localparam FALSE = 1'b0;
localparam TRUE = 1'b1;

localparam VALUE_H1R = 1.3333;
localparam VALUE_H1I = 0;
localparam VALUE_H2R = -0.6318;
localparam VALUE_H2I = 0.2621;
localparam VALUE_H3R = 0.2712;
localparam VALUE_H3I = -0.6801;
localparam VALUE_H4R = -0.2118;
localparam VALUE_H4I = 0.9433;

localparam VALUE_Y1R = -1.61524402024947;
localparam VALUE_Y1I = -0.653437376488438;
localparam VALUE_Y2R = 1.44886179463782;
localparam VALUE_Y2I = -0.255831233430924;

reg signed [63:0] i;
reg      start;

initial
begin
   start = FALSE;
   $write("Starting sim");
   CLK_100MHZ = 1'b0;
	#200
	@(posedge CLK_100MHZ);
   start = TRUE;
   @(posedge CLK_100MHZ);
   start = FALSE;
	
   Y1R = VALUE_Y1R;
   Y1I = VALUE_Y1I;
	Y2R = VALUE_Y2R;
   Y2I = VALUE_Y2I;
	
	H1R = VALUE_H1R;
	H1I = VALUE_H1I;
	H2R = VALUE_H2R;
	H2I = VALUE_H2I;
	H3R = VALUE_H3R;
	H3I = VALUE_H3I;
	H4R = VALUE_H4R;
	H4I = VALUE_H4I;
	
   #500
   $write("Simulation has finished");
   $stop;
end

TOP TT0( H1R,H1I,H2R,H2I,H3R,H3I,H4R,H4I,CLK_100MHZ, rst_n,Y1R,Y1I,Y2R,Y2I,X1R,X1I,X2R,X2I);

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