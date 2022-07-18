module tb;

	parameter period=10;

	reg hclk,hresetn;


	wire [31:0] hrdata,haddr,hwdata,paddr,pwdata,prdata,paddr_out,pwdata_out;

	wire [2:0] pselx,pselx_out,ps,ns;

	wire hreadyout,hwrite,hreadyin,penable,pwrite,pwrite_out,penable_out;
	wire [1:0] htrans,hresp;	

	ahb_master uut1(hclk,hresetn,hrdata,hresp,hreadyout,hwrite,hreadyin,htrans,haddr,hwdata);
	bridge_top uut2(hclk,hresetn,hwrite,hreadyin,htrans,haddr,hwdata,prdata,pwrite,penable,pselx,paddr,pwdata,hreadyout,hresp,hrdata,ps,ns);
	apb_slave uut3(pwrite,penable,pselx,paddr,pwdata,pwrite_out,penable_out,pselx_out,pwdata_out,pwdata_out,prdata);

	always
  	begin
    #(period/2);
      hclk = 1'b0;

    #(period/2);
      hclk=~hclk;
  	end 

	initial
	begin 
		hclk = 0;
		hresetn = 1'b1;
		#11 hresetn = 1'b0;
	end

	initial
	begin 

	$dumpfile("tb2.vcd");
	$dumpvars(0,tb);
	
	//uut1.single_write;
	//uut1.single_read;
	//uut1.increment_4;
	uut1.wrap_4;
	//uut1.increment_4_read;
	#100 $finish;
	end
endmodule
