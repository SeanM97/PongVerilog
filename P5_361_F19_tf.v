`timescale 1ns/1ns
//***************************************************************//
//  File name: P5_361_F19_tf.v                                   //
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
//  This module instantiates the unit under test and gives it    //
//  various inputs. The outputs are checked by simluating it     //
//  and looking at the outputs in the waveform. A clock is       //
//  is simulated by negating a register once every 5 ns. The     //
//  reset signal is initially set high, then set low after 50    //
//  ns.                                                          //
//                                                               //
//***************************************************************//

module P5_361_F19_tf();

///////////////////////////////////////////////
// declare the inputs of the design
///////////////////////////////////////////////
reg        clock;
reg        reset;

///////////////////////////////////////////////
// declare the outputs of the design
///////////////////////////////////////////////
wire vga_hs, vga_vs, clk_25_MHz, h_video_on, v_video_on, video_on;
wire [15:0] hcount, vcount;
wire [11:0] rgb;

///////////////////////////////////////////////
// instantiate the design under test
///////////////////////////////////////////////		 
P5_361_F19 P5_361_inst
      (
       .clock   (clock), 
       .reset   (reset), 
       .btn     (2'b00), 
		 .vga_hs	(vga_hs), 
		 .vga_vs (vga_vs),
       .rgb		(rgb),
		 .hcount(hcount),        // for debugging only
		 .vcount(vcount),        // for debugging only
		 .clk_25_MHz(clk_25_MHz),// for debugging only
		 .h_video_on(h_video_on),
		 .v_video_on(v_video_on),
		 .video_on(video_on)
       );

always #5 clock = ~clock;

initial begin
   clock  = 0;
   reset  = 1;
   #50
   reset  = 0;
   end

endmodule
