//---------------------------------------------------------------------------
// File Name    : jpeg_regdata.v
// Module Name  : jpeg_regdata
// Description  : get Data
// Project              : JPEG Decoder
// Belong to    : 
// Author               : H.Ishihara
// E-Mail               : hidemi@sweetcafe.jp
// HomePage             : http://www.sweetcafe.jp/
// Date                 : 2007/04/11
// Rev.                 : 1.03
//---------------------------------------------------------------------------
// Rev. Date             Description
//---------------------------------------------------------------------------
// 1.01 2006/10/01 1st Release
// 1.02 2006/10/04 Remove a RegEnd register.
//                                        When reset, clear on OutEnable,PreEnable,DataOut registers.
//                                        Remove some comments.
// 1.03 2007/04/11 Don't OutEnable, ImageEnable == 1 and DataOut == 0xFFD9XXXX
//                 Stop ReadEnable with DataEnd(after 0xFFD9 of ImageData)
//---------------------------------------------------------------------------
// $Id: 
//---------------------------------------------------------------------------
`timescale 1ps / 1ps
        
module jpeg_regdata(
        rst,
        clk,

        // Read Data
        DataIn,                 // 
        DataInEnable,   // Data Enable
        DataInRead,             // Data Read

        // DataOut
        DataOut,                // Data Out
        DataOutEnable,  // Data Out Enable

        // 
        ImageEnable,
        ProcessIdle,
        
        // UseData
        UseBit,         // Used data bit
        UseWidth,       // Used data bit width
        UseByte,        // Used data byte
        UseWord         // Used data word
        );

        input                   rst;
        input                   clk;

        input [31:0]    DataIn;
        input                   DataInEnable;
        output                  DataInRead;

        output [31:0]   DataOut;
        output                  DataOutEnable;

        input                   ImageEnable;
        input                   ProcessIdle;
        
        input                   UseBit;
        input [6:0]             UseWidth;
        input                   UseByte;
        input                   UseWord;

        wire                    RegValid;
        reg [95:0]              RegData;
        reg [7:0]               RegWidth;

        reg                             DataEnd;

        assign                  RegValid        = RegWidth > 64;
        assign                  DataInRead      = RegValid == 1'b0 & DataInEnable == 1'b1;
        
        always @(posedge clk or negedge rst) begin
                if(!rst) begin
                        RegData  <= 96'd0;
                        RegWidth <= 8'h00;
                end else begin
                        if(RegValid == 1'b0 & (DataInEnable == 1'b1 | DataEnd == 1'b1)) begin
                                if(ImageEnable == 1'b1) begin
                                        if(RegData[39: 8] == 32'hFF00FF00) begin
                                                RegWidth                <= RegWidth + 16;
                                                RegData[95:64]  <= {8'h00,RegData[71:48]};
                                                RegData[63:32]  <= {RegData[47:40],16'hFFFF,RegData[7:0]};
                                        end else if(RegData[39:24] == 16'hFF00 &
                                                RegData[15: 0] == 16'hFF00) begin
                                                RegWidth                <= RegWidth + 16;
                                                RegData[95:64]  <= {8'h00,RegData[71:48]};
                                                RegData[63:32]  <= {RegData[47:40],8'hFF,RegData[23:16],8'hFF};
                                        end else if(RegData[31: 0] == 32'hFF00FF00) begin
                                                RegWidth                <= RegWidth + 16;
                                                RegData[95:64]  <= {16'h0000,RegData[71:56]};
                                                RegData[63:32]  <= {RegData[55:40],16'hFFFF};
                                        end else if(RegData[39:24] == 16'hFF00) begin
                                                RegWidth                <= RegWidth + 24;
                                                RegData[95:64]  <= {RegData[71:40]};
                                                RegData[63:32]  <= {8'hFF,RegData[23:0]};
                                        end else if(RegData[31:16] == 16'hFF00) begin
                                                RegWidth                <= RegWidth + 24;
                                                RegData[95:64]  <= {RegData[71:40]};
                                                RegData[63:32]  <= {RegData[39:32],8'hFF,RegData[15:0]};
                                        end else if(RegData[23: 8] == 16'hFF00) begin
                                                RegWidth                <= RegWidth + 24;
                                                RegData[95:64]  <= {RegData[71:40]};
                                                RegData[63:32]  <= {RegData[39:32],RegData[31:24],8'hFF,RegData[7:0]};
                                        end else if(RegData[15: 0] == 16'hFF00) begin
                                                RegWidth                <= RegWidth + 24;
                                                RegData[95:64]  <= {RegData[71:40]};
                                                RegData[63:32]  <= {RegData[39:32],RegData[31:16],8'hFF};
                                        end else begin
                                                RegWidth                <= RegWidth + 32;
                                                RegData[95:64]  <= RegData[63:32];
                                                RegData[63:32]  <= RegData[31:0];
                                        end
                                end else begin
                                        RegWidth                <= RegWidth + 32;
                                        RegData[95:64]  <= RegData[63:32];
                                        RegData[63:32]  <= RegData[31:0];
                                end
                                RegData[31: 0] <= {DataIn[7:0],DataIn[15:8],DataIn[23:16],DataIn[31:24]};
                        end else if(UseBit == 1'b1) begin
                                RegWidth <= RegWidth - UseWidth;
                        end else if(UseByte == 1'b1) begin
                                RegWidth <= RegWidth - 8;
                        end else if(UseWord == 1'b1) begin
                                RegWidth <= RegWidth - 16;
                        end
                end
        end

        always @(posedge clk or negedge rst) begin
                if(!rst) begin
                        DataEnd <= 1'b0;
                end else begin
                        if(ProcessIdle) begin
                                DataEnd <= 1'b0;
                        end else if(ImageEnable == 1'b1 & (RegData[39:24] == 16'hFFD9 | RegData[31:16] == 16'hFFD9 | RegData[23: 8] == 16'hFFD9 | RegData[15: 0] == 16'hFFD9)) begin
                                DataEnd <= 1'b1;
                        end
                end
        end

        function [31:0] SliceData;
                input [95:0] RegData;
                input [7:0]  RegWidth;

                case(RegWidth)
                        8'd65: SliceData = RegData[64:33];
                        8'd66: SliceData = RegData[65:34];
                        8'd67: SliceData = RegData[66:35];
                        8'd68: SliceData = RegData[67:36];
                        8'd69: SliceData = RegData[68:37];
                        8'd70: SliceData = RegData[69:38];
                        8'd71: SliceData = RegData[70:39];
                        8'd72: SliceData = RegData[71:40];
                        8'd73: SliceData = RegData[72:41];
                        8'd74: SliceData = RegData[73:42];
                        8'd75: SliceData = RegData[74:43];
                        8'd76: SliceData = RegData[75:44];
                        8'd77: SliceData = RegData[76:45];
                        8'd78: SliceData = RegData[77:46];
                        8'd79: SliceData = RegData[78:47];
                        8'd80: SliceData = RegData[79:48];
                        8'd81: SliceData = RegData[80:49];
                        8'd82: SliceData = RegData[81:50];
                        8'd83: SliceData = RegData[82:51];
                        8'd84: SliceData = RegData[83:52];
                        8'd85: SliceData = RegData[84:53];
                        8'd86: SliceData = RegData[85:54];
                        8'd87: SliceData = RegData[86:55];
                        8'd88: SliceData = RegData[87:56];
                        8'd89: SliceData = RegData[88:57];
                        8'd90: SliceData = RegData[89:58];
                        8'd91: SliceData = RegData[90:59];
                        8'd92: SliceData = RegData[91:60];
                        8'd93: SliceData = RegData[92:61];
                        8'd94: SliceData = RegData[93:62];
                        8'd95: SliceData = RegData[94:63];
                        8'd96: SliceData = RegData[95:64];
                        default: SliceData = 32'h00000000;
                endcase
        endfunction

        reg                     OutEnable;
        reg                     PreEnable;
        
        reg [31:0]              DataOut;

        always @(posedge clk or negedge rst) begin
                if(!rst) begin
                        OutEnable       <= 1'b0;
                        PreEnable       <= 1'b0;
                        DataOut         <= 32'h00000000;
                end else begin
                        OutEnable       <= RegWidth >64;
                        PreEnable       <= (UseBit == 1'b1 | UseByte == 1'b1 | UseWord == 1'b1);
                        DataOut         <= SliceData(RegData,RegWidth);
                end
        end

        assign DataOutEnable = (PreEnable == 1'b0)?OutEnable:1'b0;
                
endmodule


  