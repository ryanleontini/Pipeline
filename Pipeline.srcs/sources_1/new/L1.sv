`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Nikolai Downs
// 
// Create Date: 11/25/2023 04:34:17 PM
// Design Name: 
// Module Name: L1
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module L1(  input logic clk,
            input logic rst,
            
            input logic [29:0] raddress,    // 25b Tag, 3b indx, 2b word offset
            output logic [31:0] rdata,      // Output one word
            output logic miss,               // MAIN MEMORY
            
            input logic delivered,
            input logic [127:0] blockin
          );
          
    
    reg [255:0] DATA[7:0];          // ARRAY: 8 sets & 8 words per set (line).
    reg [25:0] INFO[7:0][1:0];      // TAG (25b), Valid bit (per block)
    reg LRU [7:0];
    
    logic waiting;
    logic [2:0] rline;
    logic [7:0] roffset;
    logic [7:0] woffset;
    
    assign rline = raddress[4:2];
    assign woffset = 128*(~LRU[rline]) + 127;
   
   
    always_ff @(posedge clk) begin
    
        if (rst) begin
            for (int i = 0; i < 7; ++i) begin
                waiting <= 0;
                LRU[i] <= '0;
                DATA[i] <= '0;
                INFO[i][0] <= '0; 
                INFO[i][1] <= '0; end end
        
        else if (waiting && delivered) begin
            waiting <= 0;
                
            DATA[rline][woffset -: 128] <= blockin;
            INFO[rline][LRU[rline]] <= {raddress[29:5], 1'b1};
            LRU[rline] <= ~LRU[rline]; end end
            
    always_comb begin       
            
        if (INFO[rline][0][25:1] == raddress[29:5] && INFO[rline][0][0]) begin      // Reading block 0
   
            roffset = 32*raddress[1:0]+128; // calculating word offset, shifting 
            rdata = DATA[rline][roffset +: 32];    // same thing as [rindex:(rindex-32)]
                        
            miss = 0;
            LRU[rline] = 1; end
                
        else if (INFO[rline][1][25:1] == raddress[29:5] && INFO[rline][1][0]) begin // Reading block 1
         
            roffset = 32*(raddress[1:0]+1); 
            rdata = DATA[rline][roffset +: 32]; 
            
            miss = 0;            
            LRU[rline] = 0; end  
                
        else begin
            waiting = 1;
            miss = 1; end                   
        
    end 
    
                                    

        
        

    
    
endmodule
