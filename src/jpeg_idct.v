//---------------------------------------------------------------------------
// File Name   : jpeg_idct.v
// Module Name : jpeg_idct
// Description : iDCT top module
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

module jpeg_idct
  (
   rst,
   clk,

   DataInEnable,
   DataInSel,
   Data00In,
   Data01In,
   Data02In,
   Data03In,
   Data04In,
   Data05In,
   Data06In,
   Data07In,
   Data08In,
   Data09In,
   Data10In,
   Data11In,
   Data12In,
   Data13In,
   Data14In,
   Data15In,
   Data16In,
   Data17In,
   Data18In,
   Data19In,
   Data20In,
   Data21In,
   Data22In,
   Data23In,
   Data24In,
   Data25In,
   Data26In,
   Data27In,
   Data28In,
   Data29In,
   Data30In,
   Data31In,
   Data32In,
   Data33In,
   Data34In,
   Data35In,
   Data36In,
   Data37In,
   Data38In,
   Data39In,
   Data40In,
   Data41In,
   Data42In,
   Data43In,
   Data44In,
   Data45In,
   Data46In,
   Data47In,
   Data48In,
   Data49In,
   Data50In,
   Data51In,
   Data52In,
   Data53In,
   Data54In,
   Data55In,
   Data56In,
   Data57In,
   Data58In,
   Data59In,
   Data60In,
   Data61In,
   Data62In,
   Data63In,
   DataInIdle,
   DataInRelease,

   DataOutEnable,
   DataOutPage,
   DataOutCount,
   Data0Out,
   Data1Out
   );

   input          rst;
   input          clk;
   
   input          DataInEnable;
   output DataInSel;
   input [15:0]   Data00In;
   input [15:0]   Data01In;
   input [15:0]   Data02In;
   input [15:0]   Data03In;
   input [15:0]   Data04In;
   input [15:0]   Data05In;
   input [15:0]   Data06In;
   input [15:0]   Data07In;
   input [15:0]   Data08In;
   input [15:0]   Data09In;
   input [15:0]   Data10In;
   input [15:0]   Data11In;
   input [15:0]   Data12In;
   input [15:0]   Data13In;
   input [15:0]   Data14In;
   input [15:0]   Data15In;
   input [15:0]   Data16In;
   input [15:0]   Data17In;
   input [15:0]   Data18In;
   input [15:0]   Data19In;
   input [15:0]   Data20In;
   input [15:0]   Data21In;
   input [15:0]   Data22In;
   input [15:0]   Data23In;
   input [15:0]   Data24In;
   input [15:0]   Data25In;
   input [15:0]   Data26In;
   input [15:0]   Data27In;
   input [15:0]   Data28In;
   input [15:0]   Data29In;
   input [15:0]   Data30In;
   input [15:0]   Data31In;
   input [15:0]   Data32In;
   input [15:0]   Data33In;
   input [15:0]   Data34In;
   input [15:0]   Data35In;
   input [15:0]   Data36In;
   input [15:0]   Data37In;
   input [15:0]   Data38In;
   input [15:0]   Data39In;
   input [15:0]   Data40In;
   input [15:0]   Data41In;
   input [15:0]   Data42In;
   input [15:0]   Data43In;
   input [15:0]   Data44In;
   input [15:0]   Data45In;
   input [15:0]   Data46In;
   input [15:0]   Data47In;
   input [15:0]   Data48In;
   input [15:0]   Data49In;
   input [15:0]   Data50In;
   input [15:0]   Data51In;
   input [15:0]   Data52In;
   input [15:0]   Data53In;
   input [15:0]   Data54In;
   input [15:0]   Data55In;
   input [15:0]   Data56In;
   input [15:0]   Data57In;
   input [15:0]   Data58In;
   input [15:0]   Data59In;
   input [15:0]   Data60In;
   input [15:0]   Data61In;
   input [15:0]   Data62In;
   input [15:0]   Data63In;
   output         DataInIdle;
   output 	  DataInRelease;
   
   output         DataOutEnable;
   output [2:0]   DataOutPage;
   output [1:0]   DataOutCount;
   output [8:0]   Data0Out;
   output [8:0]   Data1Out;

   wire           DctXEnable;
   wire [2:0]     DctXPage;
   wire [1:0]     DctXCount;
   wire [15:0]    DctXData0r;
   wire [15:0]    DctXData1r;
   
   wire           DctBBank;
   wire           DctBIdle;
   
   jpeg_idctx u_jpeg_idctx(
                           .rst(rst),
                           .clk(clk),
                           
                           .DataInEnable( DataInEnable ),
			   .DataInSel( DataInSel ),
                           .Data00In( Data00In ),
                           .Data01In( Data01In ),
                           .Data02In( Data02In ),
                           .Data03In( Data03In ),
                           .Data04In( Data04In ),
                           .Data05In( Data05In ),
                           .Data06In( Data06In ),
                           .Data07In( Data07In ),
                           .Data08In( Data08In ),
                           .Data09In( Data09In ),
                           .Data10In( Data10In ),
                           .Data11In( Data11In ),
                           .Data12In( Data12In ),
                           .Data13In( Data13In ),
                           .Data14In( Data14In ),
                           .Data15In( Data15In ),
                           .Data16In( Data16In ),
                           .Data17In( Data17In ),
                           .Data18In( Data18In ),
                           .Data19In( Data19In ),
                           .Data20In( Data20In ),
                           .Data21In( Data21In ),
                           .Data22In( Data22In ),
                           .Data23In( Data23In ),
                           .Data24In( Data24In ),
                           .Data25In( Data25In ),
                           .Data26In( Data26In ),
                           .Data27In( Data27In ),
                           .Data28In( Data28In ),
                           .Data29In( Data29In ),
                           .Data30In( Data30In ),
                           .Data31In( Data31In ),
                           .Data32In( Data32In ),
                           .Data33In( Data33In ),
                           .Data34In( Data34In ),
                           .Data35In( Data35In ),
                           .Data36In( Data36In ),
                           .Data37In( Data37In ),
                           .Data38In( Data38In ),
                           .Data39In( Data39In ),
                           .Data40In( Data40In ),
                           .Data41In( Data41In ),
                           .Data42In( Data42In ),
                           .Data43In( Data43In ),
                           .Data44In( Data44In ),
                           .Data45In( Data45In ),
                           .Data46In( Data46In ),
                           .Data47In( Data47In ),
                           .Data48In( Data48In ),
                           .Data49In( Data49In ),
                           .Data50In( Data50In ),
                           .Data51In( Data51In ),
                           .Data52In( Data52In ),
                           .Data53In( Data53In ),
                           .Data54In( Data54In ),
                           .Data55In( Data55In ),
                           .Data56In( Data56In ),
                           .Data57In( Data57In ),
                           .Data58In( Data58In ),
                           .Data59In( Data59In ),
                           .Data60In( Data60In ),
                           .Data61In( Data61In ),
                           .Data62In( Data62In ),
                           .Data63In( Data63In ),
                           .DataInIdle( DataInIdle),
			   .DataInRelease( DataInRelease ),
			   
                           .DataOutIdle   ( DctBIdle   ),
                           .DataOutEnable ( DctXEnable ),
                           .DataOutPage   ( DctXPage   ),
                           .DataOutCount  ( DctXCount  ),
                           .Data0Out      ( DctXData0r ),
                           .Data1Out      ( DctXData1r )
                           );

   wire [15:0]    DctB00r;
   wire [15:0]    DctB01r;
   wire [15:0]    DctB02r;
   wire [15:0]    DctB03r;
   wire [15:0]    DctB04r;
   wire [15:0]    DctB05r;
   wire [15:0]    DctB06r;
   wire [15:0]    DctB07r;
   wire [15:0]    DctB08r;
   wire [15:0]    DctB09r;
   wire [15:0]    DctB10r;
   wire [15:0]    DctB11r;
   wire [15:0]    DctB12r;
   wire [15:0]    DctB13r;
   wire [15:0]    DctB14r;
   wire [15:0]    DctB15r;
   wire [15:0]    DctB16r;
   wire [15:0]    DctB17r;
   wire [15:0]    DctB18r;
   wire [15:0]    DctB19r;
   wire [15:0]    DctB20r;
   wire [15:0]    DctB21r;
   wire [15:0]    DctB22r;
   wire [15:0]    DctB23r;
   wire [15:0]    DctB24r;
   wire [15:0]    DctB25r;
   wire [15:0]    DctB26r;
   wire [15:0]    DctB27r;
   wire [15:0]    DctB28r;
   wire [15:0]    DctB29r;
   wire [15:0]    DctB30r;
   wire [15:0]    DctB31r;
   wire [15:0]    DctB32r;
   wire [15:0]    DctB33r;
   wire [15:0]    DctB34r;
   wire [15:0]    DctB35r;
   wire [15:0]    DctB36r;
   wire [15:0]    DctB37r;
   wire [15:0]    DctB38r;
   wire [15:0]    DctB39r;
   wire [15:0]    DctB40r;
   wire [15:0]    DctB41r;
   wire [15:0]    DctB42r;
   wire [15:0]    DctB43r;
   wire [15:0]    DctB44r;
   wire [15:0]    DctB45r;
   wire [15:0]    DctB46r;
   wire [15:0]    DctB47r;
   wire [15:0]    DctB48r;
   wire [15:0]    DctB49r;
   wire [15:0]    DctB50r;
   wire [15:0]    DctB51r;
   wire [15:0]    DctB52r;
   wire [15:0]    DctB53r;
   wire [15:0]    DctB54r;
   wire [15:0]    DctB55r;
   wire [15:0]    DctB56r;
   wire [15:0]    DctB57r;
   wire [15:0]    DctB58r;
   wire [15:0]    DctB59r;
   wire [15:0]    DctB60r;
   wire [15:0]    DctB61r;
   wire [15:0]    DctB62r;
   wire [15:0]    DctB63r;

   wire           DctBReleaseA;
   wire           DctBReleaseB;
   wire           DctBRelease;
   
   jpeg_idctb u_jpeg_idctb(
                           .rst(rst),
                           .clk(clk),
                           
                           .DataInEnable ( DctXEnable ),
                           .DataInPage   ( DctXPage   ),
                           .DataInCount  ( DctXCount  ),
                           .DataInIdle   ( DctBIdle   ),
                           .Data0In      ( DctXData0r ),
                           .Data1In      ( DctXData1r ),

                           .DataOutEnable ( DctBEnable ),
                           .DataOutSel( DctBSel),
                           .Data00Out( DctB00r ),
                           .Data01Out( DctB01r ),
                           .Data02Out( DctB02r ),
                           .Data03Out( DctB03r ),
                           .Data04Out( DctB04r ),
                           .Data05Out( DctB05r ),
                           .Data06Out( DctB06r ),
                           .Data07Out( DctB07r ),
                           .Data08Out( DctB08r ),
                           .Data09Out( DctB09r ),
                           .Data10Out( DctB10r ),
                           .Data11Out( DctB11r ),
                           .Data12Out( DctB12r ),
                           .Data13Out( DctB13r ),
                           .Data14Out( DctB14r ),
                           .Data15Out( DctB15r ),
                           .Data16Out( DctB16r ),
                           .Data17Out( DctB17r ),
                           .Data18Out( DctB18r ),
                           .Data19Out( DctB19r ),
                           .Data20Out( DctB20r ),
                           .Data21Out( DctB21r ),
                           .Data22Out( DctB22r ),
                           .Data23Out( DctB23r ),
                           .Data24Out( DctB24r ),
                           .Data25Out( DctB25r ),
                           .Data26Out( DctB26r ),
                           .Data27Out( DctB27r ),
                           .Data28Out( DctB28r ),
                           .Data29Out( DctB29r ),
                           .Data30Out( DctB30r ),
                           .Data31Out( DctB31r ),
                           .Data32Out( DctB32r ),
                           .Data33Out( DctB33r ),
                           .Data34Out( DctB34r ),
                           .Data35Out( DctB35r ),
                           .Data36Out( DctB36r ),
                           .Data37Out( DctB37r ),
                           .Data38Out( DctB38r ),
                           .Data39Out( DctB39r ),
                           .Data40Out( DctB40r ),
                           .Data41Out( DctB41r ),
                           .Data42Out( DctB42r ),
                           .Data43Out( DctB43r ),
                           .Data44Out( DctB44r ),
                           .Data45Out( DctB45r ),
                           .Data46Out( DctB46r ),
                           .Data47Out( DctB47r ),
                           .Data48Out( DctB48r ),
                           .Data49Out( DctB49r ),
                           .Data50Out( DctB50r ),
                           .Data51Out( DctB51r ),
                           .Data52Out( DctB52r ),
                           .Data53Out( DctB53r ),
                           .Data54Out( DctB54r ),
                           .Data55Out( DctB55r ),
                           .Data56Out( DctB56r ),
                           .Data57Out( DctB57r ),
                           .Data58Out( DctB58r ),
                           .Data59Out( DctB59r ),
                           .Data60Out( DctB60r ),
                           .Data61Out( DctB61r ),
                           .Data62Out( DctB62r ),
                           .Data63Out( DctB63r ),
                           
                           .BankARelease( DctBReleaseA ),
                           .BankBRelease( DctBReleaseB )
                           );

   assign         DctBReleaseA = DctBSel == 1'b0 & DctBRelease;
   assign         DctBReleaseB = DctBSel == 1'b1 & DctBRelease;

   jpeg_idcty u_jpeg_idcty(
                           .rst(rst),
                           .clk(clk),
                           
                           .DataInEnable(DctBEnable),
                           .DataInBank(DctBBank),
                           .DataInSel(DctBSel),
                           .Data00In( DctB00r ),
                           .Data01In( DctB01r ),
                           .Data02In( DctB02r ),
                           .Data03In( DctB03r ),
                           .Data04In( DctB04r ),
                           .Data05In( DctB05r ),
                           .Data06In( DctB06r ),
                           .Data07In( DctB07r ),
                           .Data08In( DctB08r ),
                           .Data09In( DctB09r ),
                           .Data10In( DctB10r ),
                           .Data11In( DctB11r ),
                           .Data12In( DctB12r ),
                           .Data13In( DctB13r ),
                           .Data14In( DctB14r ),
                           .Data15In( DctB15r ),
                           .Data16In( DctB16r ),
                           .Data17In( DctB17r ),
                           .Data18In( DctB18r ),
                           .Data19In( DctB19r ),
                           .Data20In( DctB20r ),
                           .Data21In( DctB21r ),
                           .Data22In( DctB22r ),
                           .Data23In( DctB23r ),
                           .Data24In( DctB24r ),
                           .Data25In( DctB25r ),
                           .Data26In( DctB26r ),
                           .Data27In( DctB27r ),
                           .Data28In( DctB28r ),
                           .Data29In( DctB29r ),
                           .Data30In( DctB30r ),
                           .Data31In( DctB31r ),
                           .Data32In( DctB32r ),
                           .Data33In( DctB33r ),
                           .Data34In( DctB34r ),
                           .Data35In( DctB35r ),
                           .Data36In( DctB36r ),
                           .Data37In( DctB37r ),
                           .Data38In( DctB38r ),
                           .Data39In( DctB39r ),
                           .Data40In( DctB40r ),
                           .Data41In( DctB41r ),
                           .Data42In( DctB42r ),
                           .Data43In( DctB43r ),
                           .Data44In( DctB44r ),
                           .Data45In( DctB45r ),
                           .Data46In( DctB46r ),
                           .Data47In( DctB47r ),
                           .Data48In( DctB48r ),
                           .Data49In( DctB49r ),
                           .Data50In( DctB50r ),
                           .Data51In( DctB51r ),
                           .Data52In( DctB52r ),
                           .Data53In( DctB53r ),
                           .Data54In( DctB54r ),
                           .Data55In( DctB55r ),
                           .Data56In( DctB56r ),
                           .Data57In( DctB57r ),
                           .Data58In( DctB58r ),
                           .Data59In( DctB59r ),
                           .Data60In( DctB60r ),
                           .Data61In( DctB61r ),
                           .Data62In( DctB62r ),
                           .Data63In( DctB63r ),
                           .DataInIdle( DctYIdle ),
                           .DataInRelease( DctBRelease),
                           
                           .DataOutEnable ( DataOutEnable ),
                           .DataOutPage   ( DataOutPage   ),
                           .DataOutCount  ( DataOutCount  ),
                           .Data0Out      ( Data0Out      ),
                           .Data1Out      ( Data1Out      )
                           );

endmodule // jpeg_idct
