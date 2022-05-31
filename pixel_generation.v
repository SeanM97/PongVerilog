`timescale 1ns / 1ps
//***************************************************************//
//  File name: pixel_generation.v                                //
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
//  This module takes inputs pixel_x and pixel_y and uses these  //
//  values to determine which pixel is currently being drawn to  //
//  the screen. Certain static objects are expected to be drawn  //
//  dependinging on the current pixel_x and pixel_y values,      //
//  at which rgb_out will be set equal to the value of the input //
//  sw.                                                          //
//                                                               //
//***************************************************************//
module pixel_generation(
		input clock, reset, video_on,
		input [11:0] sw,
		input [9:0] pixel_x, pixel_y,
		output [11:0] rgb_out
	);
	
	wire [11:0] rgb_out;
	reg [11:0] rgb;
	
	assign rgb_out = video_on ? rgb : 3'b000;
	//assign rgb_out = 12'hFFF;
	
	always@(posedge clock, posedge reset)
		if (reset == 1'b1)
			rgb <= 12'b0000_0000_0000;
		else begin
			// wall
			if (pixel_x >= 32 & pixel_x <= 35)
				rgb <= sw;
			
			// paddle
			else if (pixel_x >= 600 & pixel_x <= 603 & pixel_y >= 204 & pixel_y <= 276)
				rgb <= sw;
				
			// ball
			else if (pixel_x >= 580 & pixel_x <= 588 & pixel_y >= 238 & pixel_y <= 246)
				rgb <= sw;
				
			else
				rgb <= 3'b000;
		end
		
	
endmodule
