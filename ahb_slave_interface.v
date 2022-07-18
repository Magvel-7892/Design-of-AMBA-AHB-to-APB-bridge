module AHB_SLAVE_INTERFACE(hclk,hresetn,hwrite,hreadyin,htrans,haddr,hwdata,valid,haddr_1,haddr_2,hwdata_1,hwdata_2,temp_selx,hwrite_reg);

  input hclk,hresetn,hreadyin,hwrite;
  input [1:0] htrans;
  input [31:0] haddr,hwdata;

  output reg valid;
  output reg hwrite_reg;
  output reg [2:0] temp_selx;
  output reg [31:0]  hwdata_2,hwdata_1,haddr_2,haddr_1,haddr_3,hwdata_3;

  parameter NONSEQ = 2'b10, SEQ= 2'b11;

  // address decoding

  always @(*)
  begin
    if(haddr >= 32'h80000000 && haddr < 32'h84000000)
      temp_selx = 3'b001;
    else if(haddr >= 32'h84000000 && haddr < 32'h88000000)
      temp_selx = 3'b010;
    else if(haddr >= 32'h88000000 && haddr < 32'h8C000000)
      temp_selx = 3'b100;
end

//pipelining

always @(posedge hclk)
begin 
  if(hresetn == 1'b1)
  begin 
    haddr_1 <= 32'h0;
    haddr_2 <= 32'h0;
    
    hwdata_1 <= 32'b0;
    hwdata_2 <= 32'b0;
    
    hwrite_reg <= 1'b0;
    end

  else
  begin
    haddr_1 <= haddr;
    haddr_2 <= haddr_1;
    

    hwdata_1 <= hwdata;

    hwdata_2 <= hwdata_1;

    

    hwrite_reg <= hwrite;

    end
end

//generating the valid signal

always @(*)
begin 
  valid = 1'b0;

  if(hreadyin == 1'b1 && (htrans == NONSEQ || htrans == SEQ) && (haddr >= 32'h80000000 && haddr < 32'h8C000000))
    valid = 1'b1;

end

endmodule
