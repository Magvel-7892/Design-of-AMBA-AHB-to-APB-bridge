module ahb_master(hclk,hresetn,hrdata,hresp,hreadyout,hwrite,hreadyin,htrans,haddr,hwdata);
	input hclk,hresetn,hreadyout;
	input [1:0] hresp;
	input [31:0] hrdata;

	output reg hwrite;
	output reg hreadyin;
	output reg [1:0] htrans;
	output reg [31:0] haddr,hwdata;

	parameter idle = 2'b00, busy = 2'b01, non_seq = 2'b10, seq = 2'b11;
	integer i;

	task increment_4;
		begin

			@(posedge hclk)
			#1;
			begin 
				hwrite = 1'b1;
				htrans = non_seq;
				haddr = 32'h8100_0000;
				hreadyin =1'b1;
			end

			for(i=0;i<3;i++)
			begin 

				@(posedge hclk)
				#1;
				begin
					haddr = {haddr[31:2],haddr[1:0]+1'b1};
					htrans = seq;
					hwdata = ($random)%256;
				end

				@(posedge hclk);

			end

			@(posedge hclk)
			#1;
			begin 
				htrans = idle;
				hwdata = 32'h32000000;
			end



		end

		endtask

	task wrap_4_read;
		begin

			@(posedge hclk)
			#1;
			begin 
				hwrite = 1'b0;
				htrans = non_seq;
				haddr = 32'h8100_0000;
				hreadyin =1'b1;
			end

			for(i=0;i<3;i++)
			begin 
				@(posedge hclk)
				#1;
				begin
					haddr = {haddr[31:2],haddr[1:0]+1'b1};
					htrans = seq;
					//hwdata = ($random)%256;
				end

				@(posedge hclk);
			end

			@(posedge hclk)
			#1;
			begin 
				htrans = idle;
				//hwdata = 32'h32000000;
			end



		end

		endtask

	task increment_4_read;
		begin

			@(posedge hclk)
			#1;
			begin 
				hwrite = 1'b0;
				htrans = non_seq;
				haddr = 32'h8100_0000;
				hreadyin =1'b1;
			end

			for(i=0;i<3;i++)
			begin 
				@(posedge hclk)
				#1;
				begin
					haddr = haddr + 1'b1;
					htrans = seq;
					//hwdata = ($random)%256;
				end

				@(posedge hclk);
			end

			@(posedge hclk)
			#1;
			begin 
				htrans = idle;
				//hwdata = 32'h32000000;
			end



		end

		endtask


	task wrap_4;
		begin

			@(posedge hclk)
			#1;
			begin 
				hwrite = 1'b1;
				htrans = non_seq;
				haddr = 32'h8100_0000;
				hreadyin =1'b1;
			end

			for(i=0;i<3;i++)

			begin 
				@(posedge hclk)
				#1;
				begin
					haddr = haddr +1'b1;
					htrans = seq;
					hwdata = ($random)%256;
				end

				@(posedge hclk);
			end

			@(posedge hclk)
			#1;
			begin 
				htrans = idle;
				hwdata = 32'h32000000;
			end



		end

		endtask

	
	task single_write;

		begin 

			@(posedge hclk);
			#1;
			//address phase. Give the addr and control signals.
			begin 
				hwrite = 1'b1;
				htrans = non_seq;
				haddr = 32'h8100_0000;
				hreadyin =1'b1;
				hwdata = 32'b0;
			end

			@(posedge hclk);
			#1;
			//data phase. Give the data.
			begin
				htrans = idle;
				hwdata = 32'h1234_0000;
			end
		
		end

	endtask

	task single_read;
		
		begin 
			@(posedge hclk);

			@(posedge hclk);
			#1;
			begin 
				hwrite = 1'b0;
				htrans = non_seq;
				haddr = 32'h8100_0000;
				hreadyin =1'b1;
			end

			@(posedge hclk);
			#1;
			begin 
				htrans = idle;
				hreadyin = 1'b0;
			end
		end

	endtask

endmodule
