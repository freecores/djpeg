//---------------------------------------------------------------------------
// File Name   : jpeg_ziguzagu.v
// Module Name : jpeg_ziguzagu
// Description : Ziguzagu
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

module jpeg_ziguzagu
  (
   rst,
   clk,

   DataInEnable,
   DataInAddress,
   DataInColor,
   DataInIdle,
   DataIn,

   HaffumanEndEnable,

   DataOutEnable,
   DataOutColor,
   DataOutSel,
   Data00Reg,
   Data01Reg,
   Data02Reg,
   Data03Reg,
   Data04Reg,
   Data05Reg,
   Data06Reg,
   Data07Reg,
   Data08Reg,
   Data09Reg,
   Data10Reg,
   Data11Reg,
   Data12Reg,
   Data13Reg,
   Data14Reg,
   Data15Reg,
   Data16Reg,
   Data17Reg,
   Data18Reg,
   Data19Reg,
   Data20Reg,
   Data21Reg,
   Data22Reg,
   Data23Reg,
   Data24Reg,
   Data25Reg,
   Data26Reg,
   Data27Reg,
   Data28Reg,
   Data29Reg,
   Data30Reg,
   Data31Reg,
   Data32Reg,
   Data33Reg,
   Data34Reg,
   Data35Reg,
   Data36Reg,
   Data37Reg,
   Data38Reg,
   Data39Reg,
   Data40Reg,
   Data41Reg,
   Data42Reg,
   Data43Reg,
   Data44Reg,
   Data45Reg,
   Data46Reg,
   Data47Reg,
   Data48Reg,
   Data49Reg,
   Data50Reg,
   Data51Reg,
   Data52Reg,
   Data53Reg,
   Data54Reg,
   Data55Reg,
   Data56Reg,
   Data57Reg,
   Data58Reg,
   Data59Reg,
   Data60Reg,
   Data61Reg,
   Data62Reg,
   Data63Reg,

   BankARelease,
   BankBRelease
   );

   input         clk;
   input         rst;

   input 	 DataInEnable;
   input [5:0] 	 DataInAddress;
   input [2:0] 	 DataInColor;
   output 	 DataInIdle;
   input [15:0]  DataIn;

   input 	 HaffumanEndEnable;

   output 	 DataOutEnable;
   output [2:0]	 DataOutColor;
   input 	 DataOutSel;
   output [15:0] Data00Reg;
   output [15:0] Data01Reg;
   output [15:0] Data02Reg;
   output [15:0] Data03Reg;
   output [15:0] Data04Reg;
   output [15:0] Data05Reg;
   output [15:0] Data06Reg;
   output [15:0] Data07Reg;
   output [15:0] Data08Reg;
   output [15:0] Data09Reg;
   output [15:0] Data10Reg;
   output [15:0] Data11Reg;
   output [15:0] Data12Reg;
   output [15:0] Data13Reg;
   output [15:0] Data14Reg;
   output [15:0] Data15Reg;
   output [15:0] Data16Reg;
   output [15:0] Data17Reg;
   output [15:0] Data18Reg;
   output [15:0] Data19Reg;
   output [15:0] Data20Reg;
   output [15:0] Data21Reg;
   output [15:0] Data22Reg;
   output [15:0] Data23Reg;
   output [15:0] Data24Reg;
   output [15:0] Data25Reg;
   output [15:0] Data26Reg;
   output [15:0] Data27Reg;
   output [15:0] Data28Reg;
   output [15:0] Data29Reg;
   output [15:0] Data30Reg;
   output [15:0] Data31Reg;
   output [15:0] Data32Reg;
   output [15:0] Data33Reg;
   output [15:0] Data34Reg;
   output [15:0] Data35Reg;
   output [15:0] Data36Reg;
   output [15:0] Data37Reg;
   output [15:0] Data38Reg;
   output [15:0] Data39Reg;
   output [15:0] Data40Reg;
   output [15:0] Data41Reg;
   output [15:0] Data42Reg;
   output [15:0] Data43Reg;
   output [15:0] Data44Reg;
   output [15:0] Data45Reg;
   output [15:0] Data46Reg;
   output [15:0] Data47Reg;
   output [15:0] Data48Reg;
   output [15:0] Data49Reg;
   output [15:0] Data50Reg;
   output [15:0] Data51Reg;
   output [15:0] Data52Reg;
   output [15:0] Data53Reg;
   output [15:0] Data54Reg;
   output [15:0] Data55Reg;
   output [15:0] Data56Reg;
   output [15:0] Data57Reg;
   output [15:0] Data58Reg;
   output [15:0] Data59Reg;
   output [15:0] Data60Reg;
   output [15:0] Data61Reg;
   output [15:0] Data62Reg;
   output [15:0] Data63Reg;
   input         BankARelease;
   input         BankBRelease;
   
   reg           BankAEnable;
   reg           BankBEnable;
   reg           DataInBank;

   reg [2:0] 	 BankAColor;
   reg [2:0] 	 BankBColor;
   
   always @(posedge clk or negedge rst) begin
      if(!rst) begin
         BankAEnable <= 1'b0;
         BankBEnable <= 1'b0;
	 BankAColor  <= 3'b000;
	 BankBColor  <= 3'b000;
         DataInBank  <= 1'b0;
      end else begin
         if(BankAEnable == 1'b0 & DataInBank == 1'b0) begin
            if(HaffumanEndEnable == 1'b1 & DataInIdle == 1'b1) begin
               BankAEnable <= 1'b1;
	       BankAColor  <= DataInColor;
            end
         end else begin
            if(BankARelease == 1'b1) begin
               BankAEnable <= 1'b0;
            end
         end
         if(BankBEnable == 1'b0 & DataInBank == 1'b1) begin
            if(HaffumanEndEnable == 1'b1 & DataInIdle == 1'b1) begin
               BankBEnable <= 1'b1;
	       BankBColor  <= DataInColor;
            end
         end else begin
            if(BankBRelease == 1'b1) begin
               BankBEnable <= 1'b0;
            end
         end
         if(HaffumanEndEnable == 1'b1) begin
            DataInBank   <= ~DataInBank;
         end
      end // else: !if(!rst)
   end // always @ (posedge clk or negedge rst)

   assign DataInIdle = BankAEnable == 1'b0 | BankBEnable == 1'b0;
   assign DataOutEnable = BankAEnable == 1'b1 | BankBEnable == 1'b1;
   assign DataOutColor  = (DataInBank)?BankBColor:BankAColor;

   wire   ZigAEnable;
   wire   ZigBEnable;
   
   wire [15:0] BankA00Reg;
   wire [15:0] BankA01Reg;
   wire [15:0] BankA02Reg;
   wire [15:0] BankA03Reg;
   wire [15:0] BankA04Reg;
   wire [15:0] BankA05Reg;
   wire [15:0] BankA06Reg;
   wire [15:0] BankA07Reg;
   wire [15:0] BankA08Reg;
   wire [15:0] BankA09Reg;
   wire [15:0] BankA10Reg;
   wire [15:0] BankA11Reg;
   wire [15:0] BankA12Reg;
   wire [15:0] BankA13Reg;
   wire [15:0] BankA14Reg;
   wire [15:0] BankA15Reg;
   wire [15:0] BankA16Reg;
   wire [15:0] BankA17Reg;
   wire [15:0] BankA18Reg;
   wire [15:0] BankA19Reg;
   wire [15:0] BankA20Reg;
   wire [15:0] BankA21Reg;
   wire [15:0] BankA22Reg;
   wire [15:0] BankA23Reg;
   wire [15:0] BankA24Reg;
   wire [15:0] BankA25Reg;
   wire [15:0] BankA26Reg;
   wire [15:0] BankA27Reg;
   wire [15:0] BankA28Reg;
   wire [15:0] BankA29Reg;
   wire [15:0] BankA30Reg;
   wire [15:0] BankA31Reg;
   wire [15:0] BankA32Reg;
   wire [15:0] BankA33Reg;
   wire [15:0] BankA34Reg;
   wire [15:0] BankA35Reg;
   wire [15:0] BankA36Reg;
   wire [15:0] BankA37Reg;
   wire [15:0] BankA38Reg;
   wire [15:0] BankA39Reg;
   wire [15:0] BankA40Reg;
   wire [15:0] BankA41Reg;
   wire [15:0] BankA42Reg;
   wire [15:0] BankA43Reg;
   wire [15:0] BankA44Reg;
   wire [15:0] BankA45Reg;
   wire [15:0] BankA46Reg;
   wire [15:0] BankA47Reg;
   wire [15:0] BankA48Reg;
   wire [15:0] BankA49Reg;
   wire [15:0] BankA50Reg;
   wire [15:0] BankA51Reg;
   wire [15:0] BankA52Reg;
   wire [15:0] BankA53Reg;
   wire [15:0] BankA54Reg;
   wire [15:0] BankA55Reg;
   wire [15:0] BankA56Reg;
   wire [15:0] BankA57Reg;
   wire [15:0] BankA58Reg;
   wire [15:0] BankA59Reg;
   wire [15:0] BankA60Reg;
   wire [15:0] BankA61Reg;
   wire [15:0] BankA62Reg;
   wire [15:0] BankA63Reg;

   wire [15:0] BankB00Reg;
   wire [15:0] BankB01Reg;
   wire [15:0] BankB02Reg;
   wire [15:0] BankB03Reg;
   wire [15:0] BankB04Reg;
   wire [15:0] BankB05Reg;
   wire [15:0] BankB06Reg;
   wire [15:0] BankB07Reg;
   wire [15:0] BankB08Reg;
   wire [15:0] BankB09Reg;
   wire [15:0] BankB10Reg;
   wire [15:0] BankB11Reg;
   wire [15:0] BankB12Reg;
   wire [15:0] BankB13Reg;
   wire [15:0] BankB14Reg;
   wire [15:0] BankB15Reg;
   wire [15:0] BankB16Reg;
   wire [15:0] BankB17Reg;
   wire [15:0] BankB18Reg;
   wire [15:0] BankB19Reg;
   wire [15:0] BankB20Reg;
   wire [15:0] BankB21Reg;
   wire [15:0] BankB22Reg;
   wire [15:0] BankB23Reg;
   wire [15:0] BankB24Reg;
   wire [15:0] BankB25Reg;
   wire [15:0] BankB26Reg;
   wire [15:0] BankB27Reg;
   wire [15:0] BankB28Reg;
   wire [15:0] BankB29Reg;
   wire [15:0] BankB30Reg;
   wire [15:0] BankB31Reg;
   wire [15:0] BankB32Reg;
   wire [15:0] BankB33Reg;
   wire [15:0] BankB34Reg;
   wire [15:0] BankB35Reg;
   wire [15:0] BankB36Reg;
   wire [15:0] BankB37Reg;
   wire [15:0] BankB38Reg;
   wire [15:0] BankB39Reg;
   wire [15:0] BankB40Reg;
   wire [15:0] BankB41Reg;
   wire [15:0] BankB42Reg;
   wire [15:0] BankB43Reg;
   wire [15:0] BankB44Reg;
   wire [15:0] BankB45Reg;
   wire [15:0] BankB46Reg;
   wire [15:0] BankB47Reg;
   wire [15:0] BankB48Reg;
   wire [15:0] BankB49Reg;
   wire [15:0] BankB50Reg;
   wire [15:0] BankB51Reg;
   wire [15:0] BankB52Reg;
   wire [15:0] BankB53Reg;
   wire [15:0] BankB54Reg;
   wire [15:0] BankB55Reg;
   wire [15:0] BankB56Reg;
   wire [15:0] BankB57Reg;
   wire [15:0] BankB58Reg;
   wire [15:0] BankB59Reg;
   wire [15:0] BankB60Reg;
   wire [15:0] BankB61Reg;
   wire [15:0] BankB62Reg;
   wire [15:0] BankB63Reg;

   assign      ZigAEnable = DataInEnable == 1'b1 & DataInBank == 1'b0;
   assign      ZigBEnable = DataInEnable == 1'b1 & DataInBank == 1'b1;
   
   jpeg_ziguzagu_reg u_jpeg_ziguzagu_reg0(
				 .rst(rst),
				 .clk(clk),
				 
				 .DataInEnable  ( ZigAEnable ),
				 .DataInAddress ( DataInAddress ),
				 .DataIn        ( DataIn  ),
				 
				 .Data00Reg( BankA00Reg ),
				 .Data01Reg( BankA01Reg ),
				 .Data02Reg( BankA02Reg ),
				 .Data03Reg( BankA03Reg ),
				 .Data04Reg( BankA04Reg ),
				 .Data05Reg( BankA05Reg ),
				 .Data06Reg( BankA06Reg ),
				 .Data07Reg( BankA07Reg ),
				 .Data08Reg( BankA08Reg ),
				 .Data09Reg( BankA09Reg ),
				 .Data10Reg( BankA10Reg ),
				 .Data11Reg( BankA11Reg ),
				 .Data12Reg( BankA12Reg ),
				 .Data13Reg( BankA13Reg ),
				 .Data14Reg( BankA14Reg ),
				 .Data15Reg( BankA15Reg ),
				 .Data16Reg( BankA16Reg ),
				 .Data17Reg( BankA17Reg ),
				 .Data18Reg( BankA18Reg ),
				 .Data19Reg( BankA19Reg ),
				 .Data20Reg( BankA20Reg ),
				 .Data21Reg( BankA21Reg ),
				 .Data22Reg( BankA22Reg ),
				 .Data23Reg( BankA23Reg ),
				 .Data24Reg( BankA24Reg ),
				 .Data25Reg( BankA25Reg ),
				 .Data26Reg( BankA26Reg ),
				 .Data27Reg( BankA27Reg ),
				 .Data28Reg( BankA28Reg ),
				 .Data29Reg( BankA29Reg ),
				 .Data30Reg( BankA30Reg ),
				 .Data31Reg( BankA31Reg ),
				 .Data32Reg( BankA32Reg ),
				 .Data33Reg( BankA33Reg ),
				 .Data34Reg( BankA34Reg ),
				 .Data35Reg( BankA35Reg ),
				 .Data36Reg( BankA36Reg ),
				 .Data37Reg( BankA37Reg ),
				 .Data38Reg( BankA38Reg ),
				 .Data39Reg( BankA39Reg ),
				 .Data40Reg( BankA40Reg ),
				 .Data41Reg( BankA41Reg ),
				 .Data42Reg( BankA42Reg ),
				 .Data43Reg( BankA43Reg ),
				 .Data44Reg( BankA44Reg ),
				 .Data45Reg( BankA45Reg ),
				 .Data46Reg( BankA46Reg ),
				 .Data47Reg( BankA47Reg ),
				 .Data48Reg( BankA48Reg ),
				 .Data49Reg( BankA49Reg ),
				 .Data50Reg( BankA50Reg ),
				 .Data51Reg( BankA51Reg ),
				 .Data52Reg( BankA52Reg ),
				 .Data53Reg( BankA53Reg ),
				 .Data54Reg( BankA54Reg ),
				 .Data55Reg( BankA55Reg ),
				 .Data56Reg( BankA56Reg ),
				 .Data57Reg( BankA57Reg ),
				 .Data58Reg( BankA58Reg ),
				 .Data59Reg( BankA59Reg ),
				 .Data60Reg( BankA60Reg ),
				 .Data61Reg( BankA61Reg ),
				 .Data62Reg( BankA62Reg ),
				 .Data63Reg( BankA63Reg )
				 );
   
   jpeg_ziguzagu_reg u_jpeg_ziguzagu_reg1(
				 .rst(rst),
				 .clk(clk),
				 
				 .DataInEnable  ( ZigBEnable ),
				 .DataInAddress ( DataInAddress  ),
				 .DataIn        ( DataIn   ),
				 
				 .Data00Reg( BankB00Reg ),
				 .Data01Reg( BankB01Reg ),
				 .Data02Reg( BankB02Reg ),
				 .Data03Reg( BankB03Reg ),
				 .Data04Reg( BankB04Reg ),
				 .Data05Reg( BankB05Reg ),
				 .Data06Reg( BankB06Reg ),
				 .Data07Reg( BankB07Reg ),
				 .Data08Reg( BankB08Reg ),
				 .Data09Reg( BankB09Reg ),
				 .Data10Reg( BankB10Reg ),
				 .Data11Reg( BankB11Reg ),
				 .Data12Reg( BankB12Reg ),
				 .Data13Reg( BankB13Reg ),
				 .Data14Reg( BankB14Reg ),
				 .Data15Reg( BankB15Reg ),
				 .Data16Reg( BankB16Reg ),
				 .Data17Reg( BankB17Reg ),
				 .Data18Reg( BankB18Reg ),
				 .Data19Reg( BankB19Reg ),
				 .Data20Reg( BankB20Reg ),
				 .Data21Reg( BankB21Reg ),
				 .Data22Reg( BankB22Reg ),
				 .Data23Reg( BankB23Reg ),
				 .Data24Reg( BankB24Reg ),
				 .Data25Reg( BankB25Reg ),
				 .Data26Reg( BankB26Reg ),
				 .Data27Reg( BankB27Reg ),
				 .Data28Reg( BankB28Reg ),
				 .Data29Reg( BankB29Reg ),
				 .Data30Reg( BankB30Reg ),
				 .Data31Reg( BankB31Reg ),
				 .Data32Reg( BankB32Reg ),
				 .Data33Reg( BankB33Reg ),
				 .Data34Reg( BankB34Reg ),
				 .Data35Reg( BankB35Reg ),
				 .Data36Reg( BankB36Reg ),
				 .Data37Reg( BankB37Reg ),
				 .Data38Reg( BankB38Reg ),
				 .Data39Reg( BankB39Reg ),
				 .Data40Reg( BankB40Reg ),
				 .Data41Reg( BankB41Reg ),
				 .Data42Reg( BankB42Reg ),
				 .Data43Reg( BankB43Reg ),
				 .Data44Reg( BankB44Reg ),
				 .Data45Reg( BankB45Reg ),
				 .Data46Reg( BankB46Reg ),
				 .Data47Reg( BankB47Reg ),
				 .Data48Reg( BankB48Reg ),
				 .Data49Reg( BankB49Reg ),
				 .Data50Reg( BankB50Reg ),
				 .Data51Reg( BankB51Reg ),
				 .Data52Reg( BankB52Reg ),
				 .Data53Reg( BankB53Reg ),
				 .Data54Reg( BankB54Reg ),
				 .Data55Reg( BankB55Reg ),
				 .Data56Reg( BankB56Reg ),
				 .Data57Reg( BankB57Reg ),
				 .Data58Reg( BankB58Reg ),
				 .Data59Reg( BankB59Reg ),
				 .Data60Reg( BankB60Reg ),
				 .Data61Reg( BankB61Reg ),
				 .Data62Reg( BankB62Reg ),
				 .Data63Reg( BankB63Reg )
				 );

   assign      Data00Reg = (DataOutSel)?BankB00Reg:BankA00Reg;
   assign      Data01Reg = (DataOutSel)?BankB01Reg:BankA01Reg;
   assign      Data02Reg = (DataOutSel)?BankB02Reg:BankA02Reg;
   assign      Data03Reg = (DataOutSel)?BankB03Reg:BankA03Reg;
   assign      Data04Reg = (DataOutSel)?BankB04Reg:BankA04Reg;
   assign      Data05Reg = (DataOutSel)?BankB05Reg:BankA05Reg;
   assign      Data06Reg = (DataOutSel)?BankB06Reg:BankA06Reg;
   assign      Data07Reg = (DataOutSel)?BankB07Reg:BankA07Reg;
   assign      Data08Reg = (DataOutSel)?BankB08Reg:BankA08Reg;
   assign      Data09Reg = (DataOutSel)?BankB09Reg:BankA09Reg;
   assign      Data10Reg = (DataOutSel)?BankB10Reg:BankA10Reg;
   assign      Data11Reg = (DataOutSel)?BankB11Reg:BankA11Reg;
   assign      Data12Reg = (DataOutSel)?BankB12Reg:BankA12Reg;
   assign      Data13Reg = (DataOutSel)?BankB13Reg:BankA13Reg;
   assign      Data14Reg = (DataOutSel)?BankB14Reg:BankA14Reg;
   assign      Data15Reg = (DataOutSel)?BankB15Reg:BankA15Reg;
   assign      Data16Reg = (DataOutSel)?BankB16Reg:BankA16Reg;
   assign      Data17Reg = (DataOutSel)?BankB17Reg:BankA17Reg;
   assign      Data18Reg = (DataOutSel)?BankB18Reg:BankA18Reg;
   assign      Data19Reg = (DataOutSel)?BankB19Reg:BankA19Reg;
   assign      Data20Reg = (DataOutSel)?BankB20Reg:BankA20Reg;
   assign      Data21Reg = (DataOutSel)?BankB21Reg:BankA21Reg;
   assign      Data22Reg = (DataOutSel)?BankB22Reg:BankA22Reg;
   assign      Data23Reg = (DataOutSel)?BankB23Reg:BankA23Reg;
   assign      Data24Reg = (DataOutSel)?BankB24Reg:BankA24Reg;
   assign      Data25Reg = (DataOutSel)?BankB25Reg:BankA25Reg;
   assign      Data26Reg = (DataOutSel)?BankB26Reg:BankA26Reg;
   assign      Data27Reg = (DataOutSel)?BankB27Reg:BankA27Reg;
   assign      Data28Reg = (DataOutSel)?BankB28Reg:BankA28Reg;
   assign      Data29Reg = (DataOutSel)?BankB29Reg:BankA29Reg;
   assign      Data30Reg = (DataOutSel)?BankB30Reg:BankA30Reg;
   assign      Data31Reg = (DataOutSel)?BankB31Reg:BankA31Reg;
   assign      Data32Reg = (DataOutSel)?BankB32Reg:BankA32Reg;
   assign      Data33Reg = (DataOutSel)?BankB33Reg:BankA33Reg;
   assign      Data34Reg = (DataOutSel)?BankB34Reg:BankA34Reg;
   assign      Data35Reg = (DataOutSel)?BankB35Reg:BankA35Reg;
   assign      Data36Reg = (DataOutSel)?BankB36Reg:BankA36Reg;
   assign      Data37Reg = (DataOutSel)?BankB37Reg:BankA37Reg;
   assign      Data38Reg = (DataOutSel)?BankB38Reg:BankA38Reg;
   assign      Data39Reg = (DataOutSel)?BankB39Reg:BankA39Reg;
   assign      Data40Reg = (DataOutSel)?BankB40Reg:BankA40Reg;
   assign      Data41Reg = (DataOutSel)?BankB41Reg:BankA41Reg;
   assign      Data42Reg = (DataOutSel)?BankB42Reg:BankA42Reg;
   assign      Data43Reg = (DataOutSel)?BankB43Reg:BankA43Reg;
   assign      Data44Reg = (DataOutSel)?BankB44Reg:BankA44Reg;
   assign      Data45Reg = (DataOutSel)?BankB45Reg:BankA45Reg;
   assign      Data46Reg = (DataOutSel)?BankB46Reg:BankA46Reg;
   assign      Data47Reg = (DataOutSel)?BankB47Reg:BankA47Reg;
   assign      Data48Reg = (DataOutSel)?BankB48Reg:BankA48Reg;
   assign      Data49Reg = (DataOutSel)?BankB49Reg:BankA49Reg;
   assign      Data50Reg = (DataOutSel)?BankB50Reg:BankA50Reg;
   assign      Data51Reg = (DataOutSel)?BankB51Reg:BankA51Reg;
   assign      Data52Reg = (DataOutSel)?BankB52Reg:BankA52Reg;
   assign      Data53Reg = (DataOutSel)?BankB53Reg:BankA53Reg;
   assign      Data54Reg = (DataOutSel)?BankB54Reg:BankA54Reg;
   assign      Data55Reg = (DataOutSel)?BankB55Reg:BankA55Reg;
   assign      Data56Reg = (DataOutSel)?BankB56Reg:BankA56Reg;
   assign      Data57Reg = (DataOutSel)?BankB57Reg:BankA57Reg;
   assign      Data58Reg = (DataOutSel)?BankB58Reg:BankA58Reg;
   assign      Data59Reg = (DataOutSel)?BankB59Reg:BankA59Reg;
   assign      Data60Reg = (DataOutSel)?BankB60Reg:BankA60Reg;
   assign      Data61Reg = (DataOutSel)?BankB61Reg:BankA61Reg;
   assign      Data62Reg = (DataOutSel)?BankB62Reg:BankA62Reg;
   assign      Data63Reg = (DataOutSel)?BankB63Reg:BankA63Reg;
   
endmodule // jpeg_ziguzagu
