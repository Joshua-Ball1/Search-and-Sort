//Basic 7 Segment display code for Basys 3. Can be implemented on pretty much any 7 segment display on a device.

`timescale 1ns / 1ps

module sevensegment(
 input CLK100MHZ, reset,
 input [15:0] inBits,//in0, in1, in2, in3,  //the 4 inputs for each display
 output a, b, c, d, e, f, g, dp, //the individual LED output for the seven segment along with the digital point
 output [3:0] an   // the 4 bit enable signal
 );
 
localparam N = 18;
 
reg [N-1:0]count; //the 18 bit counter which allows us to multiplex at 1000Hz
 
always @ (posedge CLK100MHZ or posedge reset)
 begin
  if (reset)
   count <= 0;
  else
   count <= count + 1;
 end
 
reg [6:0]sseg; //the 7 bit register to hold the data to output
reg [3:0]an_temp; //register for the 4 bit enable
 
always @ (*)
 begin
  case(count[N-1:N-2]) //using only the 2 MSB's of the counter 
    
   2'b00 :  //When the 2 MSB's are 00 enable the fourth display
    begin
     sseg = inBits[3:0];
     an_temp = 4'b1110;
    end
    
   2'b01:  //When the 2 MSB's are 01 enable the third display
    begin
     sseg = inBits[7:4];
     an_temp = 4'b1101;
    end
    
   2'b10:  //When the 2 MSB's are 10 enable the second display
    begin
     sseg = inBits[11:8];
     an_temp = 4'b1011;
    end
     
   2'b11:  //When the 2 MSB's are 11 enable the first display
    begin
     sseg = inBits[15:12];
     an_temp = 4'b0111;
    end
  endcase
 end
assign an = an_temp;
 
 
reg [6:0] sseg_temp; // 7 bit register to hold the binary value of each input given
 
always @ (*)
 begin
  case(sseg)
                       //gfedcba, logic low
   4'd0 : sseg_temp = 7'b1000000; //to display 0
   4'd1 : sseg_temp = 7'b1111001; //to display 1
   4'd2 : sseg_temp = 7'b0100100; //to display 2
   4'd3 : sseg_temp = 7'b0110000; //to display 3
   4'd4 : sseg_temp = 7'b0011001; //to display 4
   4'd5 : sseg_temp = 7'b0010010; //to display 5
   4'd6 : sseg_temp = 7'b0000010; //to display 6
   4'd7 : sseg_temp = 7'b1111000; //to display 7
   4'd8 : sseg_temp = 7'b0000000; //to display 8
   4'd9 : sseg_temp = 7'b0010000; //to display 9
   4'd10 : sseg_temp = 7'b0001000; //to display A
   4'd11 : sseg_temp = 7'b0000011; //to display B
   4'd12 : sseg_temp = 7'b1000110; //to display C
   4'd13 : sseg_temp = 7'b0100001; //to display D
   4'd14 : sseg_temp = 7'b0000110; //to display E
   4'd15 : sseg_temp = 7'b0001110; //to display F
   default : sseg_temp = 7'b0111111; //dash
  endcase
 end
assign {g, f, e, d, c, b, a} = sseg_temp; //concatenate the outputs to the register, this is just a more neat way of doing this.

 
assign dp = 1'b1; //since the decimal point is not needed, all 4 of them are turned off
 
 
endmodule
