//---------------------------------------------------------------------------
// File Name   : jpeg_haffuman.v
// Module Name : jpeg_haffuman
// Description : Haffuam top module
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

module jpeg_haffuman
  (
   rst,
   clk,

   // DQT Table
   DqtInEnable,
   DqtInColor,
   DqtInCount,
   DqtInData,

   // DHT Table
   DhtInEnable,
   DhtInColor,
   DhtInCount,
   DhtInData,
   
   // Haffuman Table   
   HaffumanTableEnable, // Table Data In Enable
   HaffumanTableColor,  // Haffuman Table Color Number
   HaffumanTableCount,  // Table Number
   HaffumanTableCode,   // Haffuman Table Code
   HaffumanTableStart,  // Haffuman Table Start Number

   // Haffuman Decode
   DataInRun,           // Data In Start
   DataInEnable,        // Data In Enable
   DataIn,              // Data In

   DecodeUseBit,        // Used Data Bit
   DecodeUseWidth,      // Used Data Width

   // Data Out
   DataOutIdle,
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
   DataOutRelease

   );

   input        rst;
   input 	clk;

   // DQT Table
   input 	DqtInEnable;
   input 	DqtInColor;
   input [5:0] 	DqtInCount;
   input [7:0] 	DqtInData;

   // DHT Table
   input 	DhtInEnable;
   input [1:0] 	DhtInColor;
   input [7:0] 	DhtInCount;
   input [7:0] 	DhtInData;

   input         HaffumanTableEnable; // Table Data In Enable
   input [1:0]   HaffumanTableColor;
   input [3:0]   HaffumanTableCount;  // Table Number
   input [15:0]  HaffumanTableCode;   // Haffuman Table Data
   input [7:0]   HaffumanTableStart;  // Haffuman Table Start Number

   input 	 DataInRun;
   input         DataInEnable;        // Data In Enable
   input [31:0]  DataIn;              // Data In

   output 	DecodeUseBit;
   output [6:0] DecodeUseWidth;

   // Data Out
   input 	DataOutIdle;
   output 	DataOutEnable;
   output [2:0] DataOutColor;
   input 	DataOutSel;
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
   input         DataOutRelease;
   
   wire   HmDqtColor;
   wire [5:0] HmDqtNumber;
   wire [7:0] HmDqtData;
   
   // DQT Table
   jpeg_dqt u_jpeg_dqt(
		       .rst(rst),
		       .clk(clk),

		       .DataInEnable ( DqtInEnable     ),
		       .DataInColor  ( DqtInColor      ),
		       .DataInCount  ( DqtInCount[5:0] ),
		       .DataIn       ( DqtInData       ),
		       
		       .TableColor   ( HmDqtColor  ),
		       .TableNumber  ( HmDqtNumber ),
		       .TableData    ( HmDqtData   )
		       );

   wire [1:0]	  HmDhtColor;
   wire [7:0] 	  HmDhtNumber;
   wire [3:0] 	  HmDhtZero;
   wire [3:0] 	  HmDhtWidth;
   
   jpeg_dht u_jpeg_dht(
		       .rst(rst),
		       .clk(clk),

		       .DataInEnable ( DhtInEnable ),
		       .DataInColor  ( DhtInColor  ),
		       .DataInCount  ( DhtInCount  ),
		       .DataIn       ( DhtInData   ),
		       
		       .ColorNumber  ( HmDhtColor    ),
		       .TableNumber  ( HmDhtNumber   ),
		       .ZeroTable    ( HmDhtZero     ),
		       .WidhtTable   ( HmDhtWidth    )
		       );
   
   //wire [2:0]	  HmDecColor;
   wire [5:0] 	  HmDecCount;
   wire [15:0] 	  HmDecData;

   wire 	  HmOutEnable;
   wire [2:0]	  HmOutColor;
   
   jpeg_hm_decode u_jpeg_hm_decode(
				   .rst(rst),
				   .clk(clk),

				   // Haffuman Table   
				   .HaffumanTableEnable ( HaffumanTableEnable  ),
				   .HaffumanTableColor  ( HaffumanTableColor ),
				   .HaffumanTableCount  ( HaffumanTableCount ),
				   .HaffumanTableCode   ( HaffumanTableCode  ),
				   .HaffumanTableStart  ( HaffumanTableStart ),

				   // Haffuman Decode
				   .DataInRun      ( DataInRun    ),
				   .DataInEnable   ( DataInEnable ),
				   .DataIn         ( DataIn       ),

				   // Haffuman Table List
				   .DhtColor      ( HmDhtColor  ),
				   .DhtNumber     ( HmDhtNumber ),
				   .DhtZero       ( HmDhtZero   ),
				   .DhtWidth      ( HmDhtWidth  ),

				   // DQT Table
				   .DqtColor       ( HmDqtColor  ),
				   .DqtNumber      ( HmDqtNumber ),
				   .DqtData        ( HmDqtData   ),

				   .DataOutIdle    ( HmOutIdle ),
				   .DataOutEnable  ( HmOutEnable ),
				   .DataOutColor   ( HmOutColor ),
				   
				   // Output decode data   
				   .DecodeUseBit   ( DecodeUseBit   ),
				   .DecodeUseWidth ( DecodeUseWidth ),

				   .DecodeEnable   ( HmDecEnable ),
				   .DecodeColor    ( ),
				   .DecodeCount    ( HmDecCount  ),
				   .DecodeZero     ( ),
				   .DecodeCode     ( HmDecData   )
				   );

   wire BankARelease;
   wire BankBRelease;
   
   assign         BankARelease = DataOutSel == 1'b0 & DataOutRelease;
   assign         BankBRelease = DataOutSel == 1'b1 & DataOutRelease;

   
   jpeg_ziguzagu u_jpeg_ziguzagu(
				 .rst(rst),
				 .clk(clk),
				 
				 .DataInEnable  ( HmDecEnable ),
				 .DataInAddress ( HmDecCount  ),
				 .DataInColor   ( HmOutColor  ),
				 .DataInIdle    ( HmOutIdle   ),
				 .DataIn        ( HmDecData   ),
				 
				 .HaffumanEndEnable(HmOutEnable),

				 .DataOutEnable( DataOutEnable),
				 .DataOutColor ( DataOutColor),
				 .DataOutSel(DataOutSel),
				 .Data00Reg( Data00Reg ),
				 .Data01Reg( Data01Reg ),
				 .Data02Reg( Data02Reg ),
				 .Data03Reg( Data03Reg ),
				 .Data04Reg( Data04Reg ),
				 .Data05Reg( Data05Reg ),
				 .Data06Reg( Data06Reg ),
				 .Data07Reg( Data07Reg ),
				 .Data08Reg( Data08Reg ),
				 .Data09Reg( Data09Reg ),
				 .Data10Reg( Data10Reg ),
				 .Data11Reg( Data11Reg ),
				 .Data12Reg( Data12Reg ),
				 .Data13Reg( Data13Reg ),
				 .Data14Reg( Data14Reg ),
				 .Data15Reg( Data15Reg ),
				 .Data16Reg( Data16Reg ),
				 .Data17Reg( Data17Reg ),
				 .Data18Reg( Data18Reg ),
				 .Data19Reg( Data19Reg ),
				 .Data20Reg( Data20Reg ),
				 .Data21Reg( Data21Reg ),
				 .Data22Reg( Data22Reg ),
				 .Data23Reg( Data23Reg ),
				 .Data24Reg( Data24Reg ),
				 .Data25Reg( Data25Reg ),
				 .Data26Reg( Data26Reg ),
				 .Data27Reg( Data27Reg ),
				 .Data28Reg( Data28Reg ),
				 .Data29Reg( Data29Reg ),
				 .Data30Reg( Data30Reg ),
				 .Data31Reg( Data31Reg ),
				 .Data32Reg( Data32Reg ),
				 .Data33Reg( Data33Reg ),
				 .Data34Reg( Data34Reg ),
				 .Data35Reg( Data35Reg ),
				 .Data36Reg( Data36Reg ),
				 .Data37Reg( Data37Reg ),
				 .Data38Reg( Data38Reg ),
				 .Data39Reg( Data39Reg ),
				 .Data40Reg( Data40Reg ),
				 .Data41Reg( Data41Reg ),
				 .Data42Reg( Data42Reg ),
				 .Data43Reg( Data43Reg ),
				 .Data44Reg( Data44Reg ),
				 .Data45Reg( Data45Reg ),
				 .Data46Reg( Data46Reg ),
				 .Data47Reg( Data47Reg ),
				 .Data48Reg( Data48Reg ),
				 .Data49Reg( Data49Reg ),
				 .Data50Reg( Data50Reg ),
				 .Data51Reg( Data51Reg ),
				 .Data52Reg( Data52Reg ),
				 .Data53Reg( Data53Reg ),
				 .Data54Reg( Data54Reg ),
				 .Data55Reg( Data55Reg ),
				 .Data56Reg( Data56Reg ),
				 .Data57Reg( Data57Reg ),
				 .Data58Reg( Data58Reg ),
				 .Data59Reg( Data59Reg ),
				 .Data60Reg( Data60Reg ),
				 .Data61Reg( Data61Reg ),
				 .Data62Reg( Data62Reg ),
				 .Data63Reg( Data63Reg ),

				 .BankARelease(BankARelease),
				 .BankBRelease(BankBRelease)
				 );

endmodule // jpeg_haffuman
