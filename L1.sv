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
            
            input logic read,               // CPU READING
            input logic [31:0] raddress,    // 27b Tag, 3b indx, 2b word offset
            output logic [31:0] rdata,      // Output one word
            output logic hit,               // MAIN MEMORY
            output logic memValid1,
            
            input logic delivered,
            input logic [127:0] blockin
          );
          
    
    logic [2:0] rline;
    logic [7:0] roffset;
    assign rline = raddress[4:2];
    
    logic waiting;
       
            
    // ARRAY: 8 sets & 8 words per set (line).
    reg [255:0] DATA[7:0];          // Values of addr
    //reg [26:0] INFO[7:0][1:0];      // TAG (25b), Dirty bit, Valid bit (per block)
    reg [27:0] INFO[7:0][1:0];      // TAG (27b), Valid bit (per block)
    reg LRU [7:0];
    
    always_ff @(posedge clk)
    begin
        hit <= 1;                   // Setting cache control settings to 0
        memValid1 <= 0;
        
        if (rst) begin
            for (int i = 0; i < 7; ++i) begin
                waiting <= 0;
                LRU[i] <= '0;
                DATA[i] <= '0;
                INFO[i][0] <= '0; 
                INFO[i][1] <= '0; end end
                
        else begin
        
            if (waiting && delivered) begin
                waiting <= 0;
                roffset <= 128*(~LRU[rline]) + 127;
                
                DATA[rline][roffset -: 128] <= blockin;
                INFO[rline][LRU[rline]] <= {raddress[31:5], 1'b1};
                LRU[rline] <= ~LRU[rline]; end
            
            if (read) begin
                hit <= 0; 
                if (INFO[rline][0][27:1] == raddress[31:5] && INFO[rline][0][0]) begin
                    hit <= 1;
                        
                    //rindex0 <= 32*(raddress[1:0]+1)+127;                // Word offset
                    roffset <= 32*raddress[1:0]+128;
                    rdata <= DATA[rline][roffset -: 32];        // same thing as [rindex:(rindex-32)]
                        
                    LRU[rline] <= 1; 
                    memValid1 <= 1; end
                else if (INFO[rline][1][27:1] == raddress[31:5] && INFO[rline][1][0]) begin
                    hit <= 1;
                        
                    //rindex0 <= 32*(raddress[1:0]+1)-1;
                    roffset <= 32*(raddress[1:0]+1); 
                    rdata <= DATA[rline][roffset -: 32]; 
                        
                    LRU[rline] <= 0; 
                    memValid1 <= 1; end  
                else
                    waiting <= 1;                     
            end
            
            
            
            
            
            
            
//    logic [3:0] wline;
//    logic [7:0] windex;
    
    
//    assign wline = waddress[3:2];
//            if (write) begin
//                if (!INFO[wline][0][0]) begin                           // Block 0 empty
//                    windex <= 32*wline+128;
//                    DATA[wline][windex -: 32] <= wdata;
//                    INFO[wline][0] <= {waddress[26:2],2'b11}; 
//                end
//                else if (!INFO[wline][1][0]) begin                      // Block 1 empty
//                    windex <= 32*wline;
//                    DATA[wline][windex -: 32] <= wdata;
//                    INFO[wline][1] <= {waddress[26:2],2'b11}; 
//                end
//                else begin                                               // Making space
//                    writeback <= 1;
//                    if (LRU[wline]) 
//                        blockout <= DATA[wline][255:128];
//                    else
//                        blockout <= DATA[wline][255:128];
                        
//                end
//            end
            
            
        end 
    end
                                    

        
        

    
    
endmodule
