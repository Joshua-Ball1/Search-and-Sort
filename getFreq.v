`timescale 1ns / 1ps


module getFreq(
input CLK100MHZ,
input signal,
output reg [19:0] frequency = 0 // 0 -> 1,048,575
);
parameter countTo = 100000000; // was 100000000, was 3125000, was 1562500, now 781250
parameter scalar = 1000; // was 1, was 32, was 64, now 128


reg [26:0] clockCounter = 0; 
reg [19:0] pulses = 0; 

reg pastSigState = 0;
reg done = 0;




    // Triggers each + clock edge
    always@(posedge CLK100MHZ) begin
        if (done) begin
            pulses <= 0;
            clockCounter <=0;
            done <= 0;
        end     

        else if(clockCounter < countTo) begin  

            clockCounter <= clockCounter +1; 
         
            if(signal && ~pastSigState) begin
                pulses <= pulses + 1; 
                pastSigState <= 1; 
            end
            else if(~signal) begin 
                pastSigState <= 0; 
            end        
        end
        else begin
            clockCounter <= 0;        
            frequency <= (pulses*scalar);   // calculate the frequency from the number of pulses * scaling factor
            done <= 1;
        end
    end
endmodule
