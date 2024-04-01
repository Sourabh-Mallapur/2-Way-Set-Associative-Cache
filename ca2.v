module cache_and_ram(
	input wire [7:0] address,
	input wire [7:0] data,
	input wire clk, reset, mode,	//mode equal to 1 when we write and equal to 0 when we read
	output wire [7:0] out, hit, miss
);

parameter ram_size = 256;  //size of ram
parameter block_size = 8;  //we consider a 256B Ram
reg [block_size - 1:0] ram [0:ram_size-1]; //data matrix for ram

parameter cache_size = 32; // No of bloacks in Cache
parameter set_size = 16; // No of Sets
parameter set_bits = 4; // No of bits requires for Set

reg [7:0] cache [0:set_size - 1][0:1]; // registers for the data in cache
reg [8 - set_bits - 1:0] tag_array [0:set_size - 1][0:1]; // for all tags in cache
reg valid_array [0:set_size - 1][0:1]; // 0 - there is no data 1 - there is data

//previous values
integer i, j;
reg [7:0] prev_address, prev_data;
reg prev_mode;
reg [7:0] temp_out;
reg [set_bits - 1:0] index;	// for keeping index of current address
reg [8 - set_bits - 1:0] tag;	// for keeping tag of current address
reg [15:0]lru_pointer;   // for keeping the least recently used way
reg [7:0] way0, way1;
reg way, temp_hit, temp_miss;

parameter[1:0]
    Idle = 0,
    Mode = 1,
    Read = 2,
    Write = 3;

reg [1:0] cur_state, next_state;

initial begin
    for (i = 0; i < set_size; i = i + 1) begin
        for (j = 0; j < 2; j = j + 1) begin
            valid_array[i][j] = 1'b0;
            cache[i][j] = 8'b0;
            
        end
    end
    
    for (i = 0; i < ram_size; i = i + 1) begin
        ram[i] = 7'b0;
    end
end

always @(posedge clk)
    if (reset)  begin
        index <= 0;
        tag <= 0;
        prev_address <= 0;
        prev_data <= 0;
        prev_mode <= 0;
        lru_pointer <= 0;
        cur_state <= 0;
        next_state <= 0;
        temp_hit <= 0;
        temp_miss <= 0;
        
    end
else
    cur_state <= next_state;

always @(*)
begin
    case (cur_state)
        Idle: begin
            if (prev_address != address || prev_data != data || prev_mode != mode)  begin
                prev_address = address;
                prev_data = data;
                prev_mode = mode;
                tag = prev_address >> set_bits;
                index = address % set_size; 
                next_state = Mode;
                temp_out = 7'bx;
                temp_hit = 0;
                temp_miss = 0;
            end
        end
        
        Mode: begin
            if (~prev_mode)
                next_state = Read;
            else
                next_state = Write;
        end
        
        Read: begin
            // index calculated 
            //way = lru_pointer[index];
            if (valid_array[index][way] == 1 && tag_array[index][way] == tag) begin // check in one way
                temp_out = cache[index][way];
                lru_pointer[index] = ~lru_pointer[index];
                temp_hit = 1;
                end
             
            else if (valid_array[index][~way] == 1 && tag_array[index][~way] == tag) begin // check in the other way
                temp_out = cache[index][~way];
                way =~ way;
                temp_hit = 1;
                end
                
            else  // if not in any, fetch from Ram and Update in cache 
                begin
                    valid_array[index][lru_pointer[index]] = 1;
					tag_array[index][lru_pointer[index]] = tag;
					cache[index][lru_pointer[index]] = ram[prev_address];
                    temp_out = cache[index][lru_pointer[index]];
                    temp_miss = 1;
                    // Update LRU    
                    lru_pointer[index] = ~lru_pointer[index];
				end
                
            next_state = Idle;    
        end
        
        Write:  begin            
            // update tag
            tag_array[index][lru_pointer[index]] = tag;
            cache[index][lru_pointer[index]] = data;
            valid_array[index][lru_pointer[index]] = 1'b1;
            way = lru_pointer[index];
            lru_pointer[index] = ~lru_pointer[index];                   
            
            ram[prev_address] = data;
            
            next_state = Idle;
        end
        
    endcase
end

assign out = temp_out;
assign hit = temp_hit;
assign miss = temp_miss;

endmodule