`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/02 19:52:19
// Design Name: 
// Module Name: buzzer
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


module Buzzer (
    input wire clk , // Clock signal
    input wire [17:0] freq,  // we need 21 notes, so the bits should be 21 at least to present 3 octaves
    output wire speaker // Buzzer output signal
);
    
    reg [17:0] counter ;
    reg pwm ;
    
    initial begin
    pwm =0;
    end
    
    always @ ( posedge clk ) begin
        if ( counter < freq ) begin
            counter <= counter + 1'b1;
            end 
        else begin
            pwm = ~pwm ;
            counter <= 0;
        end
    end

    assign speaker = pwm ; // Output a PWM signal to the buzzer
    
endmodule
