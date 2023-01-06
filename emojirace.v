//////////////////////////////////////////////////////////////////////
//DSD FINAL Project: Emoji Race
//Robb Smith, Alonzo Laureno, Robert Lopez, Isaac Pena, Harsh Patel

`timescale 1ns / 1ps

module emoji_race(clk, U, D, L, R,C, vga_vsync, vga_hsync, red, green, blue, SSEG_CA, SSEG_AN);
    input clk;
    input U,L,D,R,C; //up, down, left, right
    output vga_vsync, vga_hsync;
    output reg [3:0] red,green,blue; //4 bits of RGB color
    output [7:0] SSEG_CA;
    output [7:0] SSEG_AN;

    wire inDisplay;
    wire [9:0] x; //800 = 640 + 96 + 16 + 48
    wire [8:0] y; //525  = 480 + 2

    //sprite display variables, addr, col, data, rom_bit
    reg p1_sq, p1, p2_sq, p2, skull1_sq, skull1, skull2_sq, skull2, skull3_sq, skull3, devil1_sq, devil1, devil2_sq, 
        devil2, devil3_sq, devil3, galaga1_sq, galaga1, galaga2_sq, galaga2, galaga3_sq, galaga3, angry1_sq, angry1, 
        angry2_sq, angry2, sus1_sq, sus1, sus2_sq, sus2, sus3_sq, sus3;
    wire [5:0] p1_addr, p1_col, p2_addr, p2_col, skull1_addr, skull1_col, skull2_addr, skull2_col, skull3_addr, 
        skull3_col, devil1_addr, devil1_col, devil2_addr, devil2_col, devil3_addr, devil3_col, 
        galaga1_addr, galaga1_col, galaga2_addr, galaga2_col, galaga3_addr, galaga3_col, angry1_addr, angry1_col, 
        angry2_addr, angry2_col, sus1_addr, sus1_col, sus2_addr, sus2_col, sus3_addr, sus3_col;
    reg [20:0] p1_data, p2_data, devil1_data, devil2_data, devil3_data, skull1_data, skull2_data, skull3_data, galaga1_data, galaga2_data, 
        galaga3_data, angry1_data, angry2_data, sus1_data, sus2_data, sus3_data;
    wire p1_rom_bit, p2_rom_bit, devil1_rom_bit, devil2_rom_bit, devil3_rom_bit, skull1_rom_bit, skull2_rom_bit, skull3_rom_bit, galaga1_rom_bit, 
        galaga2_rom_bit, galaga3_rom_bit, angry1_rom_bit, angry2_rom_bit, sus1_rom_bit, sus2_rom_bit, sus3_rom_bit;
    
    //variable to switch player control
    reg player_sel=0;
    wire rightBorder, leftBorder, topBorder, bottomBorder;



    //constants to make code easiser to read and write
    integer spritesize;
    parameter integer row1_y = 80;
    parameter integer row2_y = 160;
    parameter integer row3_y = 240;
    parameter integer row4_y = 320;
    parameter integer player_starty = 440;
    parameter integer player_speed = 20;
    parameter integer enemy_speed = 5;
    parameter integer enemy_sr = 600;
    parameter integer screen_r = 620;
    
    //finish line
    reg finish;
    parameter integer vert_pix = 20;
    parameter integer finish_thick = 40;
    
    reg [4:0] p1_score=0;
    reg [4:0] p2_score=0;
    
    reg p1_box, p2_box;
    reg [6:0] p1_inc=0;
    reg [6:0] p2_inc =0;

    // generate a 25 MHz pixel strobe
    reg [15:0] cnt;
    reg pix_stb;

    always @(posedge clk)
    begin
        {pix_stb, cnt} <= cnt + 16'h4000;  // divide by 4: (2^16)/4 = 0x4000
    end

    //vga display module instantiation 
    vga640x480 display (
        .i_clk(clk),
        .i_pix_stb(pix_stb),
        .o_hs(vga_hsync), 
        .o_vs(vga_vsync),
        .o_x(x), 
        .o_y(y),
        .animate(inDisplay)
    );

    //intialize base sprit locations
    reg [9:0] p1_x = 120;
    reg [9:0] p2_x = 480;
    reg [8:0] p1_y = player_starty;
    reg [8:0] p2_y = player_starty;
    
    reg [9:0] skull1_x = 236;

    reg [9:0] skull2_x = 460;


    reg [9:0] devil1_x = 492;

    reg [9:0] devil2_x = 140;

    reg [9:0] galaga1_x = 460;

    reg [9:0] galaga2_x = 108;

    reg [9:0] angry1_x = 140;

    
    reg [9:0] angry2_x = 364;
   
    reg [9:0] sus1_x = 300;
    
    reg [9:0] sus2_x = 300;
    reg [8:0] sus2_y = row3_y;
    
    //Row 4
    reg [9:0] skull3_x = 108;
    reg [9:0] galaga3_x = 236;
    reg [9:0] devil3_x = 364;
    reg [9:0] sus3_x = 492;

    //sprite instantiations (bare with me here...)

    //p1
    always @*
    case(p1_addr)
        5'b00000: p1_data = 20'b00000011111111000000;
        5'b00001: p1_data = 20'b00011111111111111000;
        5'b00010: p1_data = 20'b00011111111111111000;
        5'b00011: p1_data = 20'b01111111111111111110;
        5'b00100: p1_data = 20'b01111111111111111110;
        5'b00101: p1_data = 20'b01111000111100011110;
        5'b00110: p1_data = 20'b11111000111100011111;
        5'b00111: p1_data = 20'b11111000111100011111;
        5'b01000: p1_data = 20'b11111111111111111111;
        5'b01001: p1_data = 20'b11111111111111111111;
        5'b01010: p1_data = 20'b11111111111111111111;
        5'b01011: p1_data = 20'b11111111111111111111;
        5'b01100: p1_data = 20'b11111101111111011111;
        5'b01101: p1_data = 20'b01111100111110011111;
        5'b01110: p1_data = 20'b01111111000001111110;
        5'b01111: p1_data = 20'b01111111111111111110;
        5'b10000: p1_data = 20'b01111111111111111110;
        5'b10001: p1_data = 20'b00011111111111111000;
        5'b10010: p1_data = 20'b00011111111111111000;
        5'b10011: p1_data = 20'b00000011111111000000;
    endcase
    
    assign p1_addr = y[5:0] - p1_y;
    assign p1_col= x[5:0] - p1_x;
    assign p1_rom_bit = p1_data[p1_col];

    //p2
    always @*
        case(p2_addr)
        5'b00000: p2_data = 20'b00000011111111000000;
        5'b00001: p2_data = 20'b00011111111111111000;
        5'b00010: p2_data = 20'b00011111111111111000;
        5'b00011: p2_data = 20'b01111111111111111110;
        5'b00100: p2_data = 20'b01111111111111111110;
        5'b00101: p2_data = 20'b01111000111100011110;
        5'b00110: p2_data = 20'b11111000111100011111;
        5'b00111: p2_data = 20'b11111000111100011111;
        5'b01000: p2_data = 20'b11111111111111111111;
        5'b01001: p2_data = 20'b11111111111111111111;
        5'b01010: p2_data = 20'b11111111111111111111;
        5'b01011: p2_data = 20'b11111111111111111111;
        5'b01100: p2_data = 20'b11111111000000111111;
        5'b01101: p2_data = 20'b01111100111111001111;
        5'b01110: p2_data = 20'b01111101111111101110;
        5'b01111: p2_data = 20'b01111111111111111110;
        5'b10000: p2_data = 20'b01111111111111111110;
        5'b10001: p2_data = 20'b00011111111111111000;
        5'b10010: p2_data = 20'b00011111111111111000;
        5'b10011: p2_data = 20'b00000011111111000000;
        endcase
        
    assign p2_addr = y[5:0] - p2_y;
    assign p2_col = x[5:0] - p2_x;
    assign p2_rom_bit = p2_data[p2_col];

    //skull1
    always @* 
    case(skull1_addr)
        5'b00000: skull1_data = 20'b00000000000000000000;
        5'b00001: skull1_data = 20'b00000000000000000000;
        5'b00010: skull1_data = 20'b00111111111111111100;
        5'b00011: skull1_data = 20'b01111111111111111110;
        5'b00100: skull1_data = 20'b01111111111111111110;
        5'b00101: skull1_data = 20'b11111111111111111111;
        5'b00110: skull1_data = 20'b11111111111111111111;
        5'b00111: skull1_data = 20'b11111000111100011111;
        5'b01000: skull1_data = 20'b11111000111100011111;
        5'b01001: skull1_data = 20'b11111000111100011111;
        5'b01010: skull1_data = 20'b11111000111100011111;
        5'b01011: skull1_data = 20'b11111111111111111111;
        5'b01100: skull1_data = 20'b11111111100111111111;
        5'b01101: skull1_data = 20'b11111111000011111111;
        5'b01110: skull1_data = 20'b01111111111111111110;
        5'b01111: skull1_data = 20'b00011111111111111000;
        5'b10000: skull1_data = 20'b00001111111111110000;
        5'b10001: skull1_data = 20'b00001110011001110000;
        5'b10010: skull1_data = 20'b00000110011001100000;
        5'b10011: skull1_data = 20'b00000000000000000000;
    endcase

    assign skull1_addr = y[5:0] - row2_y;
    assign skull1_col = x[5:0] - skull1_x;
    assign skull1_rom_bit = skull1_data[skull1_col];

    //skull2
     //skull emoji gray 2
    always @* 
    case(skull2_addr)
        5'b00000: skull2_data = 20'b00000000000000000000;
        5'b00001: skull2_data = 20'b00000000000000000000;
        5'b00010: skull2_data = 20'b00111111111111111100;
        5'b00011: skull2_data = 20'b01111111111111111110;
        5'b00100: skull2_data = 20'b01111111111111111110;
        5'b00101: skull2_data = 20'b11111111111111111111;
        5'b00110: skull2_data = 20'b11111111111111111111;
        5'b00111: skull2_data = 20'b11111000111100011111;
        5'b01000: skull2_data = 20'b11111000111100011111;
        5'b01001: skull2_data = 20'b11111000111100011111;
        5'b01010: skull2_data = 20'b11111000111100011111;
        5'b01011: skull2_data = 20'b11111111111111111111;
        5'b01100: skull2_data = 20'b11111111100111111111;
        5'b01101: skull2_data = 20'b11111111000011111111;
        5'b01110: skull2_data = 20'b01111111111111111110;
        5'b01111: skull2_data = 20'b00011111111111111000;
        5'b10000: skull2_data = 20'b00001111111111110000;
        5'b10001: skull2_data = 20'b00001110011001110000;
        5'b10010: skull2_data = 20'b00000110011001100000;
        5'b10011: skull2_data = 20'b00000000000000000000;
    endcase

    assign skull2_addr = y[5:0] - row3_y;
    assign skull2_col = x[5:0] - skull2_x;
    assign skull2_rom_bit = skull2_data[skull2_col];
    
    //skull emoji gray 3
always @* 
case(skull3_addr)

    5'b00000: skull3_data = 20'b00000000000000000000;
    5'b00001: skull3_data = 20'b00000000000000000000;
    5'b00010: skull3_data = 20'b00111111111111111100;
    5'b00011: skull3_data = 20'b01111111111111111110;
    5'b00100: skull3_data = 20'b01111111111111111110;
    5'b00101: skull3_data = 20'b11111111111111111111;
    5'b00110: skull3_data = 20'b11111111111111111111;
    5'b00111: skull3_data = 20'b11111000111100011111;
    5'b01000: skull3_data = 20'b11111000111100011111;
    5'b01001: skull3_data = 20'b11111000111100011111;
    5'b01010: skull3_data = 20'b11111000111100011111;
    5'b01011: skull3_data = 20'b11111111111111111111;
    5'b01100: skull3_data = 20'b11111111100111111111;
    5'b01101: skull3_data = 20'b11111111000011111111;
    5'b01110: skull3_data = 20'b01111111111111111110;
    5'b01111: skull3_data = 20'b00011111111111111000;
    5'b10000: skull3_data = 20'b00001111111111110000;
    5'b10001: skull3_data = 20'b00001110011001110000;
    5'b10010: skull3_data = 20'b00000110011001100000;
    5'b10011: skull3_data = 20'b00000000000000000000;
endcase

assign skull3_addr = y[5:0] - row4_y;
assign skull3_col = x[5:0] - skull3_x;
assign skull3_rom_bit = skull3_data[skull3_col];

//devil1     
always @* 
    case(devil1_addr)
        5'b00000: devil1_data = 20'b01110000000000001110;
        5'b00001: devil1_data = 20'b01111000000000011110;
        5'b00010: devil1_data = 20'b01111100000000111110;
        5'b00011: devil1_data = 20'b01111100000000111110;
        5'b00100: devil1_data = 20'b00111111111111111100;
        5'b00101: devil1_data = 20'b01111111111111111110;
        5'b00110: devil1_data = 20'b01111111111111111110;
        5'b00111: devil1_data = 20'b11111111111111111111;
        5'b01000: devil1_data = 20'b11111011111111011111;
        5'b01001: devil1_data = 20'b11111001111110011111;
        5'b01010: devil1_data = 20'b11111000111100011111;
        5'b01011: devil1_data = 20'b11111111111111111111;
        5'b01100: devil1_data = 20'b11111111111111111111;
        5'b01101: devil1_data = 20'b11111111111111111111;
        5'b01110: devil1_data = 20'b11110011111111001111;
        5'b01111: devil1_data = 20'b11111100000000111111;
        5'b10000: devil1_data = 20'b01111111111111111110;
        5'b10001: devil1_data = 20'b01111111111111111110;
        5'b10010: devil1_data = 20'b00111111111111111100;
        5'b10011: devil1_data = 20'b00000000000000000000;
    endcase

    assign devil1_addr = y[5:0] - row2_y;
    assign devil1_col = x[5:0] - devil1_x;
    assign devil1_rom_bit = devil1_data[devil1_col];

// devil2
always @* 
    case(devil2_addr)
    
        5'b00000: devil2_data = 20'b01110000000000001110;
        5'b00001: devil2_data = 20'b01111000000000011110;
        5'b00010: devil2_data = 20'b01111100000000111110;
        5'b00011: devil2_data = 20'b01111100000000111110;
        5'b00100: devil2_data = 20'b00111111111111111100;
        5'b00101: devil2_data = 20'b01111111111111111110;
        5'b00110: devil2_data = 20'b01111111111111111110;
        5'b00111: devil2_data = 20'b11111111111111111111;
        5'b01000: devil2_data = 20'b11111011111111011111;
        5'b01001: devil2_data = 20'b11111001111110011111;
        5'b01010: devil2_data = 20'b11111000111100011111;
        5'b01011: devil2_data = 20'b11111111111111111111;
        5'b01100: devil2_data = 20'b11111111111111111111;
        5'b01101: devil2_data = 20'b11111111111111111111;
        5'b01110: devil2_data = 20'b11110011111111001111;
        5'b01111: devil2_data = 20'b11111100000000111111;
        5'b10000: devil2_data = 20'b01111111111111111110;
        5'b10001: devil2_data = 20'b01111111111111111110;
        5'b10010: devil2_data = 20'b00111111111111111100;
        5'b10011: devil2_data = 20'b00000000000000000000;
    endcase

    assign devil2_addr = y[5:0] - row3_y;
    assign devil2_col = x[5:0] - devil2_x;
    assign devil2_rom_bit = devil2_data[devil2_col];
    
    // devil face
always @* 
    case(devil3_addr)
    
        5'b00000: devil3_data = 20'b01110000000000001110;
        5'b00001: devil3_data = 20'b01111000000000011110;
        5'b00010: devil3_data = 20'b01111100000000111110;
        5'b00011: devil3_data = 20'b01111100000000111110;
        5'b00100: devil3_data = 20'b00111111111111111100;
        5'b00101: devil3_data = 20'b01111111111111111110;
        5'b00110: devil3_data = 20'b01111111111111111110;
        5'b00111: devil3_data = 20'b11111111111111111111;
        5'b01000: devil3_data = 20'b11111011111111011111;
        5'b01001: devil3_data = 20'b11111001111110011111;
        5'b01010: devil3_data = 20'b11111000111100011111;
        5'b01011: devil3_data = 20'b11111111111111111111;
        5'b01100: devil3_data = 20'b11111111111111111111;
        5'b01101: devil3_data = 20'b11111111111111111111;
        5'b01110: devil3_data = 20'b11110011111111001111;
        5'b01111: devil3_data = 20'b11111100000000111111;
        5'b10000: devil3_data = 20'b01111111111111111110;
        5'b10001: devil3_data = 20'b01111111111111111110;
        5'b10010: devil3_data = 20'b00111111111111111100;
        5'b10011: devil3_data = 20'b00000000000000000000;
    endcase

    assign devil3_addr = y[5:0] - row4_y;
    assign devil3_col = x[5:0] - devil3_x;
    assign devil3_rom_bit = devil3_data[devil3_col];

//galaga1
always @* 
    case(galaga1_addr)
        5'b00000: galaga1_data = 20'b00000000000000000000;
        5'b00001: galaga1_data = 20'b00000000000000000000;
        5'b00010: galaga1_data = 20'b00000000000000000000;
        5'b00011: galaga1_data = 20'b00000010000001000000;
        5'b00100: galaga1_data = 20'b10000010000001000001;
        5'b00101: galaga1_data = 20'b10000111111111100001;
        5'b00110: galaga1_data = 20'b10001111111111110001;
        5'b00111: galaga1_data = 20'b10011111111111111001;
        5'b01000: galaga1_data = 20'b10111111111111111101;
        5'b01001: galaga1_data = 20'b10111100111100111101;
        5'b01010: galaga1_data = 20'b10111100111100111101;
        5'b01011: galaga1_data = 20'b10111100111100111101;
        5'b01100: galaga1_data = 20'b10111100111100111101;
        5'b01101: galaga1_data = 20'b00111111111111111100;
        5'b01110: galaga1_data = 20'b00111111111111111100;
        5'b01111: galaga1_data = 20'b00011111111111111000;
        5'b10000: galaga1_data = 20'b00001111111111110000;
        5'b10001: galaga1_data = 20'b00000110000001100000;
        5'b10010: galaga1_data = 20'b00000110000001100000;
        5'b10011: galaga1_data = 20'b00000000000000000000;
endcase

assign galaga1_addr = y[5:0] - row1_y;
assign galaga1_col = x[5:0] - galaga1_x;
assign galaga1_rom_bit = galaga1_data[galaga1_col];

//galaga green
always @* 
    case(galaga2_addr)
        5'b00000: galaga2_data = 20'b00000000000000000000;
        5'b00001: galaga2_data = 20'b00000000000000000000;
        5'b00010: galaga2_data = 20'b00000000000000000000;
        5'b00011: galaga2_data = 20'b00000010000001000000;
        5'b00100: galaga2_data = 20'b10000010000001000001;
        5'b00101: galaga2_data = 20'b10000111111111100001;
        5'b00110: galaga2_data = 20'b10001111111111110001;
        5'b00111: galaga2_data = 20'b10011111111111111001;
        5'b01000: galaga2_data = 20'b10111111111111111101;
        5'b01001: galaga2_data = 20'b10111100111100111101;
        5'b01010: galaga2_data = 20'b10111100111100111101;
        5'b01011: galaga2_data = 20'b10111100111100111101;
        5'b01100: galaga2_data = 20'b10111100111100111101;
        5'b01101: galaga2_data = 20'b00111111111111111100;
        5'b01110: galaga2_data = 20'b00111111111111111100;
        5'b01111: galaga2_data = 20'b00011111111111111000;
        5'b10000: galaga2_data = 20'b00001111111111110000;
        5'b10001: galaga2_data = 20'b00000110000001100000;
        5'b10010: galaga2_data = 20'b00000110000001100000;
        5'b10011: galaga2_data = 20'b00000000000000000000;
endcase

assign galaga2_addr = y[5:0] - row2_y;
assign galaga2_col = x[5:0] - galaga2_x;
assign galaga2_rom_bit = galaga2_data[galaga2_col];

//galaga green
always @* 
case(galaga3_addr)

    5'b00000: galaga3_data = 20'b00000000000000000000;
    5'b00001: galaga3_data = 20'b00000000000000000000;
    5'b00010: galaga3_data = 20'b00000000000000000000;
    5'b00011: galaga3_data = 20'b00000010000001000000;
    5'b00100: galaga3_data = 20'b10000010000001000001;
    5'b00101: galaga3_data = 20'b10000111111111100001;
    5'b00110: galaga3_data = 20'b10001111111111110001;
    5'b00111: galaga3_data = 20'b10011111111111111001;
    5'b01000: galaga3_data = 20'b10111111111111111101;
    5'b01001: galaga3_data = 20'b10111100111100111101;
    5'b01010: galaga3_data = 20'b10111100111100111101;
    5'b01011: galaga3_data = 20'b10111100111100111101;
    5'b01100: galaga3_data = 20'b10111100111100111101;
    5'b01101: galaga3_data = 20'b00111111111111111100;
    5'b01110: galaga3_data = 20'b00111111111111111100;
    5'b01111: galaga3_data = 20'b00011111111111111000;
    5'b10000: galaga3_data = 20'b00001111111111110000;
    5'b10001: galaga3_data = 20'b00000110000001100000;
    5'b10010: galaga3_data = 20'b00000110000001100000;
    5'b10011: galaga3_data = 20'b00000000000000000000;
endcase

assign galaga3_addr = y[5:0] - row4_y;
assign galaga3_col = x[5:0] - galaga3_x;
assign galaga3_rom_bit = galaga3_data[galaga3_col];

// angry face red
always @* 
    case(angry1_addr)
        5'b00000: angry1_data = 20'b00001111111111110000;
        5'b00001: angry1_data = 20'b00111111111111111100;
        5'b00010: angry1_data = 20'b00111111111111111100;
        5'b00011: angry1_data = 20'b01111111111111111110;
        5'b00100: angry1_data = 20'b11111111111111111111;
        5'b00101: angry1_data = 20'b11111111111111111111;
        5'b00110: angry1_data = 20'b11111101111110111111;
        5'b00111: angry1_data = 20'b11111101111110111111;
        5'b01000: angry1_data = 20'b11111100111100111111;
        5'b01001: angry1_data = 20'b11111111111111111111;
        5'b01010: angry1_data = 20'b11111111111111111111;
        5'b01011: angry1_data = 20'b11111111111111111111;
        5'b01100: angry1_data = 20'b11111111111111111111;
        5'b01101: angry1_data = 20'b11111100000000111111;
        5'b01110: angry1_data = 20'b11111001111110011111;
        5'b01111: angry1_data = 20'b01111011111111011110;
        5'b10000: angry1_data = 20'b01111111111111111110;
        5'b10001: angry1_data = 20'b00111111111111111100;
        5'b10010: angry1_data = 20'b00011111111111111000;
        5'b10011: angry1_data = 20'b00000000000000000000;
endcase

assign angry1_addr = y[5:0] - row1_y;
assign angry1_col = x[5:0] - angry1_x; 
assign angry1_rom_bit = angry1_data[angry1_col];

// angry face red
always @* 
    case(angry2_addr)
        5'b00000: angry2_data = 20'b00001111111111110000;
        5'b00001: angry2_data = 20'b00111111111111111100;
        5'b00010: angry2_data = 20'b00111111111111111100;
        5'b00011: angry2_data = 20'b01111111111111111110;
        5'b00100: angry2_data = 20'b11111111111111111111;
        5'b00101: angry2_data = 20'b11111111111111111111;
        5'b00110: angry2_data = 20'b11111101111110111111;
        5'b00111: angry2_data = 20'b11111101111110111111;
        5'b01000: angry2_data = 20'b11111100111100111111;
        5'b01001: angry2_data = 20'b11111111111111111111;
        5'b01010: angry2_data = 20'b11111111111111111111;
        5'b01011: angry2_data = 20'b11111111111111111111;
        5'b01100: angry2_data = 20'b11111111111111111111;
        5'b01101: angry2_data = 20'b11111100000000111111;
        5'b01110: angry2_data = 20'b11111001111110011111;
        5'b01111: angry2_data = 20'b01111011111111011110;
        5'b10000: angry2_data = 20'b01111111111111111110;
        5'b10001: angry2_data = 20'b00111111111111111100;
        5'b10010: angry2_data = 20'b00011111111111111000;
        5'b10011: angry2_data = 20'b00000000000000000000;
endcase

assign angry2_addr = y[5:0] - row2_y;
assign angry2_col = x[5:0] - angry2_x;
assign angry2_rom_bit = angry2_data[angry2_col];

// blue sus face
always @* 
    case(sus1_addr)
        5'b00000: sus1_data = 20'b00011111111111111000;
        5'b00001: sus1_data = 20'b00111111111000011100;
        5'b00010: sus1_data = 20'b00111111111011011100;
        5'b00011: sus1_data = 20'b01111000111111011110;
        5'b00100: sus1_data = 20'b11110011111111001111;
        5'b00101: sus1_data = 20'b11111110111101111111;
        5'b00110: sus1_data = 20'b11111100111100111111;
        5'b00111: sus1_data = 20'b11111100111100111111;
        5'b01000: sus1_data = 20'b11111111111111111111;
        5'b01001: sus1_data = 20'b11111111111111111111;
        5'b01010: sus1_data = 20'b11111111111111111111;
        5'b01011: sus1_data = 20'b11111111111111111111;
        5'b01100: sus1_data = 20'b11111111111111111111;
        5'b01101: sus1_data = 20'b11111000000000011111;
        5'b01110: sus1_data = 20'b01111111111111111110;
        5'b01111: sus1_data = 20'b01111111111111111110;
        5'b10000: sus1_data = 20'b00111111111111111100;
        5'b10001: sus1_data = 20'b00011111111111111000;
        5'b10010: sus1_data = 20'b00001111111111110000;
        5'b10011: sus1_data = 20'b00000000000000000000;
    endcase

assign sus1_addr = y[5:0] - row1_y;
assign sus1_col = x[5:0] - sus1_x;
assign sus1_rom_bit = sus1_data[sus1_col];


// blue sus face
always @* 
    case(sus2_addr)
        5'b00000: sus2_data = 20'b00011111111111111000;
        5'b00001: sus2_data = 20'b00111111111000011100;
        5'b00010: sus2_data = 20'b00111111111011011100;
        5'b00011: sus2_data = 20'b01111000111111011110;
        5'b00100: sus2_data = 20'b11110011111111001111;
        5'b00101: sus2_data = 20'b11111110111101111111;
        5'b00110: sus2_data = 20'b11111100111100111111;
        5'b00111: sus2_data = 20'b11111100111100111111;
        5'b01000: sus2_data = 20'b11111111111111111111;
        5'b01001: sus2_data = 20'b11111111111111111111;
        5'b01010: sus2_data = 20'b11111111111111111111;
        5'b01011: sus2_data = 20'b11111111111111111111;
        5'b01100: sus2_data = 20'b11111111111111111111;
        5'b01101: sus2_data = 20'b11111000000000011111;
        5'b01110: sus2_data = 20'b01111111111111111110;
        5'b01111: sus2_data = 20'b01111111111111111110;
        5'b10000: sus2_data = 20'b00111111111111111100;
        5'b10001: sus2_data = 20'b00011111111111111000;
        5'b10010: sus2_data = 20'b00001111111111110000;
        5'b10011: sus2_data = 20'b00000000000000000000;
    endcase

assign sus2_addr = y[5:0] - row3_y;
assign sus2_col = x[5:0] - sus2_x;       
assign sus2_rom_bit = sus2_data[sus2_col];

// blue sus face
always @* 
case(sus3_addr)

    5'b00000: sus3_data = 20'b00011111111111111000;
    5'b00001: sus3_data = 20'b00111111111000011100;
    5'b00010: sus3_data = 20'b00111111111011011100;
    5'b00011: sus3_data = 20'b01111000111111011110;
    5'b00100: sus3_data = 20'b11110011111111001111;
    5'b00101: sus3_data = 20'b11111110111101111111;
    5'b00110: sus3_data = 20'b11111100111100111111;
    5'b00111: sus3_data = 20'b11111100111100111111;
    5'b01000: sus3_data = 20'b11111111111111111111;
    5'b01001: sus3_data = 20'b11111111111111111111;
    5'b01010: sus3_data = 20'b11111111111111111111;
    5'b01011: sus3_data = 20'b11111111111111111111;
    5'b01100: sus3_data = 20'b11111111111111111111;
    5'b01101: sus3_data = 20'b11111000000000011111;
    5'b01110: sus3_data = 20'b01111111111111111110;
    5'b01111: sus3_data = 20'b01111111111111111110;
    5'b10000: sus3_data = 20'b00111111111111111100;
    5'b10001: sus3_data = 20'b00011111111111111000;
    5'b10010: sus3_data = 20'b00001111111111110000;
    5'b10011: sus3_data = 20'b00000000000000000000;
endcase

assign sus3_addr = y[5:0] - row4_y;
assign sus3_col = x[5:0] - sus3_x;       
assign sus3_rom_bit = sus3_data[sus3_col];
DIGS_DISPLAY display1 (clk, p2_score, p1_score, SSEG_CA, SSEG_AN);


reg [4:0] div = 0; // controls the speed of player. Rises to 16, then resets to 0.

always @(posedge inDisplay)
begin
    div <=div+1;   
end  

//collision and movement
always@(posedge div[3])
    begin
    if(
    ((((p1_x - skull1_x <= 20) & (p1_x - skull1_x >= 0)) //skull1
    || ((skull1_x - p1_x >= 0) & (skull1_x - p1_x <= 20))) 
    & (((p1_y - row2_y<= 20) & (p1_y - row2_y >= 0))
    || ((row2_y - p1_y <= 20) & (row2_y - p1_y >= 0)))) || 

    ((((p1_x - skull2_x <= 20) & (p1_x - skull2_x >= 0)) //skull2
    || ((skull2_x - p1_x >= 0) & (skull2_x - p1_x <= 20)))
    & ((((p1_y - row3_y <= 20) & (p1_y - row3_y >= 0))
    || ((row3_y - p1_y <= 20)) & (row3_y - p1_y >= 0)))) || 
    
    ((((p1_x - skull3_x <= 20) & (p1_x - skull3_x >= 0)) //skull3
    || ((skull3_x - p1_x >= 0) & (skull3_x - p1_x <= 20)))
    & ((((p1_y - row4_y <= 20) & (p1_y - row4_y >= 0))
    || ((row4_y - p1_y <= 20)) & (row4_y - p1_y >= 0)))) || 

    ((((p1_x - devil1_x <= 20) & (p1_x - devil1_x >= 0)) //devil1
    || ((devil1_x - p1_x >= 0) & (devil1_x - p1_x <= 20))) 
    & (((p1_y - row2_y<= 20) & (p1_y - row2_y >= 0))
    || ((row2_y - p1_y <= 20) & (row2_y - p1_y >= 0)))) ||

    ((((p1_x - devil2_x <= 20) & (p1_x - devil2_x >= 0)) //devil2
    || ((devil2_x - p1_x >= 0) & (devil2_x - p1_x <= 20)))
    & ((((p1_y - row3_y <= 20) & (p1_y - row3_y >= 0))
    || ((row3_y - p1_y <= 20)) & (row3_y - p1_y >= 0)))) ||
    
    ((((p1_x - devil3_x <= 20) & (p1_x - devil3_x >= 0)) //devil3
    || ((devil3_x - p1_x >= 0) & (devil3_x - p1_x <= 20)))
    & ((((p1_y - row4_y <= 20) & (p1_y - row4_y >= 0))
    || ((row4_y - p1_y <= 20)) & (row4_y - p1_y >= 0)))) ||

    ((((p1_x - galaga1_x <= 20) & (p1_x - galaga1_x >= 0)) //galaga1
    || ((galaga1_x - p1_x >= 0) & (galaga1_x - p1_x <= 20))) 
    & (((p1_y - row1_y<= 20) & (p1_y - row1_y >= 0))
    || ((row1_y - p1_y <= 20) & (row1_y - p1_y >= 0)))) ||

    ((((p1_x - galaga2_x <= 20) & (p1_x - galaga2_x >= 0)) //galaga2
    || ((galaga2_x - p1_x >= 0) & (galaga2_x - p1_x <= 20))) 
    & (((p1_y - row2_y<= 20) & (p1_y - row2_y >= 0))
    || ((row2_y - p1_y <= 20) & (row2_y - p1_y >= 0)))) ||
    
    ((((p1_x - galaga3_x <= 20) & (p1_x - galaga3_x >= 0)) //galaga3
    || ((galaga3_x - p1_x >= 0) & (galaga3_x - p1_x <= 20))) 
    & (((p1_y - row4_y<= 20) & (p1_y - row4_y >= 0))
    || ((row4_y - p1_y <= 20) & (row4_y - p1_y >= 0)))) ||

    ((((p1_x - angry1_x <= 20) & (p1_x - angry1_x >= 0)) //angry1
    || ((angry1_x - p1_x >= 0) & (angry1_x - p1_x <= 20))) 
    & (((p1_y - row1_y<= 20) & (p1_y - row1_y >= 0))
    || ((row1_y - p1_y <= 20) & (row1_y - p1_y >= 0)))) || 

    ((((p1_x - angry2_x <= 20) & (p1_x - angry2_x >= 0)) //angry2
    || ((angry2_x - p1_x >= 0) & (angry2_x - p1_x <= 20))) 
    & (((p1_y - row2_y<= 20) & (p1_y - row2_y >= 0))
    || ((row2_y - p1_y <= 20) & (row2_y - p1_y >= 0)))) || 

    ((((p1_x - sus1_x <= 20) & (p1_x - sus1_x >= 0)) //sus1
    || ((sus1_x - p1_x >= 0) & (sus1_x - p1_x <= 20))) 
    & (((p1_y - row1_y<= 20) & (p1_y - row1_y >= 0))
    || ((row1_y - p1_y <= 20) & (row1_y - p1_y >= 0)))) || 

    ((((p1_x - sus2_x <= 20) & (p1_x - sus2_x >= 0)) //sus2
    || ((sus2_x - p1_x >= 0) & (sus2_x - p1_x <= 20))) 
    & (((p1_y - row3_y<= 20) & (p1_y - row3_y >= 0))
    || ((row3_y - p1_y <= 20) & (row3_y - p1_y >= 0)))) ||
    
    ((((p1_x - sus3_x <= 20) & (p1_x - sus3_x >= 0)) //sus3
    || ((sus3_x - p1_x >= 0) & (sus3_x - p1_x <= 20))) 
    & (((p1_y - row4_y<= 20) & (p1_y - row4_y >= 0))
    || ((row4_y - p1_y <= 20) & (row4_y - p1_y >= 0)))) 

    ) // checks if block is being hit, by comparing top left corner of enemy block.      
    begin
         p1_x = 120;
         p1_y = player_starty;
         player_sel=1;
    end

    else if (
    ((((p2_x - skull1_x <= 20) & (p2_x - skull1_x >= 0)) //skull1
    || ((skull1_x - p2_x >= 0) & (skull1_x - p2_x <= 20))) 
    & (((p2_y - row2_y<= 20) & (p2_y - row2_y >= 0))
    || ((row2_y - p2_y <= 20) & (row1_y - p2_y >= 0)))) || 

    ((((p2_x - skull2_x <= 20) & (p2_x - skull2_x >= 0)) //skull2
    || ((skull2_x - p2_x >= 0) & (skull2_x - p2_x <= 20)))
    & ((((p2_y - row3_y <= 20) & (p2_y - row3_y >= 0))
    || ((row3_y - p2_y <= 20)) & (row3_y - p2_y >= 0)))) || 
    
    ((((p2_x - skull3_x <= 20) & (p2_x - skull3_x >= 0)) //skull3
    || ((skull3_x - p2_x >= 0) & (skull3_x - p2_x <= 20)))
    & ((((p2_y - row4_y <= 20) & (p2_y - row4_y >= 0))
    || ((row4_y - p2_y <= 20)) & (row4_y - p2_y >= 0)))) || 

    ((((p2_x - devil1_x <= 20) & (p2_x - devil1_x >= 0)) //devil1
    || ((devil1_x - p2_x >= 0) & (devil1_x - p2_x <= 20))) 
    & (((p2_y - row2_y<= 20) & (p2_y - row2_y >= 0))
    || ((row2_y - p2_y <= 20) & (row2_y - p2_y >= 0)))) ||

    ((((p2_x - devil2_x <= 20) & (p2_x - devil2_x >= 0)) //devil2
    || ((devil2_x - p2_x >= 0) & (devil2_x - p2_x <= 20)))
    & ((((p2_y - row3_y <= 20) & (p2_y - row3_y >= 0))
    || ((row3_y - p2_y <= 20)) & (row3_y - p2_y >= 0)))) ||
    
    ((((p2_x - devil3_x <= 20) & (p2_x - devil3_x >= 0)) //devil3
    || ((devil3_x - p2_x >= 0) & (devil3_x - p2_x <= 20)))
    & ((((p2_y - row4_y <= 20) & (p2_y - row4_y >= 0))
    || ((row4_y - p2_y <= 20)) & (row4_y - p2_y >= 0)))) ||

    ((((p2_x - galaga1_x <= 20) & (p2_x - galaga1_x >= 0)) //galaga1
    || ((galaga1_x - p2_x >= 0) & (galaga1_x - p2_x <= 20))) 
    & (((p2_y - row1_y<= 20) & (p2_y - row1_y >= 0))
    || ((row1_y - p2_y <= 20) & (row1_y - p2_y >= 0)))) ||

    ((((p2_x - galaga2_x <= 20) & (p2_x - galaga2_x >= 0)) //galaga2
    || ((galaga2_x - p2_x >= 0) & (galaga2_x - p2_x <= 20))) 
    & (((p2_y - row2_y<= 20) & (p2_y - row2_y >= 0))
    || ((row2_y - p2_y <= 20) & (row2_y - p2_y >= 0)))) ||
    
    ((((p2_x - galaga3_x <= 20) & (p2_x - galaga3_x >= 0)) //galaga3
    || ((galaga3_x - p2_x >= 0) & (galaga3_x - p2_x <= 20))) 
    & (((p2_y - row4_y<= 20) & (p2_y - row4_y >= 0))
    || ((row4_y - p2_y <= 20) & (row4_y - p2_y >= 0)))) ||

    ((((p2_x - angry1_x <= 20) & (p2_x - angry1_x >= 0)) //angry1
    || ((angry1_x - p2_x >= 0) & (angry1_x - p2_x <= 20))) 
    & (((p2_y - row1_y<= 20) & (p2_y - row1_y >= 0))
    || ((row1_y - p2_y <= 20) & (row1_y - p2_y >= 0)))) || 

    ((((p2_x - angry2_x <= 20) & (p2_x - angry2_x >= 0)) //angry2
    || ((angry2_x - p2_x >= 0) & (angry2_x - p2_x <= 20))) 
    & (((p2_y - row2_y<= 20) & (p2_y - row2_y >= 0))
    || ((row2_y - p2_y <= 20) & (row2_y - p2_y >= 0)))) || 

    ((((p2_x - sus1_x <= 20) & (p2_x - sus1_x >= 0)) //sus1
    || ((sus1_x - p2_x >= 0) & (sus1_x - p2_x <= 20))) 
    & (((p2_y - row1_y<= 20) & (p2_y - row1_y >= 0))
    || ((row1_y - p2_y <= 20) & (row1_y - p2_y >= 0)))) || 

    ((((p2_x - sus2_x <= 20) & (p2_x - sus2_x >= 0)) //sus2
    || ((sus2_x - p2_x >= 0) & (sus2_x - p2_x <= 20))) 
    & (((p2_y - row3_y<= 20) & (p2_y - row3_y >= 0))
    || ((row3_y - p2_y <= 20) & (row3_y - p2_y >= 0)))) || 
    
    ((((p2_x - sus3_x <= 20) & (p2_x - sus3_x >= 0)) //sus2
    || ((sus3_x - p2_x >= 0) & (sus3_x - p2_x <= 20))) 
    & (((p2_y - row4_y<= 20) & (p2_y - row4_y >= 0))
    || ((row4_y - p2_y <= 20) & (row4_y - p2_y >= 0)))) 
    )
    begin
        p2_x=480;
        p2_y=player_starty;
        player_sel=0;
    end
    
    if (((p1_y - vert_pix <= 20) & (p1_y - vert_pix >= 0)) || 
        ((vert_pix - p1_y <= 20) & (vert_pix - p1_y >= 0 )))
        begin
            p1_x = 120;
            p1_y = player_starty;
            player_sel = 1;
            p1_score=p1_score+1;
          // p1_inc = p1_inc+20;

        end
    else if (((p2_y - vert_pix <= 20) & (p2_y - vert_pix >= 0)) || 
        ((vert_pix - p2_y <= 20) & (vert_pix - p2_y >= 0 )))
        begin 
            p2_x = 480;
            p2_y = player_starty;
            player_sel = 0;
            p2_score=p2_score+1;
           // p2_inc = p2_inc+20;
        end
        
    if(p1_score>=3 & p1_score<7)
    begin
        p1_score=p1_score+1;
        p2_score = 8;
        if(p1_score==6)
        begin
            p1_score=3;
        end 
        
    end
    else if(p2_score>=3&p2_score<7)
    begin
        p2_score=p2_score+1;
        p1_score=8;
        if(p2_score==6)
        begin
            p2_score=3;
        end
        
    end
    
    if(C& (p1_score>=3 | p2_score>=3)) begin
        p1_score=0;
        p2_score=0;
        p1_x=120;
        p1_y=player_starty;
        p2_x= 480;
        p2_y= player_starty;
        player_sel=0;
    end
    

    
    // displaying the movement of snake according to direction.
    if(player_sel==0 & (p1_score<=3 || p2_score <=3)) 
    begin
        if(L) 
            begin // Left
                p1_x <= p1_x - player_speed; // snake head will move 20 pixels to the left in x direction 
            end
        
        if(R) // Right
            begin
                p1_x <= p1_x + 20; // snake head will move 20 pixels to the left in x direction 
            end
            
        if(D) // Down
            begin
                p1_y <= p1_y + 20; // snake head will move 20 pixels to the left in x direction 
            end
            
        if(U) // Up
            begin
            
                p1_y <= p1_y - 20; // snake head will move 20 pixels to the left in x direction 
            end
    end
    if(player_sel==1 & (p1_score<=3 || p2_score <=3)) 
    begin
        if(L) 
        begin // Left
            p2_x <= p2_x - 20; // snake head will move 20 pixels to the left in x direction 
        end
        
        if(R) // Right
            begin
            
            p2_x <= p2_x + 20; // snake head will move 20 pixels to the left in x direction 
            end
            
        if(D) // Down
            begin
            
            p2_y <= p2_y + 20; // snake head will move 20 pixels to the left in x direction 
            end
            
        if(U) // Up
            begin
            
            p2_y <= p2_y - 20; // snake head will move 20 pixels to the left in x direction 
            end
        end
            
        if(skull1_x>0)
        begin
            skull1_x<=skull1_x+enemy_speed;
            if(skull1_x>=620)
                begin
                    skull1_x<=10;
                end
        end
        
        if(skull2_x<screen_r)
        begin
            if(skull2_x<=0)
                begin
                    skull2_x<=enemy_sr;
                end 
            else
            begin
                skull2_x<=skull2_x-enemy_speed;  
            end
        end
        
        if(skull3_x>0)
        begin
            skull3_x<=skull3_x+enemy_speed;
            if(skull3_x>=620)
                begin
                    skull3_x<=10;
                end
        end
        

        if(devil1_x>0)
        begin
            devil1_x<=devil1_x+enemy_speed;
            if(devil1_x>=620)
                begin
                    devil1_x<=10;
                end   
        end

        if(devil2_x<screen_r)
        begin
            devil2_x<=devil2_x-enemy_speed;
            if(devil2_x<=0)
                begin
                    devil2_x<=enemy_sr;
                end   
        end
        
        if(devil3_x>0)
        begin
            devil3_x<=devil3_x+enemy_speed;
            if(devil3_x>=620)
                begin
                    devil3_x<=10;
                end   
        end


        if(galaga1_x<screen_r)
        begin
            galaga1_x<=galaga1_x-enemy_speed;
            if(galaga1_x<=0)
                begin
                    galaga1_x<=enemy_sr;
                end   
        end

        if(galaga2_x>0)
        begin
            galaga2_x<=galaga2_x+enemy_speed;
            if(galaga2_x>=620)
                begin
                    galaga2_x<=10;
                end   
        end
        
        if(galaga3_x>0)
        begin
            galaga3_x<=galaga3_x+enemy_speed;
            if(galaga3_x>=620)
                begin
                    galaga3_x<=10;
                end   
        end

        if(angry1_x<screen_r)
        begin
            angry1_x<=angry1_x-enemy_speed;
            if(angry1_x<=0)
                begin
                    angry1_x<=enemy_sr;
                end   
        end

        if(angry2_x>0)
        begin
            angry2_x<=angry2_x+enemy_speed;
            if(angry2_x>=620)
                begin
                    angry2_x<=10;
                end   
        end

        if(sus1_x<screen_r)
        begin
            sus1_x<=sus1_x-enemy_speed;
            if(sus1_x<=0)
                begin
                    sus1_x<=enemy_sr;
                end   
        end

        if(sus2_x<screen_r)
        begin
            sus2_x<=sus2_x-enemy_speed;
            if(sus2_x<=0)
                begin
                    sus2_x<=enemy_sr;
                end 
        end 
        
        if(sus3_x>0)
        begin
            sus3_x<=sus3_x+enemy_speed;
            if(sus3_x>=620)
                begin
                    sus3_x<=10;
                end   
        end


    end 

    always@(*)
    begin
  //  square = (x>20) & (x<620) & (y>20) & (y< 460); // storing all the pixels within the gamearea background
    
    p1_sq = (x >= p1_x) & (x <= p1_x + 20) & (y>=p1_y) & (y<p1_y + 20); // storing all pixels inside 20x20 square
    p1=p1_sq & p1_rom_bit;
    p2_sq = (x >= p2_x) & (x <= p2_x + 20) & (y>=p2_y) & (y<p2_y + 20); // storing all pixels inside 20x20 square
    p2=p2_sq & p2_rom_bit;                                                                     // with top left corner headx,heady
    // similar statements for all the blocks from 1 to 13.
  
    // storing all the pixels within the food block
    skull1_sq = (x >= skull1_x) & (x <= skull1_x + 20) & (y>= row2_y) & (y<row2_y + 20); 
    skull1 = skull1_sq&skull1_rom_bit;
    
    skull2_sq = (x >= skull2_x) & (x <= skull2_x + 20) & (y>= row3_y) & (y<row3_y + 20); 
    skull2 = skull2_sq&skull2_rom_bit;
    
    skull3_sq = (x >= skull3_x) & (x <= skull3_x + 20) & (y>= row4_y) & (y<row4_y + 20); 
    skull3 = skull3_sq&skull3_rom_bit;

    devil1_sq = (x >= devil1_x) & (x <= devil1_x + 20) & (y>= row2_y) & (y<row2_y + 20); 
    devil1 = devil1_sq&devil1_rom_bit;

    devil2_sq = (x >= devil2_x) & (x <= devil2_x + 20) & (y>= row3_y) & (y<row3_y + 20); 
    devil2 = devil2_sq&devil2_rom_bit;
    
    devil3_sq = (x >= devil3_x) & (x <= devil3_x + 20) & (y>= row4_y) & (y<row4_y + 20); 
    devil3 = devil3_sq&devil3_rom_bit;

    galaga1_sq = (x >= galaga1_x) & (x <= galaga1_x + 20) & (y>= row1_y) & (y<row1_y + 20); 
    galaga1 = galaga1_sq&galaga1_rom_bit;

    galaga2_sq = (x >= galaga2_x) & (x <= galaga2_x + 20) & (y>= row2_y) & (y<row2_y + 20); 
    galaga2 = galaga2_sq&galaga2_rom_bit;
    
    galaga3_sq = (x >= galaga3_x) & (x <= galaga3_x + 20) & (y>= row4_y) & (y<row4_y + 20); 
    galaga3 = galaga3_sq&galaga3_rom_bit;

    angry1_sq = (x >= angry1_x) & (x <= angry1_x + 20) & (y>= row1_y) & (y<row1_y + 20); 
    angry1 = angry1_sq&angry1_rom_bit;

    angry2_sq = (x >= angry2_x) & (x <= angry2_x + 20) & (y>= row2_y) & (y<row2_y + 20); 
    angry2 = angry2_sq&angry2_rom_bit;

    sus1_sq = (x >= sus1_x) & (x <= sus1_x + 20) & (y>= row1_y) & (y<row1_y + 20); 
    sus1 = sus1_sq&sus1_rom_bit;

    sus2_sq = (x >= sus2_x) & (x <= sus2_x + 20) & (y>= row3_y) & (y<row3_y + 20); 
    sus2 = sus2_sq&sus2_rom_bit;
    
    sus3_sq = (x >= sus3_x) & (x <= sus3_x + 20) & (y>= row4_y) & (y<row4_y + 20); 
    sus3 = sus3_sq&sus3_rom_bit;
    
    finish = (x>=20)& (x<=620) & (y>=vert_pix) & (y<=vert_pix+finish_thick);
    
  //  p1_box = (x>=60) & (x<=80) & (y>=300) & (y<=300+p1_inc);
  //  p2_box = (x>=560) & (x<=580) & (y>=300) & (y<=300+p2_inc);
    

    
    end
    
    assign leftBorder = (x > 0) & (x <= 40) & (y > 0) & (y < 480);
    assign rightBorder = (x > 620) & (x < 640) & (y > 0) & (y < 480);
    assign topBorder = (x > 0) & (x < 640) & (y > 0) & (y < 20);
    assign bottomBorder = (x > 0) & (x < 640) & (y > 460) & (y < 480);

    //drawing section
    always@(*) 
    begin 
        
        green[3] = (p1 | p2 | skull1 | skull2 | skull3 | galaga1 | galaga2 | galaga3
            | leftBorder | rightBorder | topBorder | bottomBorder | finish); 
        blue[3] = (skull1 | skull2 | skull3 | devil1 | devil2 | devil3 | sus1 | sus2 | sus3 
            | leftBorder | rightBorder | topBorder | bottomBorder | finish); 
        red[3] = (p1 | p2 | skull1 | skull2 | skull3 | devil1 | devil2 | devil3 | angry1 | angry2 
            | leftBorder | rightBorder | topBorder | bottomBorder ) ;
        //| leftBorder | rightBorder | topBorder | bottomBorder
       
    end

endmodule