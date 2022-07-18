module bridge_top(hclk,hresetn,hwrite,hreadyin,htrans,haddr,hwdata,prdata,
					pwrite,penable,psel,paddr,pwdata,hreadyout,hresp,hrdata,ps,ns);


	input hclk,hresetn,hwrite,hreadyin;
	input [1:0]htrans;
	input [31:0] haddr,hwdata,prdata;

	output pwrite,penable;
	output [2:0] psel,ps,ns;
	output [31:0] paddr,pwdata,hrdata;
	output hreadyout;
	output [1:0] hresp;

	wire [31:0] haddr_1,haddr_2,hwdata_1,hwdata_2,hrdata;
	wire [2:0]temp_selx;


	bridge_fsm uut1(valid,haddr_1,haddr_2,hwdata_1,hwdata_2,temp_selx,hreadyout,hclk,hresetn,hwrite,pwrite,penable,psel,paddr,pwdata,prdata,hwrite_reg,hresp,hrdata,ps,ns);
	ahb_slave_interface uut2(hclk,hresetn,hwrite,hreadyin,htrans,haddr,hwdata,valid,haddr_1,haddr_2,hwdata_1,hwdata_2,temp_selx,hwrite_reg);

endmodule
