`timescale 1ns / 1ps
//***************************************************************//
//  File name: mm_debounce.v                                     //
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
//  The counter part of the code below is a modified version of  //
//  the code that is found in FPGA Prototyping By Verilog        //
//  by Pong P. Chu pages 131-133.                                //
//                                                               //
//  This module uses a modified more state machine to debounce   //
//  the input sw with the debounced output being db. The clock   //
//  is assumed to be 100 MHz. A counter is used to count up      //
//  from 0 to 99999 to produce a pulse every 10 ms. The amount   //
//  the counter counts up by is determined by dividing the input //
//  frequency (100 MHz) by the output frequency (100 Hz) minus   //
//  one. When reset, the state machine starts in state zero,     //
//  which checks for when the switch goes high, and if so, go to //
//  the state wait1_1, else stay. If the switch goes low again,  //
//  return to state zero. If it goes high, wait 10 ms, then move //
//  to the next state. Since the timer was already started       //
//  before entering state wait1_1 the amount of time we are in   //
//  this state may vary from 0 to 10 ms. If the input is still   //
//  high, move to the state wait1_2, where exactly 10 ms will be //
//  waited before we can move to the next state. In wait1_3,     //
//  wait another 10 ms before moving to state one, in which the  //
//  output goes high, indicating that the input has remained     //
//  highcontinuously for the past 20 to 30 ms. This effectively  //
//  acts as a digital filter, as signals less than 20 ms in      //
//  length on the input are ignored. Once in state one, the same //
//  process is repeated, but with the output and inputs inverted.//
//                                                               //
//***************************************************************//
module mm_debounce(
	input clock, reset, sw,
	output reg db
   );
	
	// Names of the states
	localparam	[2:0]
					zero    = 3'b000,
					wait1_1 = 3'b001,
					wait1_2 = 3'b010,
					wait1_3 = 3'b011,
					one     = 3'b100,
					wait0_1 = 3'b101,
					wait0_2 = 3'b110,
					wait0_3 = 3'b111;
					
	// number of counter bits 
	localparam N = 20;
	
	// declare local variables
	reg [2:0] state, next_state;
	reg next_out;
	reg [N-1:0] q_reg;
	wire [N-1:0] q_next;
	wire m_tick;
	
	// counter to generate 10 ms tick
	always@(posedge clock)
		q_reg <= q_next;
	// next-state logic
	assign q_next = (m_tick) ? 1'b0 : q_reg + 1;
	// output tick
	assign m_tick = (q_reg == 999999) ? 1'b1 : 1'b0;
	
	///////////////////////////////
	// combinational logic block //
	///////////////////////////////
	always @(*)
		begin
		case (state)
			zero:
				{next_state, next_out} = (!sw) ? {zero, 1'b0} :
												 {wait1_1, 1'b0};
			
			wait1_1:
				{next_state, next_out} = (!sw) ? {zero, 1'b0} :
												 (m_tick) ? {wait1_2, 1'b0} :
												 {wait1_1, 1'b0};
			wait1_2:
				{next_state, next_out} = (!sw) ? {zero, 1'b0} :
												 (m_tick) ? {wait1_3, 1'b0} :
												 {wait1_2, 1'b0};
			
			wait1_3:
				{next_state, next_out} = (!sw) ? {zero, 1'b0} :
												 (m_tick) ? {one, 1'b1} :
												 {wait1_3, 1'b0};
			one:
				{next_state, next_out} = (sw) ? {one, 1'b1} :
												 {wait0_1, 1'b1};
			
			wait0_1:
				{next_state, next_out} = (sw) ? {one, 1'b1} :
												 (m_tick) ? {wait0_2, 1'b1} :
												 {wait0_1, 1'b1};
												 
			wait0_2:
				{next_state, next_out} = (sw) ? {one, 1'b1} :
												 (m_tick) ? {wait0_3, 1'b1} :
												 {wait0_2, 1'b1};
			
			wait0_3:
				{next_state, next_out} = (sw) ? {one, 1'b1} :
												 (m_tick) ? {zero, 1'b0} :
												 {wait0_3, 1'b1};
												 
			default:
				{next_state, next_out} = {zero, 1'b0};
								 
			endcase
		end
		
	///////////////////////////////
	// sequential logic block    //
	///////////////////////////////
	always @(posedge clock, posedge reset)
		if (reset) begin
			state <= zero;
			db <= 1'b0;
			end
		else begin
			state <= next_state;
			db <= next_out;
			end
		
	endmodule
