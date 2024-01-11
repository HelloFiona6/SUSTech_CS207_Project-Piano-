`timescale 1ns / 1ps
`include "parameters.v"
module Binary_to_Decimal(
    input [9:0] scores,
    output reg [23:0] character
    );
    `timescale 1ns / 1ps
    //the state
    parameter WAIT = 3'b000;
    parameter FREEPLAY = 3'b100;
    parameter AUTOPLAY = 3'b010;
    parameter STUDY = 3'b001;
    parameter ADJUSTMENT = 3'b011;
    parameter SELECT = 3'b111;
    parameter CHALLENGE = 3'b101;
    //the difficulty of the challenge state
    parameter EASY = 3'b100;
    parameter NORMAL = 3'b010;
    parameter HARD = 3'b001;
    parameter interval_easy = 60;
    parameter interval_normal = 45;
    parameter interval_hard = 30;
    parameter interval_study = 120;
    
    //the period of changing char
    parameter scan_period = 200000;
    parameter second = 100000000;
    parameter pause = 110000;
    
    //the chars
    parameter zero = 8'b00000000;
    parameter WAIT_ = 64'b10110110_11001110_11101110_00001010_10011110_00000000_00000000_00000000;
    parameter FREEPLAY_ = 64'b10001110_00001010_10011110_10011110_11001110_00011100_11101110_01110110;
    parameter RECORD_ = 64'b00001010_10011110_00011010_00111010_00001010_01111010_00000000_00000000;
    parameter AUTOPLAY_ = 64'b11101110_01111100_00011110_11111100_11001110_00011100_11101110_01110110;
    parameter STUDY_ = 64'b10110110_00011110_01111100_01111010_01110110_00000000_00000000_00000000;
    parameter CHA = 32'b10011100_01101110_11101110_00000000;
    parameter SELECT_ = 64'b10110110_10011110_00011100_10011110_10011100_00011110_00000000_00000000;
    parameter ADJUST_ = 64'b11101110_01111010_11110000_01111100_10110110_00011110_00000000_00000000;
    parameter TRACK = 48'b00011110_00001010_11101110_10011100_00011110_00000010;
    
    
    //7-seg display characters
    parameter SEP = 8'b00000010;
    parameter ZERO = 8'b11111100;
    parameter ONE =  8'b01100000;
    parameter TWO =  8'b11011010;
    parameter THREE =8'b11110010;
    parameter FOUR = 8'b01100110;
    parameter FIVE = 8'b10110110;
    parameter SIX =  8'b10111110;
    parameter SEVEN =8'b11100000;
    parameter EIGHT =8'b11111110;
    parameter NINE = 8'b11110110;
    parameter S = 8'b10110110;
    parameter A = 8'b11101110;
    parameter B = 8'b00111110;
    parameter C = 8'b10011100;
    parameter D = 8'b01111010;
    parameter E = 8'b10011110;
    //321start
    parameter ONE_ = 64'b00000000_00000000_00000000_01100000_00000000_00000000_00000000_00000000;
    parameter TWO_ = 64'b00000000_00000000_00000000_00000000_11011010_00000000_00000000_00000000;
    parameter THREE_ = 64'b00000000_00000000_00000000_00000000_00000000_11110010_00000000_00000000;
    parameter START = 64'b00000000_00000000_10110110_00011110_11101110_00001010_00011110_00000000;
    
    //users account
    parameter HOPE = 40'b01101110_11111100_11001110_10011110_00000000;
    parameter ALAN = 40'b11101110_00011100_11101110_00101010_00000000;
    parameter BOB = 40'b00111110_00111010_00111110_00000000_00000000;
    parameter PAT = 40'b11001110_11101110_00011110_00000000_00000000;
    parameter PETER = 40'b11001110_10011110_00011110_10011110_00001010;
    parameter ANNA =40'b11101110_00101010_00101010_11101110_00000000;
    parameter ALICE = 40'b11101110_00011100_01100000_10011100_10011110;
    parameter JOHN = 40'b11110000_11111100_00101110_00101010_00000000;
        
    //songsname
    parameter HB = 32'b01101110_00111110_00000000_00000000;
    parameter Jn = 32'b11110000_00101010_00000000_00000000;
    parameter CR = 32'b10011100_00001010_00000000_00000000;
    parameter TS = 32'b00011110_10110110_00000000_00000000;
    parameter TT = 32'b00011110_00011110_00000000_00000000;
    
    parameter CR_ = 16'b10011100_00001010;
    parameter HB_ = 16'b01101110_00111110;
    parameter Jn_ = 16'b11110000_00101010;
    parameter TS_ = 16'b00011110_10110110;
    parameter TT_ = 16'b00011110_00011110;
    parameter RD_ = 16'b00001010_01111010;
    
    
    
    //the frequency of the note
    parameter do_low = 191110;
    parameter re_low = 170259;
    parameter me_low = 151685;
    parameter fa_low = 143172;
    parameter so_low = 127554;
    parameter la_low = 113636;
    parameter si_low = 101239;
    parameter do = 93941;
    parameter re = 85136;
    parameter me = 75838;
    parameter fa = 71582;
    parameter so = 63776;
    parameter la = 56818;
    parameter si = 50618;
    parameter do_high = 47778;
    parameter re_high = 42567;
    parameter me_high = 37921;
    parameter fa_high = 36498;
    parameter so_high = 31888;
    parameter la_high = 28409;
    parameter si_high = 25309;
    
    // the basic param of music
    parameter beat = 40 * 400;
    parameter base_beat = 4*400;
    parameter min_beat = 12 * 400;
    parameter max_beat = 100 * 400;
    parameter gap =  7 * 400;
    parameter index_period_3 = 70 * 400;
    parameter index_period_2 = 80 * 400;
    parameter index_period_1 = 100 * 400;
    parameter index_period_0 = 45 * 400;
    parameter index_beat_3 =  60 * 400;
    parameter index_beat_2 =  70 * 400;
    parameter index_beat_1 =  80 * 400;
    parameter index_beat_3_4 =  30 * 400;
    parameter index_beat_2_4 =  20 * 400;
    parameter index_beat_1_4 =  10 * 400;
    parameter silence = 580000;
    parameter song_count = 3;
    
    //the music notebook
    parameter JiangNan = 2324'b00000000001111000000000100000000000001000000100010010010000000000000000000000001000000000000001111001000100100100010011001000100100100010001001001000011110000000000000000000000010011001001100011110001111000000000101000010100000110100011000001110000111000000000000000000000000011100000000001000000011110010000001000100100000001111000111000011110010000001000100100010000000000000000000000010000000000000011110010001001001000100110010010001000100100010010001001000000011110000000000000000000000010000000000000011110010001001001000100110010001001001000100010010010000111100000000000000001001100100110001111000111100000000000000001010000101000001101000110000011100000000000000000000000001110000000000100000001111000000000100000010001001000000011110001110000111100100000010001001000100000000000000000000000100000000000000111100100010010010001001100100100010001001000100100010010000000111100000000000000000000000100110010011001001100000000010100000000000011110001111001001100011010001111000000000011110001111001001100011110001111000000000011110001111001000000011110010001001000100000000010001001000000100010010001001000100100010010001001000100100010010001000000000100010010001001000100100010010001001000100000000000000000000000011010001100000111000011110010000000111100011100001110000111000000000000000000000000011010001111001000100000000010011000111100011100001101000000000000000000000000110100011110001101000000000011000001110000111100011100001110000111000000000000000000000000011010001111000000000100010010011000111100011100001101000000000000000000000000110100000000001100000111000011110010000000111100011100001110000111000000000000000000000000011010001111000000000100010010011000111100011100001101000110100000000000000000000000011010001100000000000011100001111000111000011100001110000000000000000000000000110100011110000000001000100100110001111000111000011010000000000000000100010010001001000000011110001110000110100010100000110000111000011110001111000111000011010001100000100100001010000000001000100000000001101000110000010110001000000110100011110010001001001100011110001110000110100010100000110001000100100000010001000111100011100001101000101000001100001110000111100011110001110000110100011000001001000010100000000010001000000000011010001100000101100010000001101000111100100010010011000111100011100001101000101000001100000000;
    parameter HappyBirthday = 182'b00011110010000000111100100010010010000000000000000001101000111000011110010001001001100011000001111000111100100000001100000110100011000001110000111000011110001100000110100001010000101;
    parameter MerryChristmas = 469'b0001111000111100011110001110001000000011010001100000110000100110001111001000000100010010000000000000011000001100000110100011100001111000111000000000001110000111100011110001111000110000000000001111000111100011100010000000110100011000001100000000000011010001111001000000100010010010001000100100010000000000110000011000000000000110000011100001111001000000100010010000001000000000000001101000000000000000001101000110100011100001111001000000011110001111000000000011000001100;
    parameter LittleStar = 336'b000000000010000001001000100100010100001010000101100010110000000000110000011010001101000110000011000001000000100000000000001001000101000010100001011000101100011000001100000000000010010001010000101000010110001011000110000011000000000000100000010010001001000101000010100001011000101100000000001100000110100011010001100000110000010000001000;
    parameter TwoTiger = 252'b000000000010000001100000100000000000001000000110000010000001000000101001011011101100010110111011000001000000101001011011101100010110111011000000000000110000010110001010000000000011000001011000101000010000001010000100100010000001000000101000010010001000;
    
    parameter JN_length = 332;
    parameter HB_length = 26;
    parameter MC_length = 67;
    parameter LS_length = 48;
    parameter TT_length = 36;
    
    //the mode of scale
    parameter high_key = 3'b100;
    parameter mid_key = 3'b010;
    parameter low_key = 3'b001;

    reg [3:0] ones;
    reg [3:0] tens;
    reg [1:0] huns;
    integer i;
    
    always @(scores) begin
        ones = 4'd0;
        tens = 4'd0;
        huns = 2'd0;
        
        for(i = 7; i >= 0; i = i - 1) begin//make binary into BCD codes
            if (ones >= 4'd5)    ones = ones + 4'd3;
            if (tens >= 4'd5)    tens = tens + 4'd3;
            if (huns >= 4'd5)    huns = huns + 4'd3;
            huns = {huns[0],tens[3]};
            tens = {tens[2:0],ones[3]};
            ones = {ones[2:0],scores[i]};
        end
    end    
    
    always@(huns)
        case(huns)
            4'b0000:character[23:16] = ZERO;
            4'b0001:character[23:16] = ONE;
            4'b0010:character[23:16] = TWO;
            4'b0011:character[23:16] = THREE;
            4'b0100:character[23:16] = FOUR;
            4'b0101:character[23:16] = FIVE;
            4'b0110:character[23:16] = SIX;
            4'b0111:character[23:16] = SEVEN;
            4'b1000:character[23:16] = EIGHT;
            4'b1001:character[23:16] = NINE;
        endcase
        
    always@(ones)
        case(ones)
            4'b0000:character[7:0] = ZERO;
            4'b0001:character[7:0] = ONE;
            4'b0010:character[7:0] = TWO;
            4'b0011:character[7:0] = THREE;
            4'b0100:character[7:0] = FOUR;
            4'b0101:character[7:0] = FIVE;
            4'b0110:character[7:0] = SIX;
            4'b0111:character[7:0] = SEVEN;
            4'b1000:character[7:0] = EIGHT;
            4'b1001:character[7:0] = NINE;
         endcase    
                
      always@(tens)
          case(tens)
            4'b0000:character[15:8] = ZERO;
            4'b0001:character[15:8] = ONE;
            4'b0010:character[15:8] = TWO;
            4'b0011:character[15:8] = THREE;
            4'b0100:character[15:8] = FOUR;
            4'b0101:character[15:8] = FIVE;
            4'b0110:character[15:8] = SIX;
            4'b0111:character[15:8] = SEVEN;
            4'b1000:character[15:8] = EIGHT;
            4'b1001:character[15:8] = NINE;
           endcase            
                
    
endmodule
