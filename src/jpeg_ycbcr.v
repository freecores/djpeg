//---------------------------------------------------------------------------
// File Name   : jpeg_ycbcr.v
// Module Name : jpeg_ycbcr
// Description : Convert to RGB from YCbCr 
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
//---------------------------------------------------------------------------
// $Id: 
//---------------------------------------------------------------------------
`timescale 1ps / 1ps

module jpeg_ycbcr
  (
   rst,
   clk,

   DataInEnable,
   DataInPage,
   DataInCount,
   DataInIdle,
   Data0In,
   Data1In,
   DataInBlockWidth,

   OutEnable,
   OutPixelX,
   OutPixelY,
   OutR,
   OutG,
   OutB
   );

   input          rst;
   input          clk;
   
   input          DataInEnable;
   input [2:0]    DataInPage;
   input [1:0]    DataInCount;
   output         DataInIdle;
   input [8:0]    Data0In;
   input [8:0]    Data1In;
   input [11:0]   DataInBlockWidth;

   output         OutEnable;
   output [15:0]  OutPixelX;
   output [15:0]  OutPixelY;
   output [7:0]   OutR;
   output [7:0]   OutG;
   output [7:0]   OutB;

   reg            DataInBank;
   reg [2:0]      DataInColor;
   reg [11:0]     DataInBlockX;
   reg [11:0]     DataInBlockY;
   reg            BankAActive;
   reg            BankBActive;
   wire           BankAEnable;
   wire           BankBEnable;
   
   wire [8:0]     BankAY;
   wire [8:0]     BankACb;
   wire [8:0]     BankACr;
   wire [8:0]     BankBY;
   wire [8:0]     BankBCb;
   wire [8:0]     BankBCr;
   
   reg [11:0]     BankABlockX;
   reg [11:0]     BankABlockY;
   reg [11:0]     BankBBlockX;
   reg [11:0]     BankBBlockY;
   
   wire           ConvertEnable;
   wire           ConvertBank;
   wire [7:0]     ConvertAddress;
   wire [8:0]     DataY;
   wire [8:0]     DataCb;
   wire [8:0]     DataCr;
   wire [11:0]    ConvertBlockX;
   wire [11:0]    ConvertBlockY;

   wire           BankAIdle;
   wire           BankBIdle;
   
   always @(posedge clk or negedge rst) begin
      if(!rst) begin
         DataInBank   <= 1'b0;
         DataInColor  <= 3'b000;
         DataInBlockX <= 12'h000;
         DataInBlockY <= 12'h000;
         BankAActive  <= 1'b0;
         BankBActive  <= 1'b0;
         BankABlockX  <= 12'h000;
         BankABlockY  <= 12'h000;
         BankBBlockX  <= 12'h000;
         BankBBlockY  <= 12'h000;
      end else begin // if (!rst)
         if(DataInEnable == 1'b1 & DataInColor == 3'b101 & 
            DataInPage == 3'b111 & DataInCount == 2'b11) begin
         end
         if(DataInEnable == 1'b1 & DataInColor == 3'b101 & 
            DataInPage == 3'b111 & DataInCount == 2'b11 &
            DataInBank == 1'b0   & BankAActive == 1'b0) begin
            BankAActive <= 1'b1;
            BankABlockX <= DataInBlockX;
            BankABlockY <= DataInBlockY;
         end else if(ConvertBank == 1'b0 & ConvertAddress == 7'b111) begin
            BankAActive <= 1'b0;
         end
         if(DataInEnable == 1'b1 & DataInColor == 3'b101 & 
            DataInPage == 3'b111 & DataInCount == 2'b11 &
            DataInBank == 1'b1   & BankBActive == 1'b0) begin
            BankBActive <= 1'b1;
            BankBBlockX <= DataInBlockX;
            BankBBlockY <= DataInBlockY;
         end else if(ConvertBank == 1'b1 & ConvertAddress == 7'b111) begin
            BankBActive <= 1'b0;
         end
         if(DataInEnable == 1'b1 &
            DataInPage == 3'b111 & DataInCount == 2'b11) begin
            if(DataInColor == 3'b101) begin
               DataInColor <= 3'b000;
               DataInBank <= ~DataInBank;
               if(DataInBlockWidth == DataInBlockX +1) begin
                  DataInBlockX <= 12'h000;
                  DataInBlockY <= DataInBlockY + 12'h001;
               end else begin
                  DataInBlockX <= DataInBlockX + 12'h001;
               end
            end else begin
               DataInColor <= DataInColor + 3'b001;
            end // else: !if(DataInColor == 3'b101)
         end // if (DataInEnable == 1'b1 &...
         
      end // else: !if(!rst)
   end // always @ (posedge clk or negedge rst)

   assign BankAEnable = DataInEnable == 1'b1 & DataInBank == 1'b0;
   assign BankBEnable = DataInEnable == 1'b1 & DataInBank == 1'b1;

   /*
   assign ConvertBlockX = (ConvertBank)?BankBBlockX:BankABlockX;
   assign ConvertBlockY = (ConvertBank)?BankBBlockY:BankABlockY;
    */

   assign ConvertEnable = DataInEnable == 1'b1 & DataInColor == 3'b101 & 
                          DataInPage == 3'b111 & DataInCount == 2'b11;

   assign DataInIdle = BankAActive == 1'b0 | BankBActive == 1'b0;
   
   //------------------------------------------------------------------------
   // YCbCr Memory
   //------------------------------------------------------------------------
   jpeg_ycbcr_mem u_jpeg_ycbcr_mem0(
                                     .clk(clk),
                                     
                                     .DataInEnable (BankAEnable),
                                     .DataInColor  (DataInColor),
                                     .DataInPage   (DataInPage),
                                     .DataInCount  (DataInCount),
                                     .Data0In      (Data0In),
                                     .Data1In      (Data1In),
                                     
                                     .DataOutAddress (ConvertAddress),
                                     .DataOutY       (BankAY),
                                     .DataOutCb      (BankACb),
                                     .DataOutCr      (BankACr)
                                     );
   jpeg_ycbcr_mem u_jpeg_ycbcr_mem1(
                                     .clk(clk),
                                     
                                     .DataInEnable (BankBEnable),
                                     .DataInColor  (DataInColor),
                                     .DataInPage   (DataInPage),
                                     .DataInCount  (DataInCount),
                                     .Data0In      (Data0In),
                                     .Data1In      (Data1In),
                                     
                                     .DataOutAddress (ConvertAddress),
                                     .DataOutY       (BankBY),
                                     .DataOutCb      (BankBCb),
                                     .DataOutCr      (BankBCr)
                                     );

   reg    ConvertBankD;
   always @(posedge clk or negedge rst) begin
      if(!rst) ConvertBankD <= 1'b0;
      else     ConvertBankD <= ConvertBank;
   end
   
  
   assign DataY  = (ConvertBankD)?BankBY :BankAY;
   assign DataCb = (ConvertBankD)?BankBCb:BankACb;
   assign DataCr = (ConvertBankD)?BankBCr:BankACr;

   //------------------------------------------------------------------------
   // YCbCr to RGB
   //------------------------------------------------------------------------
   jpeg_ycbcbr2rgb u_jpeg_ycbcr2rgb(
                                    .rst(rst),
                                    .clk(clk),
                                    
                                    .InEnable  ( ConvertEnable  ),
                                    .InBlockX  ( DataInBlockX  ),
                                    .InBlockY  ( DataInBlockY  ),
                                    .InIdle    ( ConvertIdle    ),
                                    .InBank    ( ConvertBank    ),
                                    .InAddress ( ConvertAddress ),
                                    .InY       ( DataY          ),
                                    .InCb      ( DataCb         ),
                                    .InCr      ( DataCr         ),
                                    
                                    .OutEnable ( OutEnable      ),
                                    .OutPixelX ( OutPixelX      ),
                                    .OutPixelY ( OutPixelY      ),
                                    .OutR      ( OutR           ),
                                    .OutG      ( OutG           ),
                                    .OutB      ( OutB           )
                                    );
endmodule // jpeg_ycbcr
