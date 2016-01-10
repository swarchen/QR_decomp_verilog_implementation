`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:49:31 01/09/2016 
// Design Name: 
// Module Name:    TOP 
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
module TOP(
     H1R,
     H1I,
     H2R,
     H2I,
     H3R,
     H3I,
     H4R,
     H4I,
     clk,
     rst_n,
     Y1R,
     Y1I,
     Y2R,
     Y2I,
     X1R,
     X1I,
     X2R,
     X2I
    );
	parameter width = 16;
	// Inputs
	input signed [width-1:0] H1R,H1I,H2R,H2I,H3R,H3I,H1R,H4R,H4I,Y1R,Y1I,Y2R,Y2I;
	input clk,rst_n;
	
	// Outputs
	output signed [width-1:0] X1R,X1I,X2R,X2I;
	
	// Regs
	reg signed [width-1:0]H[3:0][1:0];
	reg signed [width-1:0]H_tmp[3:0][1:0];
	reg signed [width-1:0]Y[0:3];
	reg signed [width-1:0]Y_tmp[0:3];
	reg [2:0] curr_state;
	reg [2:0] next_state;
	reg [2:0] i,j;
	
	// wires
	wire signed [width-1:0] V1URout,R1URout,R1UIout,R1UYRout,R1UYIout,V1DRout,R1DRout, R1DIout, R1DYRout, R1DYIout, R2Uout, R2UYout, R2Dout, R2DYout;
	wire signed [31:0] angle1,angle2,angle3;
	// states
	parameter IDLE = 3'b000;
	parameter QRSTG1 = 3'b001;
	parameter QRSTG2 = 3'b010;
	parameter QRSTG3 = 3'b011;
	parameter SOLVE = 3'b100;
	
	
	/* next state logic    
	always@(*)
	  case (curr_state)
		 IDLE    : if (w_i) next_state = QRSTG1;
					  else     next_state = IDLE;
		 QRSTG1  : if (w_i) next_state = QRSTG2;
					  else     next_state = IDLE;
		 QRSTG2  : if (w_i) next_state = QRSTG3;
					  else     next_state = IDLE;
		 QRSTG3  : if (w_i) next_state = SOLVE;
					  else     next_state = IDLE;
		 SOLVE   : if (w_i) next_state = S1;
					  else     next_state = IDLE;
		 default :          next_state = IDLE;
	  endcase  
	*/
	// state reg
	always@(posedge clk or negedge rst_n)
		if (!rst_n)
		begin
			curr_state <= IDLE;
			for (i = 0 ; i < 4 ; i = i+1)begin
				Y[i] <= 0;
				for (j = 0 ; j < 2 ; j = j + 1)begin
					H[i][j] <= 0;
				end
			end
		end
		else begin
			curr_state <= next_state;
			for (i = 0 ; i < 4 ; i = i+1)begin
			   Y[i] <= Y_tmp[i];
				for (j = 0 ; j < 2 ; j = j + 1)begin
					H[i][j] <= H_tmp[i][j];
				end
			end
		end
		
	// output logic
	always@(*)
		case (curr_state)
			IDLE    : begin
				
			end
			QRSTG1      : begin
			end
			QRSTG2      : begin
			end
			QRSTG3      : begin
			end
			SOLVE      : begin
			end
			default : begin
			end
		endcase
////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////Stage 1////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

CORDIC_V V1U(.clock(clk), .x_start(H1R), .y_start(H1I), .x_end(V1URout), .y_end(H_tmp[1][0]), .angle(angle1));
CORDIC_R R1UH(.clock(clk), .angle(angle1), .x_start(H3R), .y_start(H3I), .x_end(R1URout), .y_end(R1UIout));
CORDIC_R R1UY(.clock(clk), .angle(angle1), .x_start(Y1R), .y_start(Y1I), .x_end(R1UYRout), .y_end(R1UYIout));

CORDIC_V V1D(.clock(clk), .x_start(H2R), .y_start(H2I), .x_end(V1DRout), .y_end(H_tmp[3][0]), .angle(angle1));
CORDIC_R R1DH(.clock(clk), .angle(angle1), .x_start(H4R), .y_start(H4I), .x_end(R1DRout), .y_end(R1DIout));
CORDIC_R R1DY(.clock(clk), .angle(angle1), .x_start(Y2R), .y_start(Y2I), .x_end(R1DYRout), .y_end(R1DYIout));

////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////Stage 2////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

CORDIC_V V2(.clock(clk), .x_start(V1URout), .y_start(V1DRout), .x_end(H_tmp[0][0]), .y_end(H_tmp[2][0]), .angle(angle2));

CORDIC_R R2UH(.clock(clk), .angle(angle2), .x_start(R1URout), .y_start(R1DRout), .x_end(H_tmp[0][1]), .y_end(R2Uout));
CORDIC_R R2UY(.clock(clk), .angle(angle2), .x_start(R1UYRout), .y_start(R1DYRout), .x_end(Y_tmp[0]), .y_end(R2UYout));
CORDIC_R R2DH(.clock(clk), .angle(angle2), .x_start(R1UIout), .y_start(R1DIout), .x_end(H_tmp[1][1]), .y_end(R2Dout));
CORDIC_R R2DY(.clock(clk), .angle(angle2), .x_start(R1UYIout), .y_start(R1DYIout), .x_end(Y_tmp[1]), .y_end(R2DYout));

////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////Stage 3////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
CORDIC_V V3(.clock(clk), .x_start(R2Uout), .y_start(R2Dout), .x_end(H_tmp[2][1]), .y_end(H_tmp[3][1]), .angle(angle3));
CORDIC_R R3Y(.clock(clk), .angle(angle3), .x_start(R2UYout), .y_start(R2DYout), .x_end(Y_tmp[2]), .y_end(Y_tmp[3]));




endmodule
