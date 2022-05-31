`timescale 1ns / 1ps
//***************************************************************//
//  File name: vga_controller.v                                  //
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
//  This module connects the vga_sync with the pixel_generation  //
//  module. The pixel_x, pixel_y, and video_on outputs from the  //
//  vga_sync module are used as inputs for the pixel_generation  //
//  module. These inputs are used to make a RGB signal.          //
//                                                               //
//***************************************************************//
module vga_controller(
		input clock, reset,
		input [1:0] btn,
		output hsync, vsync,
		output [11:0] rgb,
		output [9:0] pixel_x, pixel_y, // For testing/debugging only
		output clk_25_MHz, h_video_on, v_video_on, video_on // for debugging only
		);
		
	wire [11:0] rgb;
	wire [9:0] pixel_x, pixel_y;
	wire h_video_on, v_video_on;
	
	reg [2:0] rgb_reg;
	wire [2:0] rgb_next;

	vga_sync vga_sync_inst(
		.clock	(clock),
		.reset	(reset),
		.hsync	(hsync),
		.vsync	(vsync),
		.pixel_x (pixel_x), // required
		.pixel_y (pixel_y), // required
		.video_on(video_on), // required
		.clk_25_MHz(clk_25_MHz), // for debugging only
		.h_video_on(h_video_on), // for debugging only
		.v_video_on(v_video_on)  // for debugging only
		
   );
	
	//pixel_generation pixel_generation_inst(
	pong_graph_animate pong_graph_animate_inst(
		.clk			(clock),
		.reset		(reset),
		.video_on	(video_on), // required
		.btn			(btn),
		.pix_x		(pixel_x), // required
		.pix_y 		(pixel_y), // required
		.graph_rgb	(rgb_next)
	);
	
	// rgb buffer
	always @(posedge clock, posedge reset) begin
		if (reset)
			rgb_reg <= 3'b000;
		else if (clk_25_MHz) // pixel_tick
			rgb_reg <= rgb_next;
	end
	
	// output
	assign rgb = {{4{rgb_reg[2]}}, {4{rgb_reg[1]}}, {4{rgb_reg[0]}}};

endmodule
