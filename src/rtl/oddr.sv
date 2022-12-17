/*****************************************************************************
 * Output DDR Register
 *
 * Parameters:
 * Target:
 * - "ULTRASCALE"           - Xilinx - UG. 974
 * - "ULTRASCALE_PLUS"      - Xilinx - UG. 974
 * - "ULTRASCALE_PLUS_ES1"  - Xilinx - UG. 974
 * - "ULTRASCALE_PLUS_ES2"  - Xilinx - UG. 974
 *
 *****************************************************************************/

module oddr (clk, rst, d1, d2, q);
   parameter string TARGET = "RTL";

   input	    logic clk;
   input	    logic rst;
   input	    logic d1;
   input	    logic d2;
   output	    logic q;

   generate
      if(TARGET == "ULTRASCALE" ||
	 TARGET == "ULTRASCALE_PLUS" ||
	 TARGET == "ULTRASCALE_PLUS_ES1" ||
	 TARGET == "ULTRASCALE_PLUS_ES2") begin

	 ODDRE1 #(
		  .IS_C_INVERTED(1'b0),  // Optional inversion for C
		  .IS_D1_INVERTED(1'b0), // Unsupported, do not use
		  .IS_D2_INVERTED(1'b0), // Unsupported, do not use
		  .SIM_DEVICE(TARGET),
		  .SRVAL(1'b0)           // Initializes the ODDRE1 Flip-Flops
					 // to the specified value (1'b0, 1'b1)
		  )
	 ODDRE1_inst (
		      .Q(q),   // 1-bit output: Data output to IOB
		      .C(clk), // 1-bit input: High-speed clock input
		      .D1(d1), // 1-bit input: Parallel data input 1
		      .D2(d2), // 1-bit input: Parallel data input 2
		      .SR(rst) // 1-bit input: Active-High Async Reset
		      );
      end // Ultrascale

      else begin
	 logic d1_r;
	 logic d2_r;

	 // Sample inputs
	 always @(posedge clk) begin
	    d1_r <= d1;
	    d2_r <= d2;

	 end

	 assign q = clk ? d1_r : d2_r;

      end // Generic
   endgenerate
endmodule // oddr
