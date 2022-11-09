/*****************************************************************************
 * Input DDR Register
 *
 * Parameters:
 * Target:
 * - "ULTRASCALE"           - Xilinx - UG. 974
 * - "ULTRASCALE_PLUS"      - Xilinx - UG. 974
 * - "ULTRASCALE_PLUS_ES1"  - Xilinx - UG. 974
 * - "ULTRASCALE_PLUS_ES2"  - Xilinx - UG. 974
 *
 *****************************************************************************/

module iddr (clk, clkn, rst, d, q1, q2);
   parameter string TARGET = "ULTRASCALE";

   input	    logic clk;
   input	    logic clkn;
   input	    logic rst;
   input	    logic d;
   output	    logic q1;
   output	    logic q2;

   generate
      if(TARGET == "ULTRASCALE" ||
	 TARGET == "ULTRASCALE_PLUS" ||
	 TARGET == "ULTRASCALE_PLUS_ES1" ||
	 TARGET == "ULTRASCALE_PLUS_ES2") begin

	 IDDRE1 #(
		  // IDDRE1 mode (OPPOSITE_EDGE, SAME_EDGE, SAME_EDGE_PIPELINED)
		  .DDR_CLK_EDGE("OPPOSITE_EDGE"),
		  .IS_CB_INVERTED(1'b0), // Optional inversion for CB
		  .IS_C_INVERTED(1'b0) // Optional inversion for C
		  )
	 IDDRE1_inst (
		      .Q1(q1),   // 1-bit output: Registered parallel output 1
		      .Q2(q2),   // 1-bit output: Registered parallel output 2
		      .C(clk),   // 1-bit input: High-speed clock
		      .CB(clkn), // 1-bit input: Inversion of High-speed clock C
		      .D(d),     // 1-bit input: Serial Data Input
		      .R(rst)    // 1-bit input: Active-High Async Reset
		      );

      end // Ultrascale

      else begin
	 logic q1_r;
	 logic q2_r;

	 // Output inputs
	 always @(posedge clk) begin
	    q1 <= q1_r;
	    q2 <= q2_r;

	 end

	 // Sample data one
	 always @(posedge clk) begin
	    q1_r <= d;

	 end

	 // Sample data two
	 always @(negedge clk) begin
	    q2_r <= d;

	 end

      end // Generic
   endgenerate
endmodule // iddr
