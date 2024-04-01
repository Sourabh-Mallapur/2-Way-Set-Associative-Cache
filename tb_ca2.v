module testbench;

reg [7:0] address, data;
reg mode, clk, reset;
wire [7:0] out;

cache_and_ram tb(
	.address(address),
	.data(data),
	.mode(mode),
	.clk(clk),
    .reset(reset),   
	.out(out)
);

initial begin
    $monitor("address = %d data = %d mode = %d out = %d", address , data, mode, out);
    $dumpfile("dump.vcd");
    $dumpvars(0,testbench);
   
    reset = 1;	clk = 1;
    
    #5; reset = 0;
	
    address = 8'b10101100;
	data =    8'b11110000;
	mode = 1'b1;
    
    
    #100;
    address = 8'b10101100;			
	data =    8'b11110000;			
	mode = 1'b0;

    #100;
    
    address = 8'b10111100;			
	data =    8'b11000011;			
	mode = 1'b0; 
    
    #100;
    
    address = 8'b10111100;			
	data =    8'b11000011;			
	mode = 1'b1;
    
    #100;
    
    address = 8'b10111100;			
	data =    8'b11000011;			
	mode = 1'b0;   
    
    #100;
    
    address = 8'b10101100;			
	data =    8'b11000011;			
	mode = 1'b0;
    
    #300;

    $finish;
end    

always #10 clk = ~clk;

endmodule 
