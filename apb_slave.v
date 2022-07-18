module apb_slave(pwrite,penable,pselx,paddr,pwdata,pwrite_out,penable_out,pselx_out,paddr_out,
 pwdata_out,prdata);
	input pwrite, penable;
	input [2:0] pselx;
	input [31:0] paddr,pwdata;

	output pwrite_out,penable_out;
	output [2:0] pselx_out;
	output [31:0] paddr_out ,pwdata_out; 
	output reg [31:0] prdata;

	always @(*)
	begin
		if(penable && !pwrite)
			prdata = 32'h1234_0000;
		else
			prdata = 32'b0;
	end


	assign pwrite_out = pwrite;
	assign penable_out = penable;
	assign pselx_out = pselx;
	assign paddr_out = paddr;
	assign pwdata_out = pwdata;

endmodule
