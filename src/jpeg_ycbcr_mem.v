//---------------------------------------------------------------------------
// File Name   : jpeg_ycbcr_mem.v
// Module Name : jpeg_ycbcr_mem
// Description : Memory for YCbCr2RGB
// Project     : JPEG Decoder
// Belong to   : 
// Author      : H.Ishihara
// E-Mail      : hidemi@sweetcafe.jp
// HomePage    : http://www.sweetcafe.jp/
// Date        : 2006/10/01
// Rev.        : 1.1
//---------------------------------------------------------------------------
// Rev. Date       Description
//---------------------------------------------------------------------------
// 1.01 2006/10/01 1st Release
// 1.02 2006/10/04 remove a WriteData,WriteDataA,WriteDataB wires.
//---------------------------------------------------------------------------
// $Id: 
//---------------------------------------------------------------------------
`timescale 1ps / 1ps

module jpeg_ycbcr_mem
  (
   clk,

   DataInEnable,
   DataInColor,
   DataInPage,
   DataInCount,
   Data0In,
   Data1In,

   DataOutAddress,
   DataOutY,
   DataOutCb,
   DataOutCr
   );

   input          clk;
   
   input          DataInEnable;
   input [2:0]    DataInColor;
   input [2:0]    DataInPage;
   input [1:0]    DataInCount;
   input [8:0]    Data0In;
   input [8:0]    Data1In;
   
   input [7:0]    DataOutAddress;
   output [8:0]   DataOutY;
   output [8:0]   DataOutCb;
   output [8:0]   DataOutCr;

   reg [8:0]      MemYA  [0:127];
   reg [8:0]      MemYB  [0:127];
   reg [8:0]      MemCbA [0:31];
   reg [8:0]      MemCbB [0:31];
   reg [8:0]      MemCrA [0:31];
   reg [8:0]      MemCrB [0:31];

   reg [6:0]      WriteAddressA;
   reg [6:0]      WriteAddressB;

   always @(DataInColor or DataInPage or DataInCount) begin
      WriteAddressA[6] <= DataInColor[1];
      WriteAddressB[6] <= DataInColor[1];
      if(DataInColor[2] == 1'b0) begin
         if(DataInColor[0] == 1'b0) begin
            case(DataInCount)
              2'h0: begin
                 WriteAddressA[5:0] <= DataInPage +  0;
                 WriteAddressB[5:0] <= DataInPage +112 -64;
              end
              2'h1: begin
                 WriteAddressA[5:0] <= DataInPage + 16;
                 WriteAddressB[5:0] <= DataInPage + 96 -64;
              end
              2'h2: begin
                 WriteAddressA[5:0] <= DataInPage + 32;
                 WriteAddressB[5:0] <= DataInPage + 80 -64;
              end
              2'h3: begin
                 WriteAddressA[5:0] <= DataInPage + 48;
                 WriteAddressB[5:0] <= DataInPage + 64 -64;
              end
            endcase // case(DataInCount)
         end else begin // if (DataInColor[0] == 1'b0)
            case(DataInCount)
              2'h0: begin
                 WriteAddressA[5:0] <= DataInPage +  0 +8;
                 WriteAddressB[5:0] <= DataInPage +112 +8 -64;
              end
              2'h1: begin
                 WriteAddressA[5:0] <= DataInPage + 16 +8;
                 WriteAddressB[5:0] <= DataInPage + 96 +8 -64;
              end
              2'h2: begin
                 WriteAddressA[5:0] <= DataInPage + 32 +8;
                 WriteAddressB[5:0] <= DataInPage + 80 +8 -64;
              end
              2'h3: begin
                 WriteAddressA[5:0] <= DataInPage + 48 +8;
                 WriteAddressB[5:0] <= DataInPage + 64 +8 -64;
              end
            endcase // case(DataInCount)
         end // else: !if(DataInColor[0] == 1'b0)
      end else begin // if (DataInColor[2] == 1'b0)
         case(DataInCount)
           2'h0: begin
              WriteAddressA[5:0] <= DataInPage +  0;
              WriteAddressB[5:0] <= DataInPage + 56 -32;
           end
           2'h1: begin
              WriteAddressA[5:0] <= DataInPage +  8;
              WriteAddressB[5:0] <= DataInPage + 48 -32;
           end
           2'h2: begin
              WriteAddressA[5:0] <= DataInPage + 16;
              WriteAddressB[5:0] <= DataInPage + 40 -32;
           end
           2'h3: begin
              WriteAddressA[5:0] <= DataInPage + 24;
              WriteAddressB[5:0] <= DataInPage + 32 -32;
           end
         endcase // case(DataInCount)
      end // else: !if(DataInColor[2] == 1'b0)
   end // always @ (DataInColor or DataInPage or DataInCount)
   
   always @(posedge clk) begin
      if(DataInColor[2] == 1'b0 & DataInEnable == 1'b1) begin
         MemYA[WriteAddressA] <= Data0In;
         MemYB[WriteAddressB] <= Data1In;
      end
   end
   
   always @(posedge clk) begin
      if(DataInColor == 3'b100 & DataInEnable == 1'b1) begin
         MemCbA[WriteAddressA[4:0]] <= Data0In;
         MemCbB[WriteAddressB[4:0]] <= Data1In;
      end
   end
   
   always @(posedge clk) begin
      if(DataInColor == 3'b101 & DataInEnable == 1'b1) begin
         MemCrA[WriteAddressA[4:0]] <= Data0In;
         MemCrB[WriteAddressB[4:0]] <= Data1In;
      end
   end

   reg [8:0] ReadYA;
   reg [8:0] ReadYB;
   reg [8:0] ReadCbA;
   reg [8:0] ReadCbB;
   reg [8:0] ReadCrA;
   reg [8:0] ReadCrB;

   reg [7:0] RegAdrs;
   
   always @(posedge clk) begin
      RegAdrs <= DataOutAddress;
      
      ReadYA  <= MemYA[{DataOutAddress[7],DataOutAddress[5:0]}];
      ReadYB  <= MemYB[{DataOutAddress[7],DataOutAddress[5:0]}];

      ReadCbA <= MemCbA[{DataOutAddress[6:5],DataOutAddress[3:1]}];
      ReadCrA <= MemCrA[{DataOutAddress[6:5],DataOutAddress[3:1]}];

      ReadCbB <= MemCbB[{DataOutAddress[6:5],DataOutAddress[3:1]}];
      ReadCrB <= MemCrB[{DataOutAddress[6:5],DataOutAddress[3:1]}];
   end // always @ (posedge clk)

   assign DataOutY  = (RegAdrs[6] ==1'b0)?ReadYA:ReadYB;
   assign DataOutCb = (RegAdrs[7] ==1'b0)?ReadCbA:ReadCbB;
   assign DataOutCr = (RegAdrs[7] ==1'b0)?ReadCrA:ReadCrB;
      
endmodule // jpeg_ycbcr_mem
