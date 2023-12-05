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


module L1(  input logic rst,
            
            input logic [31:0] raddress,    // CPU  (addr: 27b Tag, 3b indx, 2b word offset)
            output logic [31:0] rdata, 
            
            output logic hit,               // CPU & MAIN  
            
            input logic delivered,          // MAIN MEMORY
            input logic [127:0] blockin
                    
          );
          
    
    logic [2:0] rline;
    logic [7:0] roffset;
    assign rline = raddress[4:2];
    
       
            
    // ARRAY: 8 sets & 8 words per set (line).
    reg [255:0] DATA[7:0];                  // Values of addr
    reg [27:0] INFO[7:0][1:0];              // TAG (27b), Valid bit (per block)
    reg LRU [7:0];
    
    
    always_comb begin
        valid = 0;
        
        if (rst) begin
            for (int i = 0; i < 7; ++i) begin
                LRU[i] = '0;
                DATA[i] = '0;
                INFO[i][0] = '0; 
                INFO[i][1] = '0; end end
                
        else begin
        
            if (delivered) begin                                                        // Write block for PARAM
                roffset = 128*(~LRU[rline]) + 127;
                
                DATA[rline][roffset -: 128] = blockin;
                INFO[rline][LRU[rline]] = {raddress[31:5], 1'b1};
                LRU[rline] = ~LRU[rline]; end
            
            if (INFO[rline][0][27:1] == raddress[31:5] && INFO[rline][0][0]) begin      // Read from block 0  
                roffset = 32*raddress[1:0]+128;
                rdata = DATA[rline][roffset -: 32];                 
                
                hit = 1;
                LRU[rline] = 1; end
            else if (INFO[rline][1][27:1] == raddress[31:5] && INFO[rline][1][0]) begin // Read from block 1    
                roffset = 32*(raddress[1:0]+1); 
                rdata = DATA[rline][roffset -: 32]; 
                        
                hit = 1;
                LRU[rline] = 0; end 
            else
                rdata = 32'hFADED420; 
                                 
        end
    end
        

    
    
endmodule
