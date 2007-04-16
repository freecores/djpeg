//---------------------------------------------------------------------------
// File Name   : jpeg_decode.v
// Module Name : jpeg_decode
// Description : JPEG Deocder top module
// Project     : JPEG Decoder
// Belong to   : 
// Author      : H.Ishihara
// E-Mail      : hidemi@sweetcafe.jp
// HomePage    : http://www.sweetcafe.jp/
// Date        : 2007/04/11
// Rev.        : 2.0
//---------------------------------------------------------------------------
// Rev. Date       Description
//---------------------------------------------------------------------------
// 1.01 2006/10/01 1st Release
// 1.02 2006/10/04 add ProcessIdle register
// 2.00 2007/04/11 
//---------------------------------------------------------------------------
`timescale 1ps / 1ps

module jpeg_decode
  (
   rst,
   clk,

   // From FIFO
   DataIn,
   DataInEnable,
   DataInRead,

   JpegDecodeIdle,  // Deocdeer Process Idle(1:Idle, 0:Run)

   OutEnable,
   OutWidth,
   OutHeight,
   OutPixelX,
   OutPixelY,
   OutR,
   OutG,
   OutB

   );

   input          rst;
   input          clk;
   
   input [31:0]   DataIn;
   input          DataInEnable;
   output         DataInRead;
   
   output         JpegDecodeIdle;
   
   output         OutEnable;
   output [15:0]  OutWidth;
   output [15:0]  OutHeight;
   output [15:0]  OutPixelX;
   output [15:0]  OutPixelY;
   output [7:0]   OutR;
   output [7:0]   OutG;
   output [7:0]   OutB;

   wire [31:0]    JpegData;
   wire           JpegDataEnable;
   wire			JpegDecodeIdle;

   wire           UseBit;
   wire [6:0]     UseWidth;
   wire           UseByte;
   wire           UseWord;
   
   wire 	  ImageEnable;
   wire 	  EnableFF00;
   wire		DecodeFinish;

//   reg 		  ProcessIdle;

   //--------------------------------------------------------------------------
   // Read JPEG Data from FIFO
   //--------------------------------------------------------------------------
   jpeg_regdata u_jpeg_regdata(
			       .rst(rst),
			       .clk(clk),
			       
			       // Read Data
			       .DataIn        ( DataIn              ),
			       .DataInEnable  ( DataInEnable        ),
			       .DataInRead    ( DataInRead          ),
			       
			       // DataOut
			       .DataOut       ( JpegData            ),
			       .DataOutEnable ( JpegDataEnable      ),
			       
                               //
                               .ImageEnable   ( EnableFF00          ),
 					.ProcessIdle	( JpegDecodeIdle		),
			       
			       // UseData
			       .UseBit        ( UseBit              ),
			       .UseWidth      ( UseWidth            ),
			       .UseByte       ( UseByte             ),
			       .UseWord       ( UseWord             )
			       );

   //--------------------------------------------------------------------------
   // Read Maker from Jpeg Data
   //--------------------------------------------------------------------------
   wire 	  DqtEnable;
   wire 	  DqtTable;
   wire [5:0] 	  DqtCount;
   wire [7:0] 	  DqtData;
   
   wire 	  DhtEnable;
   wire [1:0] 	  DhtTable;
   wire [7:0] 	  DhtCount;
   wire [7:0] 	  DhtData;
   
   //
   wire 	  HaffumanEnable;
   wire [1:0] 	  HaffumanTable;
   wire [3:0] 	  HaffumanCount;
   wire [15:0] 	  HaffumanData;
   wire [7:0] 	  HaffumanStart;

   wire [11:0] 	  JpegBlockWidth;

   jpeg_decode_fsm u_jpeg_decode_fsm(
				     .rst(rst),
				     .clk(clk),
				     
				     // From FIFO
				     .DataInEnable    ( JpegDataEnable  ),
				     .DataIn          ( JpegData        ),
				     
				     .JpegDecodeIdle  ( JpegDecodeIdle  ),
				     
				     .OutWidth        ( OutWidth        ),
				     .OutHeight       ( OutHeight       ),
				     .OutBlockWidth   ( JpegBlockWidth  ),
				     .OutEnable			( OutEnable		),
				     .OutPixelX			( OutPixelX		),
				     .OutPixelY			( OutPixelY		),
				     
				     //
				     .DqtEnable       ( DqtEnable       ),
				     .DqtTable        ( DqtTable        ),
				     .DqtCount        ( DqtCount        ),
				     .DqtData         ( DqtData         ),
				   
				     //
				     .DhtEnable       ( DhtEnable       ),
				     .DhtTable        ( DhtTable        ),
				     .DhtCount        ( DhtCount        ),
				     .DhtData         ( DhtData         ),
				     
				     //
				     .HaffumanEnable  ( HaffumanEnable  ),
				     .HaffumanTable   ( HaffumanTable   ),
				     .HaffumanCount   ( HaffumanCount   ),
				     .HaffumanData    ( HaffumanData    ),
				     .HaffumanStart   ( HaffumanStart   ),
				     
				     //
				     .ImageEnable     ( ImageEnable     ),
				     .ImageEnd        ( DecodeFinish    ),
				     .EnableFF00      ( EnableFF00      ),
				     
				     //
				     .UseByte         ( UseByte         ),
				     .UseWord         ( UseWord         )
				     );

   
   wire           HmDecEnable;
   wire [2:0]     HmDecColor;

   wire 	  HmDecSel;
   wire 	  HmDecRelease;
   
   wire [15:0]    Hm00Data;
   wire [15:0]    Hm01Data;
   wire [15:0]    Hm02Data;
   wire [15:0]    Hm03Data;
   wire [15:0]    Hm04Data;
   wire [15:0]    Hm05Data;
   wire [15:0]    Hm06Data;
   wire [15:0]    Hm07Data;
   wire [15:0]    Hm08Data;
   wire [15:0]    Hm09Data;
   wire [15:0]    Hm10Data;
   wire [15:0]    Hm11Data;
   wire [15:0]    Hm12Data;
   wire [15:0]    Hm13Data;
   wire [15:0]    Hm14Data;
   wire [15:0]    Hm15Data;
   wire [15:0]    Hm16Data;
   wire [15:0]    Hm17Data;
   wire [15:0]    Hm18Data;
   wire [15:0]    Hm19Data;
   wire [15:0]    Hm20Data;
   wire [15:0]    Hm21Data;
   wire [15:0]    Hm22Data;
   wire [15:0]    Hm23Data;
   wire [15:0]    Hm24Data;
   wire [15:0]    Hm25Data;
   wire [15:0]    Hm26Data;
   wire [15:0]    Hm27Data;
   wire [15:0]    Hm28Data;
   wire [15:0]    Hm29Data;
   wire [15:0]    Hm30Data;
   wire [15:0]    Hm31Data;
   wire [15:0]    Hm32Data;
   wire [15:0]    Hm33Data;
   wire [15:0]    Hm34Data;
   wire [15:0]    Hm35Data;
   wire [15:0]    Hm36Data;
   wire [15:0]    Hm37Data;
   wire [15:0]    Hm38Data;
   wire [15:0]    Hm39Data;
   wire [15:0]    Hm40Data;
   wire [15:0]    Hm41Data;
   wire [15:0]    Hm42Data;
   wire [15:0]    Hm43Data;
   wire [15:0]    Hm44Data;
   wire [15:0]    Hm45Data;
   wire [15:0]    Hm46Data;
   wire [15:0]    Hm47Data;
   wire [15:0]    Hm48Data;
   wire [15:0]    Hm49Data;
   wire [15:0]    Hm50Data;
   wire [15:0]    Hm51Data;
   wire [15:0]    Hm52Data;
   wire [15:0]    Hm53Data;
   wire [15:0]    Hm54Data;
   wire [15:0]    Hm55Data;
   wire [15:0]    Hm56Data;
   wire [15:0]    Hm57Data;
   wire [15:0]    Hm58Data;
   wire [15:0]    Hm59Data;
   wire [15:0]    Hm60Data;
   wire [15:0]    Hm61Data;
   wire [15:0]    Hm62Data;
   wire [15:0]    Hm63Data;

   wire           DctIdle;
   
   jpeg_haffuman u_jpeg_haffuman(
                                 .rst(rst),
                                 .clk(clk),
                                 
                                 // DQT Table
                                 .DqtInEnable ( DqtEnable ),
                                 .DqtInColor  ( DqtTable ),
                                 .DqtInCount  ( DqtCount[5:0] ),
                                 .DqtInData   ( DqtData ),
                                 
                                 // DHT Table
                                 .DhtInEnable ( DhtEnable ),
                                 .DhtInColor  ( DhtTable  ),
                                 .DhtInCount  ( DhtCount  ),
                                 .DhtInData   ( DhtData   ),
                                 
                                 // Haffuman Table   
                                 .HaffumanTableEnable ( HaffumanEnable ),
                                 .HaffumanTableColor  ( HaffumanTable  ),
                                 .HaffumanTableCount  ( HaffumanCount  ),
                                 .HaffumanTableCode   ( HaffumanData   ),
                                 .HaffumanTableStart  ( HaffumanStart  ),
                                 
                                 // Haffuman Decode
                                 .DataInRun      ( ImageEnable    ),
                                 .DataInEnable   ( JpegDataEnable ),
                                 .DataIn         ( JpegData       ),
                                 
                                 // Output decode data   
                                 .DecodeUseBit   ( UseBit       ),
                                 .DecodeUseWidth ( UseWidth     ),
                                 
                                 // Data Out
                                 .DataOutIdle   ( DctIdle     ),
                                 .DataOutEnable ( HmDecEnable ),
                                 .DataOutColor  ( HmDecColor  ),
				 .DataOutSel    ( HmDecSel    ),
                                 .Data00Reg    ( Hm00Data ),
                                 .Data01Reg    ( Hm01Data ),
                                 .Data02Reg    ( Hm02Data ),
                                 .Data03Reg    ( Hm03Data ),
                                 .Data04Reg    ( Hm04Data ),
                                 .Data05Reg    ( Hm05Data ),
                                 .Data06Reg    ( Hm06Data ),
                                 .Data07Reg    ( Hm07Data ),
                                 .Data08Reg    ( Hm08Data ),
                                 .Data09Reg    ( Hm09Data ),
                                 .Data10Reg    ( Hm10Data ),
                                 .Data11Reg    ( Hm11Data ),
                                 .Data12Reg    ( Hm12Data ),
                                 .Data13Reg    ( Hm13Data ),
                                 .Data14Reg    ( Hm14Data ),
                                 .Data15Reg    ( Hm15Data ),
                                 .Data16Reg    ( Hm16Data ),
                                 .Data17Reg    ( Hm17Data ),
                                 .Data18Reg    ( Hm18Data ),
                                 .Data19Reg    ( Hm19Data ),
                                 .Data20Reg    ( Hm20Data ),
                                 .Data21Reg    ( Hm21Data ),
                                 .Data22Reg    ( Hm22Data ),
                                 .Data23Reg    ( Hm23Data ),
                                 .Data24Reg    ( Hm24Data ),
                                 .Data25Reg    ( Hm25Data ),
                                 .Data26Reg    ( Hm26Data ),
                                 .Data27Reg    ( Hm27Data ),
                                 .Data28Reg    ( Hm28Data ),
                                 .Data29Reg    ( Hm29Data ),
                                 .Data30Reg    ( Hm30Data ),
                                 .Data31Reg    ( Hm31Data ),
                                 .Data32Reg    ( Hm32Data ),
                                 .Data33Reg    ( Hm33Data ),
                                 .Data34Reg    ( Hm34Data ),
                                 .Data35Reg    ( Hm35Data ),
                                 .Data36Reg    ( Hm36Data ),
                                 .Data37Reg    ( Hm37Data ),
                                 .Data38Reg    ( Hm38Data ),
                                 .Data39Reg    ( Hm39Data ),
                                 .Data40Reg    ( Hm40Data ),
                                 .Data41Reg    ( Hm41Data ),
                                 .Data42Reg    ( Hm42Data ),
                                 .Data43Reg    ( Hm43Data ),
                                 .Data44Reg    ( Hm44Data ),
                                 .Data45Reg    ( Hm45Data ),
                                 .Data46Reg    ( Hm46Data ),
                                 .Data47Reg    ( Hm47Data ),
                                 .Data48Reg    ( Hm48Data ),
                                 .Data49Reg    ( Hm49Data ),
                                 .Data50Reg    ( Hm50Data ),
                                 .Data51Reg    ( Hm51Data ),
                                 .Data52Reg    ( Hm52Data ),
                                 .Data53Reg    ( Hm53Data ),
                                 .Data54Reg    ( Hm54Data ),
                                 .Data55Reg    ( Hm55Data ),
                                 .Data56Reg    ( Hm56Data ),
                                 .Data57Reg    ( Hm57Data ),
                                 .Data58Reg    ( Hm58Data ),
                                 .Data59Reg    ( Hm59Data ),
                                 .Data60Reg    ( Hm60Data ),
                                 .Data61Reg    ( Hm61Data ),
                                 .Data62Reg    ( Hm62Data ),
                                 .Data63Reg    ( Hm63Data ),
				 .DataOutRelease (HmDecRelase)
                                 );

   wire           DctEnable;
   wire [2:0]     DctColor;
   wire [2:0]     DctPage;
   wire [1:0]     DctCount;
   wire [8:0]     Dct0Data;
   wire [8:0]     Dct1Data;

   wire [15:0]    DctWidth;
   wire [15:0]    DctHeight;
   wire [11:0]    DctBlockX;
   wire [11:0]    DctBlockY;

   wire           YCbCrIdle;
   
   jpeg_idct u_jpeg_idct(
                         .rst(rst),
                         .clk(clk),

                         .DataInEnable( HmDecEnable ),
			 .DataInSel( HmDecSel ),
                         .Data00In( Hm00Data ),
                         .Data01In( Hm01Data ),
                         .Data02In( Hm02Data ),
                         .Data03In( Hm03Data ),
                         .Data04In( Hm04Data ),
                         .Data05In( Hm05Data ),
                         .Data06In( Hm06Data ),
                         .Data07In( Hm07Data ),
                         .Data08In( Hm08Data ),
                         .Data09In( Hm09Data ),
                         .Data10In( Hm10Data ),
                         .Data11In( Hm11Data ),
                         .Data12In( Hm12Data ),
                         .Data13In( Hm13Data ),
                         .Data14In( Hm14Data ),
                         .Data15In( Hm15Data ),
                         .Data16In( Hm16Data ),
                         .Data17In( Hm17Data ),
                         .Data18In( Hm18Data ),
                         .Data19In( Hm19Data ),
                         .Data20In( Hm20Data ),
                         .Data21In( Hm21Data ),
                         .Data22In( Hm22Data ),
                         .Data23In( Hm23Data ),
                         .Data24In( Hm24Data ),
                         .Data25In( Hm25Data ),
                         .Data26In( Hm26Data ),
                         .Data27In( Hm27Data ),
                         .Data28In( Hm28Data ),
                         .Data29In( Hm29Data ),
                         .Data30In( Hm30Data ),
                         .Data31In( Hm31Data ),
                         .Data32In( Hm32Data ),
                         .Data33In( Hm33Data ),
                         .Data34In( Hm34Data ),
                         .Data35In( Hm35Data ),
                         .Data36In( Hm36Data ),
                         .Data37In( Hm37Data ),
                         .Data38In( Hm38Data ),
                         .Data39In( Hm39Data ),
                         .Data40In( Hm40Data ),
                         .Data41In( Hm41Data ),
                         .Data42In( Hm42Data ),
                         .Data43In( Hm43Data ),
                         .Data44In( Hm44Data ),
                         .Data45In( Hm45Data ),
                         .Data46In( Hm46Data ),
                         .Data47In( Hm47Data ),
                         .Data48In( Hm48Data ),
                         .Data49In( Hm49Data ),
                         .Data50In( Hm50Data ),
                         .Data51In( Hm51Data ),
                         .Data52In( Hm52Data ),
                         .Data53In( Hm53Data ),
                         .Data54In( Hm54Data ),
                         .Data55In( Hm55Data ),
                         .Data56In( Hm56Data ),
                         .Data57In( Hm57Data ),
                         .Data58In( Hm58Data ),
                         .Data59In( Hm59Data ),
                         .Data60In( Hm60Data ),
                         .Data61In( Hm61Data ),
                         .Data62In( Hm62Data ),
                         .Data63In( Hm63Data ),
                         .DataInIdle( DctIdle ),
			 .DataInRelease( HmDecRelase ),
                         
                         .DataOutEnable ( DctEnable ),
                         .DataOutPage   ( DctPage   ),
                         .DataOutCount  ( DctCount  ),
                         .Data0Out      ( Dct0Data  ),
                         .Data1Out      ( Dct1Data  )
                         );

	wire	ColorEnable;
	wire [15:0]	ColorPixelX, ColorPixelY;
	wire [7:0]	ColorR, ColorG, ColorB;
   jpeg_ycbcr u_jpeg_ycbcr(
                           .rst(rst),
                           .clk(clk),
                           
                           .DataInEnable     ( DctEnable ),
                           .DataInPage       ( DctPage   ),
                           .DataInCount      ( DctCount  ),
                           .DataInIdle       ( YCbCrIdle ),
                           .Data0In          ( Dct0Data  ),
                           .Data1In          ( Dct1Data  ),
                           .DataInBlockWidth ( JpegBlockWidth ),
                   
                           .OutEnable    ( ColorEnable ),
                           .OutPixelX    ( ColorPixelX ),
                           .OutPixelY    ( ColorPixelY ),
                           .OutR         ( ColorR      ),
                           .OutG         ( ColorG      ),
                           .OutB         ( ColorB      )
                           );
	// OutData
	assign OutEnable	= (ImageEnable)?ColorEnable:1'b0;
	assign OutPixelX	= (ImageEnable)?ColorPixelX:16'd0;
	assign OutPixelY	= (ImageEnable)?ColorPixelY:16'd0;
	assign OutR			= (ImageEnable)?ColorR:8'd0;
	assign OutG			= (ImageEnable)?ColorG:8'd0;
	assign OutB			= (ImageEnable)?ColorB:8'd0;

endmodule // jpeg_decode
