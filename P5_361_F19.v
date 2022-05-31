`timescale 1ns / 1ps
//***************************************************************//
//  File name: P5_361_F19.v                                      //
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
//  This module takes a synchronous reset from AISO and connects //
//  it to the debounce modules and vga_controller module. btn    //
//  represents 2 buttons as input, pixel_x is the horizontal     //
//  sync signal for the VGA output, pixel_y is the vertical sync //
//  signal for the VGA output, and rgb represents 12-bits for    //
//  red, green, and blue.													  //
//                                                               //
//***************************************************************//

module P5_361_F19(
       input clock, reset,
		 input [1:0] btn,
		 output vga_hs, vga_vs,
		 output [11:0] rgb
		 //output [9:0] pixel_x, pixel_y, // For testing/debugging only
		 //output clk_25_MHz, h_video_on, v_video_on, video_on // For testing/debugging only
       );
	
	// Local variables
	wire sync, video_on;
	wire [1:0] btn_debounced;
	wire [11:0] rgb;
	
	vga_controller vga_controller_inst(
		.clock	(clock),
		.reset	(sync),
		.btn		(btn),
		.hsync	(vga_hs),
		.vsync	(vga_vs),
		.rgb		(rgb),
		.pixel_x (pixel_x), // For testing only
		.pixel_y (pixel_y), // For testing only
		.clk_25_MHz(clk_25_MHz), // for debugging only
		.h_video_on(h_video_on), // for debugging only 
		.v_video_on(v_video_on), // for debugging only
		.video_on(video_on)		 // for debugging only
   );
	
	aiso aiso_inst(
		.clock   (clock), 
		.reset   (reset), 
		.sync		(sync)
		);
		
	mm_debounce mm_debounce_inst0(
		.clock	(clock),
		.reset	(sync),
		.sw		(btn[0]),
		.db		(btn_debounced[0])
   );
	
	mm_debounce mm_debounce_inst1(
		.clock	(clock),
		.reset	(sync),
		.sw		(btn[1]),
		.db		(btn_debounced[1])
   );
	
endmodule
