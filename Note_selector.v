`timescale 1ns / 1ps
module Note_selector(input[4:0] note,output reg[7:0] key);
    always @(note)
    case (note)
        5'd0:key = 8'b00000000;
        5'd1,5'd8, 5'd15:key = 8'b10000000;
        5'd2,5'd9, 5'd16:key = 8'b01000000;
        5'd3,5'd10,5'd17:key = 8'b00100000;
        5'd4,5'd11,5'd18:key = 8'b00010000;
        5'd5,5'd12,5'd19:key = 8'b00001000;
        5'd6,5'd13,5'd20:key = 8'b00000100;
        5'd7,5'd14,5'd21:key = 8'b00000010;
        default:key = 8'b00000000;
    endcase 
endmodule

