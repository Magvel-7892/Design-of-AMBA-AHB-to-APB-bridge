module bridge_fsm(valid,haddr_1,haddr_2,hw_data_1,hw_data_2,temp_selx,hreadyout,hclk,hresetn,hwrite,pwrite,penable,psel,paddr,pwdata,prdata,hwrite_reg,hresp,hrdata,ps,ns);

	input valid,hwrite,hclk,hresetn,hwrite_reg;
	input [2:0] temp_selx;
	input [31:0] haddr_2,haddr_1,hw_data_1,hw_data_2,prdata,haddr_3,hw_data_3;

	output reg pwrite,penable,hreadyout;
	output reg [31:0] paddr,pwdata;
	output reg [2:0] psel;
	output reg [1:0] hresp;
	output [31:0] hrdata;

	reg pwrite_temp,penable_temp,hreadyout_temp;
	reg [31:0] paddr_temp,pwdata_temp;
	reg [2:0] psel_temp;

	parameter st_idle = 3'b000,st_wait = 3'b001,st_read=3'b010,st_write=3'b011,st_writep=3'b100;
	parameter st_renable=3'b101,st_wenable=3'b110,st_wenablep=3'b111;

	output reg [2:0] ps,ns;
	reg [31:0] addr; 

	//present state logic
	always @(posedge hclk)
	begin 
		if( hresetn )
			ps <= st_idle;
		else
			ps <= ns; 
	end

	//next state and output logic
	always @(*)
	begin 
		ns = st_idle;
		case(ps)

			st_idle: begin 

				
				if( valid && !hwrite)
					ns = st_read;

				else if(valid && hwrite)
					ns = st_wait;

	  			else if(!valid)
					ns = st_idle;

				// //output 
				// pwdata_temp = 0;
				// penable_temp = 0;
				// psel_temp = 0;
				// pwrite_temp = 0;
				// paddr_temp = 0;
				// hreadyout_temp = 1;
			end

			
			st_wait: begin
				if(!valid)
					ns = st_write;
				else
					ns = st_writep;

				//output 
				// pwdata_temp = 0;
				// penable_temp = 1'b0;
				// psel_temp = 3'b000;
				// pwrite_temp = 1'b0;
				// paddr_temp = 32'h00000000;
				// hreadyout_temp = 1'b1;


			end 

			st_read: begin 
				ns = st_renable;

				//output 
				// pwdata_temp = 32'h0000_0000;
				// penable_temp = 1'b0;
				// psel_temp = temp_selx;
				// pwrite_temp = 1'b0;
				// paddr_temp = haddr_1;
				// hreadyout_temp = 1'b0;

			end

			st_write: begin
				if(valid)
					ns = st_wenablep;
				else
					ns = st_wenable;

				//output 
				// pwdata_temp = hw_data_1;
				// penable_temp = 1'b0;
				// psel_temp = temp_selx;
				// pwrite_temp = 1;
				// paddr_temp = haddr_1;
				// hreadyout_temp = 1'b1 ;

			end  

			st_writep:begin 
				ns  = st_wenablep;

				//output 
				// pwdata_temp = hw_data_1;
				// penable_temp = 1'b0;
				// psel_temp = temp_selx;
				// pwrite_temp = hwrite;
				// paddr_temp = haddr_2;
				// hreadyout_temp = 1'b0;
				// addr = paddr_temp;


			end

			st_renable:begin 
				if(!valid)
					ns = st_idle;

				else if(valid && !hwrite)
					ns = st_read;

				else if(valid && hwrite)
					ns =st_wait;

				// //output 
				// pwdata_temp = 0;
				// penable_temp = 1;

				// psel_temp = temp_selx;
				// pwrite_temp = 0;
				// paddr_temp = haddr_2;
				// hreadyout_temp = 1;


			end

			st_wenable: begin 
				if(!valid)
					ns = st_idle;
				else if(valid && !hwrite)
					ns = st_read;

				else if(valid && hwrite)
					ns =st_wait;

				//output 
				// pwdata_temp = hw_data_1;
				// penable_temp = 1'b1;
				// psel_temp = temp_selx;
				// pwrite_temp = 1;
				// paddr_temp = haddr_1;
				// hreadyout_temp = 1;


			end
			st_wenablep:begin 
				if(!valid && hwrite_reg)
					ns  = st_write;
				else if(valid && hwrite_reg)
					ns = st_writep;
				else
					ns = st_read;

				//output 
				// pwdata_temp = hw_data_2;
				// penable_temp = 1'b1;
				// psel_temp  = temp_selx;
				// pwrite_temp = 1;
				// paddr_temp = addr;
				// hreadyout_temp = 1 ;

			end


		endcase

	end

always@(*)
begin
	hreadyout_temp = 0;
	paddr_temp = 0;
	psel_temp = 0;
	penable_temp = 0;
	pwrite_temp = 0;
	pwdata_temp = 0;

case(ps)

	st_idle :begin
	 hreadyout_temp = 1;
	end

	st_read : begin 
		paddr_temp = haddr_1;
		psel_temp = temp_selx;
		hreadyout_temp = 0;
	end

	st_renable: begin
		penable_temp = 1;
		hreadyout_temp = 1;
		paddr_temp = haddr_2;
		psel_temp = temp_selx;
	end

	st_wenable: begin
		pwdata_temp = hw_data_1;
		paddr_temp = haddr_1;
		penable_temp = 1;
		psel_temp = temp_selx;
		hreadyout_temp = 1;
		pwrite_temp = 1;
	end

	st_write: begin 
		paddr_temp =haddr_1;
		pwdata_temp = hw_data_1;
		pwrite_temp = 1;
		penable_temp = 0;
		psel_temp = temp_selx;
		hreadyout_temp = 0;
	end

	st_wait:begin 
		hreadyout_temp = 1;
	end

	st_writep: begin 
		
		pwdata_temp = hw_data_1;
		pwrite_temp = 1;
		//penable_temp = 0;
		psel_temp = temp_selx;
		hreadyout_temp = 0;
		paddr_temp =haddr_2;
		addr = paddr_temp;

	end

	st_wenablep: begin
		pwrite_temp = 1;
		penable_temp = 1;
		psel_temp =temp_selx;
		
		pwdata_temp = hw_data_2;
		paddr_temp = addr;
		hreadyout_temp = 1;
	end
endcase

	end



	always @(*)
	begin 
		if(hresetn)
		begin 
			pwrite = 0;
			penable = 0;
			hreadyout = 0;
			paddr = 0;
			pwdata = 0;
			psel = 0;
		
		end

		else
		begin 
			pwrite = pwrite_temp; 
			penable = penable_temp;
			hreadyout = hreadyout_temp;

			paddr = paddr_temp;

			pwdata = pwdata_temp;
			psel = psel_temp;
			
			
			end
	end

	assign hrdata = prdata;

endmodule
