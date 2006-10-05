//---------------------------------------------------------------------------
// File Name   : jpeg_idctb.v
// Module Name : jpeg_idctb
// Description : data register for iDCT
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

module jpeg_idctb
  (
   rst,
   clk,

   DataInEnable,
   DataInPage,
   DataInCount,
   DataInIdle,
   Data0In,
   Data1In,

   DataOutEnable,
   DataOutSel,
   Data00Out,
   Data01Out,
   Data02Out,
   Data03Out,
   Data04Out,
   Data05Out,
   Data06Out,
   Data07Out,
   Data08Out,
   Data09Out,
   Data10Out,
   Data11Out,
   Data12Out,
   Data13Out,
   Data14Out,
   Data15Out,
   Data16Out,
   Data17Out,
   Data18Out,
   Data19Out,
   Data20Out,
   Data21Out,
   Data22Out,
   Data23Out,
   Data24Out,
   Data25Out,
   Data26Out,
   Data27Out,
   Data28Out,
   Data29Out,
   Data30Out,
   Data31Out,
   Data32Out,
   Data33Out,
   Data34Out,
   Data35Out,
   Data36Out,
   Data37Out,
   Data38Out,
   Data39Out,
   Data40Out,
   Data41Out,
   Data42Out,
   Data43Out,
   Data44Out,
   Data45Out,
   Data46Out,
   Data47Out,
   Data48Out,
   Data49Out,
   Data50Out,
   Data51Out,
   Data52Out,
   Data53Out,
   Data54Out,
   Data55Out,
   Data56Out,
   Data57Out,
   Data58Out,
   Data59Out,
   Data60Out,
   Data61Out,
   Data62Out,
   Data63Out,

   BankARelease,
   BankBRelease
   );

   input clk;
   input rst;

   input DataInEnable;
   input [2:0] DataInPage;
   input [1:0] DataInCount;
   output      DataInIdle;
   input [15:0] Data0In;
   input [15:0] Data1In;

   output       DataOutEnable;
   input         DataOutSel;
   output [15:0] Data00Out;
   output [15:0] Data01Out;
   output [15:0] Data02Out;
   output [15:0] Data03Out;
   output [15:0] Data04Out;
   output [15:0] Data05Out;
   output [15:0] Data06Out;
   output [15:0] Data07Out;
   output [15:0] Data08Out;
   output [15:0] Data09Out;
   output [15:0] Data10Out;
   output [15:0] Data11Out;
   output [15:0] Data12Out;
   output [15:0] Data13Out;
   output [15:0] Data14Out;
   output [15:0] Data15Out;
   output [15:0] Data16Out;
   output [15:0] Data17Out;
   output [15:0] Data18Out;
   output [15:0] Data19Out;
   output [15:0] Data20Out;
   output [15:0] Data21Out;
   output [15:0] Data22Out;
   output [15:0] Data23Out;
   output [15:0] Data24Out;
   output [15:0] Data25Out;
   output [15:0] Data26Out;
   output [15:0] Data27Out;
   output [15:0] Data28Out;
   output [15:0] Data29Out;
   output [15:0] Data30Out;
   output [15:0] Data31Out;
   output [15:0] Data32Out;
   output [15:0] Data33Out;
   output [15:0] Data34Out;
   output [15:0] Data35Out;
   output [15:0] Data36Out;
   output [15:0] Data37Out;
   output [15:0] Data38Out;
   output [15:0] Data39Out;
   output [15:0] Data40Out;
   output [15:0] Data41Out;
   output [15:0] Data42Out;
   output [15:0] Data43Out;
   output [15:0] Data44Out;
   output [15:0] Data45Out;
   output [15:0] Data46Out;
   output [15:0] Data47Out;
   output [15:0] Data48Out;
   output [15:0] Data49Out;
   output [15:0] Data50Out;
   output [15:0] Data51Out;
   output [15:0] Data52Out;
   output [15:0] Data53Out;
   output [15:0] Data54Out;
   output [15:0] Data55Out;
   output [15:0] Data56Out;
   output [15:0] Data57Out;
   output [15:0] Data58Out;
   output [15:0] Data59Out;
   output [15:0] Data60Out;
   output [15:0] Data61Out;
   output [15:0] Data62Out;
   output [15:0] Data63Out;

   input         BankARelease;
   input         BankBRelease;
   
   reg           BankAEnable;
   reg           BankBEnable;
   reg           DataInBank;
   
   always @(posedge clk or negedge rst) begin
      if(!rst) begin
         BankAEnable <= 1'b0;
         BankBEnable <= 1'b0;
         DataInBank  <= 1'b0;
      end else begin
         if(BankAEnable == 1'b0 & DataInBank == 1'b0) begin
            if(DataInEnable == 1'b1 & 
               DataInPage == 3'd7 & DataInCount == 2'd3) begin
               BankAEnable <= 1'b1;
            end
         end else begin
            if(BankARelease == 1'b1) begin
               BankAEnable <= 1'b0;
            end
         end
         if(BankBEnable == 1'b0 & DataInBank == 1'b1) begin
            if(DataInEnable == 1'b1 & 
               DataInPage == 3'd7 & DataInCount == 2'd3) begin
               BankBEnable <= 1'b1;
            end
         end else begin
            if(BankBRelease == 1'b1) begin
               BankBEnable <= 1'b0;
            end
         end
         if(DataInEnable == 1'b1 & 
            DataInPage == 3'd7 & DataInCount == 2'd3) begin
            DataInBank   <= ~DataInBank;
         end
      end // else: !if(!rst)
   end // always @ (posedge clk or negedge rst)

   assign DataInIdle = BankAEnable == 1'b0 | BankBEnable == 1'b0;

   assign DataOutEnable = DataInEnable == 1'b1 & DataInPage == 3'b111 &
                          DataInCount  == 2'b11;
   
   reg [15:0] BankAReg [0:63];
   
   always @(posedge clk or negedge rst) begin
      if(!rst) begin
         BankAReg[0] <= 12'h000;
         BankAReg[1] <= 12'h000;
         BankAReg[2] <= 12'h000;
         BankAReg[3] <= 12'h000;
         BankAReg[4] <= 12'h000;
         BankAReg[5] <= 12'h000;
         BankAReg[6] <= 12'h000;
         BankAReg[7] <= 12'h000;
         BankAReg[8] <= 12'h000;
         BankAReg[9] <= 12'h000;
         BankAReg[10] <= 12'h000;
         BankAReg[11] <= 12'h000;
         BankAReg[12] <= 12'h000;
         BankAReg[13] <= 12'h000;
         BankAReg[14] <= 12'h000;
         BankAReg[15] <= 12'h000;
         BankAReg[16] <= 12'h000;
         BankAReg[17] <= 12'h000;
         BankAReg[18] <= 12'h000;
         BankAReg[19] <= 12'h000;
         BankAReg[20] <= 12'h000;
         BankAReg[21] <= 12'h000;
         BankAReg[22] <= 12'h000;
         BankAReg[23] <= 12'h000;
         BankAReg[24] <= 12'h000;
         BankAReg[25] <= 12'h000;
         BankAReg[26] <= 12'h000;
         BankAReg[27] <= 12'h000;
         BankAReg[28] <= 12'h000;
         BankAReg[29] <= 12'h000;
         BankAReg[30] <= 12'h000;
         BankAReg[31] <= 12'h000;
         BankAReg[32] <= 12'h000;
         BankAReg[33] <= 12'h000;
         BankAReg[34] <= 12'h000;
         BankAReg[35] <= 12'h000;
         BankAReg[36] <= 12'h000;
         BankAReg[37] <= 12'h000;
         BankAReg[38] <= 12'h000;
         BankAReg[39] <= 12'h000;
         BankAReg[40] <= 12'h000;
         BankAReg[41] <= 12'h000;
         BankAReg[42] <= 12'h000;
         BankAReg[43] <= 12'h000;
         BankAReg[44] <= 12'h000;
         BankAReg[45] <= 12'h000;
         BankAReg[46] <= 12'h000;
         BankAReg[47] <= 12'h000;
         BankAReg[48] <= 12'h000;
         BankAReg[49] <= 12'h000;
         BankAReg[50] <= 12'h000;
         BankAReg[51] <= 12'h000;
         BankAReg[52] <= 12'h000;
         BankAReg[53] <= 12'h000;
         BankAReg[54] <= 12'h000;
         BankAReg[55] <= 12'h000;
         BankAReg[56] <= 12'h000;
         BankAReg[57] <= 12'h000;
         BankAReg[58] <= 12'h000;
         BankAReg[59] <= 12'h000;
         BankAReg[60] <= 12'h000;
         BankAReg[61] <= 12'h000;
         BankAReg[62] <= 12'h000;
         BankAReg[63] <= 12'h000;
      end else begin // if (!rst)
         if(DataInEnable == 1'b1 & DataInBank == 1'b0) begin
            case(DataInPage)
              3'd0: begin
                 case(DataInCount)
                   2'd0: begin
                      BankAReg[0] <= Data0In;
                      BankAReg[7] <= Data1In;
                   end
                   2'd1: begin
                      BankAReg[1] <= Data0In;
                      BankAReg[6] <= Data1In;
                   end
                   2'd2: begin
                      BankAReg[2] <= Data0In;
                      BankAReg[5] <= Data1In;
                   end
                   2'd3: begin
                      BankAReg[3] <= Data0In;
                      BankAReg[4] <= Data1In;
                   end
                 endcase // case(DataInCount)
              end // case: 3'd0
              3'd1: begin
                 case(DataInCount)
                   2'd0: begin
                      BankAReg[8] <= Data0In;
                      BankAReg[15] <= Data1In;
                   end
                   2'd1: begin
                      BankAReg[9] <= Data0In;
                      BankAReg[14] <= Data1In;
                   end
                   2'd2: begin
                      BankAReg[10] <= Data0In;
                      BankAReg[13] <= Data1In;
                   end
                   2'd3: begin
                      BankAReg[11] <= Data0In;
                      BankAReg[12] <= Data1In;
                   end
                 endcase // case(DataInCount)
              end // case: 3'd1
              3'd2: begin
                 case(DataInCount)
                   2'd0: begin
                      BankAReg[16] <= Data0In;
                      BankAReg[23] <= Data1In;
                   end
                   2'd1: begin
                      BankAReg[17] <= Data0In;
                      BankAReg[22] <= Data1In;
                   end
                   2'd2: begin
                      BankAReg[18] <= Data0In;
                      BankAReg[21] <= Data1In;
                   end
                   2'd3: begin
                      BankAReg[19] <= Data0In;
                      BankAReg[20] <= Data1In;
                   end
                 endcase // case(DataInCount)
              end // case: 3'd2
              3'd3: begin
                 case(DataInCount)
                   2'd0: begin
                      BankAReg[24] <= Data0In;
                      BankAReg[31] <= Data1In;
                   end
                   2'd1: begin
                      BankAReg[25] <= Data0In;
                      BankAReg[30] <= Data1In;
                   end
                   2'd2: begin
                      BankAReg[26] <= Data0In;
                      BankAReg[29] <= Data1In;
                   end
                   2'd3: begin
                      BankAReg[27] <= Data0In;
                      BankAReg[28] <= Data1In;
                   end
                 endcase // case(DataInCount)
              end // case: 3'd3
              3'd4: begin
                 case(DataInCount)
                   2'd0: begin
                      BankAReg[32] <= Data0In;
                      BankAReg[39] <= Data1In;
                   end
                   2'd1: begin
                      BankAReg[33] <= Data0In;
                      BankAReg[38] <= Data1In;
                   end
                   2'd2: begin
                      BankAReg[34] <= Data0In;
                      BankAReg[37] <= Data1In;
                   end
                   2'd3: begin
                      BankAReg[35] <= Data0In;
                      BankAReg[36] <= Data1In;
                   end
                 endcase // case(DataInCount)
              end // case: 3'd4
              3'd5: begin
                 case(DataInCount)
                   2'd0: begin
                      BankAReg[40] <= Data0In;
                      BankAReg[47] <= Data1In;
                   end
                   2'd1: begin
                      BankAReg[41] <= Data0In;
                      BankAReg[46] <= Data1In;
                   end
                   2'd2: begin
                      BankAReg[42] <= Data0In;
                      BankAReg[45] <= Data1In;
                   end
                   2'd3: begin
                      BankAReg[43] <= Data0In;
                      BankAReg[44] <= Data1In;
                   end
                 endcase // case(DataInCount)
              end // case: 3'd5
              3'd6: begin
                 case(DataInCount)
                   2'd0: begin
                      BankAReg[48] <= Data0In;
                      BankAReg[55] <= Data1In;
                   end
                   2'd1: begin
                      BankAReg[49] <= Data0In;
                      BankAReg[54] <= Data1In;
                   end
                   2'd2: begin
                      BankAReg[50] <= Data0In;
                      BankAReg[53] <= Data1In;
                   end
                   2'd3: begin
                      BankAReg[51] <= Data0In;
                      BankAReg[52] <= Data1In;
                   end
                 endcase // case(DataInCount)
              end // case: 3'd6
              3'd7: begin
                 case(DataInCount)
                   2'd0: begin
                      BankAReg[56] <= Data0In;
                      BankAReg[63] <= Data1In;
                   end
                   2'd1: begin
                      BankAReg[57] <= Data0In;
                      BankAReg[62] <= Data1In;
                   end
                   2'd2: begin
                      BankAReg[58] <= Data0In;
                      BankAReg[61] <= Data1In;
                   end
                   2'd3: begin
                      BankAReg[59] <= Data0In;
                      BankAReg[60] <= Data1In;
                   end
                 endcase // case(DataInCount)
              end // case: 3'd7
            endcase // case(DataInPage)
         end // if (DataInEnable == 1'b1 & DataInBank == 1'b0)
      end // else: !if(!rst)
   end // always @ (posedge clk or negedge rst)
   
   reg [15:0] BankBReg [0:63];

   always @(posedge clk or negedge rst) begin
      if(!rst) begin
         BankBReg[0] <= 12'h000;
         BankBReg[1] <= 12'h000;
         BankBReg[2] <= 12'h000;
         BankBReg[3] <= 12'h000;
         BankBReg[4] <= 12'h000;
         BankBReg[5] <= 12'h000;
         BankBReg[6] <= 12'h000;
         BankBReg[7] <= 12'h000;
         BankBReg[8] <= 12'h000;
         BankBReg[9] <= 12'h000;
         BankBReg[10] <= 12'h000;
         BankBReg[11] <= 12'h000;
         BankBReg[12] <= 12'h000;
         BankBReg[13] <= 12'h000;
         BankBReg[14] <= 12'h000;
         BankBReg[15] <= 12'h000;
         BankBReg[16] <= 12'h000;
         BankBReg[17] <= 12'h000;
         BankBReg[18] <= 12'h000;
         BankBReg[19] <= 12'h000;
         BankBReg[20] <= 12'h000;
         BankBReg[21] <= 12'h000;
         BankBReg[22] <= 12'h000;
         BankBReg[23] <= 12'h000;
         BankBReg[24] <= 12'h000;
         BankBReg[25] <= 12'h000;
         BankBReg[26] <= 12'h000;
         BankBReg[27] <= 12'h000;
         BankBReg[28] <= 12'h000;
         BankBReg[29] <= 12'h000;
         BankBReg[30] <= 12'h000;
         BankBReg[31] <= 12'h000;
         BankBReg[32] <= 12'h000;
         BankBReg[33] <= 12'h000;
         BankBReg[34] <= 12'h000;
         BankBReg[35] <= 12'h000;
         BankBReg[36] <= 12'h000;
         BankBReg[37] <= 12'h000;
         BankBReg[38] <= 12'h000;
         BankBReg[39] <= 12'h000;
         BankBReg[40] <= 12'h000;
         BankBReg[41] <= 12'h000;
         BankBReg[42] <= 12'h000;
         BankBReg[43] <= 12'h000;
         BankBReg[44] <= 12'h000;
         BankBReg[45] <= 12'h000;
         BankBReg[46] <= 12'h000;
         BankBReg[47] <= 12'h000;
         BankBReg[48] <= 12'h000;
         BankBReg[49] <= 12'h000;
         BankBReg[50] <= 12'h000;
         BankBReg[51] <= 12'h000;
         BankBReg[52] <= 12'h000;
         BankBReg[53] <= 12'h000;
         BankBReg[54] <= 12'h000;
         BankBReg[55] <= 12'h000;
         BankBReg[56] <= 12'h000;
         BankBReg[57] <= 12'h000;
         BankBReg[58] <= 12'h000;
         BankBReg[59] <= 12'h000;
         BankBReg[60] <= 12'h000;
         BankBReg[61] <= 12'h000;
         BankBReg[62] <= 12'h000;
         BankBReg[63] <= 12'h000;
      end else begin // if (!rst)
         if(DataInEnable == 1'b1 & DataInBank == 1'b1) begin
            case(DataInPage)
              3'd0: begin
                 case(DataInCount)
                   2'd0: begin
                      BankBReg[0] <= Data0In;
                      BankBReg[7] <= Data1In;
                   end
                   2'd1: begin
                      BankBReg[1] <= Data0In;
                      BankBReg[6] <= Data1In;
                   end
                   2'd2: begin
                      BankBReg[2] <= Data0In;
                      BankBReg[5] <= Data1In;
                   end
                   2'd3: begin
                      BankBReg[3] <= Data0In;
                      BankBReg[4] <= Data1In;
                   end
                 endcase // case(DataInCount)
              end // case: 3'd0
              3'd1: begin
                 case(DataInCount)
                   2'd0: begin
                      BankBReg[8] <= Data0In;
                      BankBReg[15] <= Data1In;
                   end
                   2'd1: begin
                      BankBReg[9] <= Data0In;
                      BankBReg[14] <= Data1In;
                   end
                   2'd2: begin
                      BankBReg[10] <= Data0In;
                      BankBReg[13] <= Data1In;
                   end
                   2'd3: begin
                      BankBReg[11] <= Data0In;
                      BankBReg[12] <= Data1In;
                   end
                 endcase // case(DataInCount)
              end // case: 3'd1
              3'd2: begin
                 case(DataInCount)
                   2'd0: begin
                      BankBReg[16] <= Data0In;
                      BankBReg[23] <= Data1In;
                   end
                   2'd1: begin
                      BankBReg[17] <= Data0In;
                      BankBReg[22] <= Data1In;
                   end
                   2'd2: begin
                      BankBReg[18] <= Data0In;
                      BankBReg[21] <= Data1In;
                   end
                   2'd3: begin
                      BankBReg[19] <= Data0In;
                      BankBReg[20] <= Data1In;
                   end
                 endcase // case(DataInCount)
              end // case: 3'd2
              3'd3: begin
                 case(DataInCount)
                   2'd0: begin
                      BankBReg[24] <= Data0In;
                      BankBReg[31] <= Data1In;
                   end
                   2'd1: begin
                      BankBReg[25] <= Data0In;
                      BankBReg[30] <= Data1In;
                   end
                   2'd2: begin
                      BankBReg[26] <= Data0In;
                      BankBReg[29] <= Data1In;
                   end
                   2'd3: begin
                      BankBReg[27] <= Data0In;
                      BankBReg[28] <= Data1In;
                   end
                 endcase // case(DataInCount)
              end // case: 3'd3
              3'd4: begin
                 case(DataInCount)
                   2'd0: begin
                      BankBReg[32] <= Data0In;
                      BankBReg[39] <= Data1In;
                   end
                   2'd1: begin
                      BankBReg[33] <= Data0In;
                      BankBReg[38] <= Data1In;
                   end
                   2'd2: begin
                      BankBReg[34] <= Data0In;
                      BankBReg[37] <= Data1In;
                   end
                   2'd3: begin
                      BankBReg[35] <= Data0In;
                      BankBReg[36] <= Data1In;
                   end
                 endcase // case(DataInCount)
              end // case: 3'd4
              3'd5: begin
                 case(DataInCount)
                   2'd0: begin
                      BankBReg[40] <= Data0In;
                      BankBReg[47] <= Data1In;
                   end
                   2'd1: begin
                      BankBReg[41] <= Data0In;
                      BankBReg[46] <= Data1In;
                   end
                   2'd2: begin
                      BankBReg[42] <= Data0In;
                      BankBReg[45] <= Data1In;
                   end
                   2'd3: begin
                      BankBReg[43] <= Data0In;
                      BankBReg[44] <= Data1In;
                   end
                 endcase // case(DataInCount)
              end // case: 3'd5
              3'd6: begin
                 case(DataInCount)
                   2'd0: begin
                      BankBReg[48] <= Data0In;
                      BankBReg[55] <= Data1In;
                   end
                   2'd1: begin
                      BankBReg[49] <= Data0In;
                      BankBReg[54] <= Data1In;
                   end
                   2'd2: begin
                      BankBReg[50] <= Data0In;
                      BankBReg[53] <= Data1In;
                   end
                   2'd3: begin
                      BankBReg[51] <= Data0In;
                      BankBReg[52] <= Data1In;
                   end
                 endcase // case(DataInCount)
              end // case: 3'd6
              3'd7: begin
                 case(DataInCount)
                   2'd0: begin
                      BankBReg[56] <= Data0In;
                      BankBReg[63] <= Data1In;
                   end
                   2'd1: begin
                      BankBReg[57] <= Data0In;
                      BankBReg[62] <= Data1In;
                   end
                   2'd2: begin
                      BankBReg[58] <= Data0In;
                      BankBReg[61] <= Data1In;
                   end
                   2'd3: begin
                      BankBReg[59] <= Data0In;
                      BankBReg[60] <= Data1In;
                   end
                 endcase // case(DataInCount)
              end // case: 3'd7
            endcase // case(DataInPage)
         end // if (DataInEnable == 1'b1 & DataInBank == 1'b1)
      end // else: !if(!rst)
   end // always @ (posedge clk or negedge rst)

   assign Data00Out = (DataOutSel)?BankBReg[00]:BankAReg[00];
   assign Data01Out = (DataOutSel)?BankBReg[08]:BankAReg[08];
   assign Data02Out = (DataOutSel)?BankBReg[16]:BankAReg[16];
   assign Data03Out = (DataOutSel)?BankBReg[24]:BankAReg[24];
   assign Data04Out = (DataOutSel)?BankBReg[32]:BankAReg[32];
   assign Data05Out = (DataOutSel)?BankBReg[40]:BankAReg[40];
   assign Data06Out = (DataOutSel)?BankBReg[48]:BankAReg[48];
   assign Data07Out = (DataOutSel)?BankBReg[56]:BankAReg[56];
   assign Data08Out = (DataOutSel)?BankBReg[01]:BankAReg[01];
   assign Data09Out = (DataOutSel)?BankBReg[09]:BankAReg[09];
   assign Data10Out = (DataOutSel)?BankBReg[17]:BankAReg[17];
   assign Data11Out = (DataOutSel)?BankBReg[25]:BankAReg[25];
   assign Data12Out = (DataOutSel)?BankBReg[33]:BankAReg[33];
   assign Data13Out = (DataOutSel)?BankBReg[41]:BankAReg[41];
   assign Data14Out = (DataOutSel)?BankBReg[49]:BankAReg[49];
   assign Data15Out = (DataOutSel)?BankBReg[57]:BankAReg[57];
   assign Data16Out = (DataOutSel)?BankBReg[02]:BankAReg[02];
   assign Data17Out = (DataOutSel)?BankBReg[10]:BankAReg[10];
   assign Data18Out = (DataOutSel)?BankBReg[18]:BankAReg[18];
   assign Data19Out = (DataOutSel)?BankBReg[26]:BankAReg[26];
   assign Data20Out = (DataOutSel)?BankBReg[34]:BankAReg[34];
   assign Data21Out = (DataOutSel)?BankBReg[42]:BankAReg[42];
   assign Data22Out = (DataOutSel)?BankBReg[50]:BankAReg[50];
   assign Data23Out = (DataOutSel)?BankBReg[58]:BankAReg[58];
   assign Data24Out = (DataOutSel)?BankBReg[03]:BankAReg[03];
   assign Data25Out = (DataOutSel)?BankBReg[11]:BankAReg[11];
   assign Data26Out = (DataOutSel)?BankBReg[19]:BankAReg[19];
   assign Data27Out = (DataOutSel)?BankBReg[27]:BankAReg[27];
   assign Data28Out = (DataOutSel)?BankBReg[35]:BankAReg[35];
   assign Data29Out = (DataOutSel)?BankBReg[43]:BankAReg[43];
   assign Data30Out = (DataOutSel)?BankBReg[51]:BankAReg[51];
   assign Data31Out = (DataOutSel)?BankBReg[59]:BankAReg[59];
   assign Data32Out = (DataOutSel)?BankBReg[04]:BankAReg[04];
   assign Data33Out = (DataOutSel)?BankBReg[12]:BankAReg[12];
   assign Data34Out = (DataOutSel)?BankBReg[20]:BankAReg[20];
   assign Data35Out = (DataOutSel)?BankBReg[28]:BankAReg[28];
   assign Data36Out = (DataOutSel)?BankBReg[36]:BankAReg[36];
   assign Data37Out = (DataOutSel)?BankBReg[44]:BankAReg[44];
   assign Data38Out = (DataOutSel)?BankBReg[52]:BankAReg[52];
   assign Data39Out = (DataOutSel)?BankBReg[60]:BankAReg[60];
   assign Data40Out = (DataOutSel)?BankBReg[05]:BankAReg[05];
   assign Data41Out = (DataOutSel)?BankBReg[13]:BankAReg[13];
   assign Data42Out = (DataOutSel)?BankBReg[21]:BankAReg[21];
   assign Data43Out = (DataOutSel)?BankBReg[29]:BankAReg[29];
   assign Data44Out = (DataOutSel)?BankBReg[37]:BankAReg[37];
   assign Data45Out = (DataOutSel)?BankBReg[45]:BankAReg[45];
   assign Data46Out = (DataOutSel)?BankBReg[53]:BankAReg[53];
   assign Data47Out = (DataOutSel)?BankBReg[61]:BankAReg[61];
   assign Data48Out = (DataOutSel)?BankBReg[06]:BankAReg[06];
   assign Data49Out = (DataOutSel)?BankBReg[14]:BankAReg[14];
   assign Data50Out = (DataOutSel)?BankBReg[22]:BankAReg[22];
   assign Data51Out = (DataOutSel)?BankBReg[30]:BankAReg[30];
   assign Data52Out = (DataOutSel)?BankBReg[38]:BankAReg[38];
   assign Data53Out = (DataOutSel)?BankBReg[46]:BankAReg[46];
   assign Data54Out = (DataOutSel)?BankBReg[54]:BankAReg[54];
   assign Data55Out = (DataOutSel)?BankBReg[62]:BankAReg[62];
   assign Data56Out = (DataOutSel)?BankBReg[07]:BankAReg[07];
   assign Data57Out = (DataOutSel)?BankBReg[15]:BankAReg[15];
   assign Data58Out = (DataOutSel)?BankBReg[23]:BankAReg[23];
   assign Data59Out = (DataOutSel)?BankBReg[31]:BankAReg[31];
   assign Data60Out = (DataOutSel)?BankBReg[39]:BankAReg[39];
   assign Data61Out = (DataOutSel)?BankBReg[47]:BankAReg[47];
   assign Data62Out = (DataOutSel)?BankBReg[55]:BankAReg[55];
   assign Data63Out = (DataOutSel)?BankBReg[63]:BankAReg[63];

endmodule // jpeg_idctb
