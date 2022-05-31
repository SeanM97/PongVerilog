`timescale 1ns / 1ps
//***************************************************************//
//  File name: vga_sync.v                                        //
//                                                               //
//  Created by    Sean Masterson on December 5, 2019             //
//  Copyright (c) 2019 Sean Masterson. All rights reserved.      //
//                                                               //
//                                                               //
//  In submitting this file for class work at CSULB              //
//  I am confirming that this is my work and the work            //
//  of no one else. In submitting this code I acknowledge that   //
//  plagiarism in student project work is subject to dismissal   //
//  from the class                                               //
//                                                               //
//  This module takes a clock expected to be 100 MHz and divides //
//  its frequency by 4, or 25 MHz. A counter register is used    //
//  for a horizontal scan count and vertical scan count value.   //
//  The horizontal scan count counts from 0 to 799 while the     //
//  vertical one from 0 to 524. The horizontal scan counter is   //
//  updated once every 40 ns, while the vertical scan counter is //
//  updated after the horizontal scan counter reaches 799. The   //
//  hsync signal is low active and is active when the horizontal //
//  scan counter is from 656 through 751. The vsync signal is    //
//  vertical scan counter is from 490 through 491. The vertical  //
//  also low active and is active when the video on signal is on //
//  from 0 to 479 while the horizontal one is from 0 to 799.     //
//  video_on is active when both the vertical and horizontal     //
//  video on signals are active.                                 //
//                                                               //
//***************************************************************//
module vga_sync(
	 input clock, reset,
	 output hsync, vsync, video_on,
	 output [9:0] pixel_x, pixel_y,
	 output clk_25_MHz,                 // for debugging only
	 output h_video_on, v_video_on // for debugging only
    );
	 
	assign pixel_x = hcount;
	assign pixel_y = vcount;
	// number of counter bits 
	localparam N = 2;
		
	// declare local variables
	reg [N-1:0] q_reg;
	wire [N-1:0] q_next;
	wire [9:0] mux_1, mux_2;
	wire hcomplete, h_video_on;
	wire [9:0] mux_3, mux_4;
	wire vcomplete, v_video_on;
	
	reg [9:0] hcount, vcount;
	wire clk_25_MHz;
	
	// counter to generate 25 MHz clock
	always@(posedge clock, posedge reset)
		if (reset == 1'b1)
			q_reg <= 1'b0;
		else
			q_reg <= q_next;
		
	// next-state logic
	assign q_next = (clk_25_MHz) ? 1'b0 : (q_reg + 1);
	// output tick
	assign clk_25_MHz = (q_reg == 3) ? 1'b1 : 1'b0;
	
	// 1st mux for hcount
	assign mux_1 = (hcomplete) ? 10'b0 : (hcount + 10'b1);
	// 2nd mux for hcount
	assign mux_2 = (clk_25_MHz) ? mux_1 : hcount;
	 
	always@(posedge clock, posedge reset)
		if (reset == 1'b1)
			hcount <= 10'b0;
		else
			hcount <= mux_2;
	
	assign hcomplete = (hcount == 799) ? 1'b1 : 1'b0;
	assign hsync = (hcount >= 656 & hcount <= 751) ? 1'b0 : 1'b1;
	assign h_video_on = (hcount >= 0 & hcount <= 639) ? 1'b1 : 1'b0;
	
	// 1st mux for vcount
	assign mux_3 = (vcomplete) ? 10'b0 : (vcount + 10'b1);
	// 2nd mux for vcount
	assign mux_4 = ({hcomplete, clk_25_MHz} == 2'b11) ? mux_3 : vcount;
	
	always@(posedge clock, posedge reset)
		if (reset == 1'b1)
			vcount <= 10'b0;
		else
			vcount <= mux_4;
	
	assign vcomplete = (vcount == 524) ? 1'b1 : 1'b0;
	assign vsync = (vcount >= 490 & vcount <= 491) ? 1'b0 : 1'b1;
	assign v_video_on = (vcount >= 0 & vcount <= 479) ? 1'b1 : 1'b0;
	assign video_on = (v_video_on & h_video_on);

endmodule
