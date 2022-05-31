`timescale 1ns / 1ps
//***************************************************************//
//  File name: aiso.v                                            //
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
//  This module accepts an asyncronous reset, and outputs a      //
//  syncronous reset output. To do this, two flip-flops are      //
//  used. The first flip flop accepts an input of 1 and a reset  //
//  being the asyncronous reset, and the second flop accepts the //
//  output of the first flop with the asyncronous reset.         //
//  The output of the first and second flops is a 1 when reset   //
//  is 0, and a 0 when reset a 1. The output is inverted to make //
//  the syncronous be a 1 when reset was a 1 and 0 when reset    //
//  was a 0.                                                     //
//                                                               //
//***************************************************************//
module aiso(
		input clock, reset, 
		output sync
		);

	reg q1, q2;
	
	///////////////////////////////
	// sequential logic block    //
	///////////////////////////////
	always@(posedge clock, posedge reset)
		if (reset)
			{q1, q2} <= 2'b00;
		else
			{q1, q2} <= {1'b1, q1};
	
	assign sync = ~q2;
			
endmodule
