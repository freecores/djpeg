//---------------------------------------------------------------------------
// File Name   : jpeg_idctx.v
// Module Name : jpeg_idctx
// Description : iDCT-X
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
// 1.01 2006/09/01 1st Release
//---------------------------------------------------------------------------
// $Id: 
//---------------------------------------------------------------------------
`timescale 1ps / 1ps

module jpeg_idctx
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

   DataOutIdle,
   DataOutEnable,
   DataOutPage,
   DataOutCount,
   Data0Out,
   Data1Out
   );

   input clk;
   input rst;

   input DataInEnable;
   output DataInSel;
   input [15:0] Data00In;
   input [15:0] Data01In;
   input [15:0] Data02In;
   input [15:0] Data03In;
   input [15:0] Data04In;
   input [15:0] Data05In;
   input [15:0] Data06In;
   input [15:0] Data07In;
   input [15:0] Data08In;
   input [15:0] Data09In;
   input [15:0] Data10In;
   input [15:0] Data11In;
   input [15:0] Data12In;
   input [15:0] Data13In;
   input [15:0] Data14In;
   input [15:0] Data15In;
   input [15:0] Data16In;
   input [15:0] Data17In;
   input [15:0] Data18In;
   input [15:0] Data19In;
   input [15:0] Data20In;
   input [15:0] Data21In;
   input [15:0] Data22In;
   input [15:0] Data23In;
   input [15:0] Data24In;
   input [15:0] Data25In;
   input [15:0] Data26In;
   input [15:0] Data27In;
   input [15:0] Data28In;
   input [15:0] Data29In;
   input [15:0] Data30In;
   input [15:0] Data31In;
   input [15:0] Data32In;
   input [15:0] Data33In;
   input [15:0] Data34In;
   input [15:0] Data35In;
   input [15:0] Data36In;
   input [15:0] Data37In;
   input [15:0] Data38In;
   input [15:0] Data39In;
   input [15:0] Data40In;
   input [15:0] Data41In;
   input [15:0] Data42In;
   input [15:0] Data43In;
   input [15:0] Data44In;
   input [15:0] Data45In;
   input [15:0] Data46In;
   input [15:0] Data47In;
   input [15:0] Data48In;
   input [15:0] Data49In;
   input [15:0] Data50In;
   input [15:0] Data51In;
   input [15:0] Data52In;
   input [15:0] Data53In;
   input [15:0] Data54In;
   input [15:0] Data55In;
   input [15:0] Data56In;
   input [15:0] Data57In;
   input [15:0] Data58In;
   input [15:0] Data59In;
   input [15:0] Data60In;
   input [15:0] Data61In;
   input [15:0] Data62In;
   input [15:0] Data63In;
   output       DataInIdle;
   output       DataInRelease;

   input        DataOutIdle;
   output        DataOutEnable;
   output [2:0]  DataOutPage;
   output [1:0]  DataOutCount;
   output [15:0] Data0Out;
   output [15:0] Data1Out;
   
   //-------------------------------------------------------------------------
   // Phase1
   //-------------------------------------------------------------------------
   reg           Phase1Enable;
   reg [2:0]     Phase1Page;
   reg [2:0]     Phase1Count;
   //reg           Phase1EnableD;
   //reg [2:0]     Phase1PageD;
   //reg [2:0]     Phase1CountD;
   reg           DataInBank;
   
   always @(posedge clk or negedge rst) begin
      if(!rst) begin
         Phase1Enable  <= 1'b0;
         Phase1Page    <= 3'd0;
         Phase1Count   <= 3'd0;
         //Phase1EnableD <= 1'b0;
         //Phase1PageD   <= 3'd0;
         //Phase1CountD  <= 3'd0;
         DataInBank    <= 1'b0;
      end else begin
         if(Phase1Enable == 1'b0) begin
            if(DataInEnable == 1'b1) begin
               Phase1Enable <= 1'b1;
               Phase1Page   <= 3'd0;
               Phase1Count  <= 3'd0;
            end
         end else begin
            if(Phase1Count == 3'd6) begin
               if(Phase1Page == 3'd7) begin
                  Phase1Enable <= 1'b0;
                  Phase1Page   <= 3'd0;
                  DataInBank   <= ~DataInBank;
               end else begin
                  Phase1Page   <= Phase1Page + 3'd1;
               end
               Phase1Count <= 3'd0;
            end else begin
               Phase1Count <= Phase1Count + 3'd1;
            end // else: !if(Phase1Count == 3'd6)
         end // else: !if(Phase1Enable == 1'b0)
         //Phase1EnableD <= Phase1Enable;
         //Phase1PageD   <= Phase1Page;
         //Phase1CountD  <= Phase1Count;
      end // else: !if(!rst)
   end // always @ (posedge clk or negedge rst)

   assign DataInSel  = DataInBank;
   assign DataInIdle = Phase1Enable == 1'b0 & DataOutIdle == 1'b1;
   assign DataInRelease = Phase1Enable == 1'b1 & Phase1Count == 3'd6 & Phase1Page == 3'd7;
   
   wire signed [15:0]    Phase1R0w;
   wire signed [15:0]    Phase1R1w;
   wire signed [15:0]    Phase1C0w;
   wire signed [15:0]    Phase1C1w;
   wire signed [15:0]    Phase1C2w;
   wire signed [15:0]    Phase1C3w;

/*
   always @(*) begin
      case(Phase1Page)
        3'd0:begin
           case(Phase1Count)
             3'd0: begin
                Phase1R0w <= Data00In;
                Phase1R1w <= Data04In;
             end
             3'd1: begin
                Phase1R0w <= Data02In;
                Phase1R1w <= Data06In;
             end
             3'd2: begin
                Phase1R0w <= Data01In;
                Phase1R1w <= Data07In;
             end
             3'd3: begin
                Phase1R0w <= Data05In;
                Phase1R1w <= Data03In;
             end
           endcase // case(Phase1Count)
        end // case: 3'd0
        3'd1:begin
           case(Phase1Count)
             3'd0: begin
                Phase1R0w <= Data08In;
                Phase1R1w <= Data12In;
             end
             3'd1: begin
                Phase1R0w <= Data10In;
                Phase1R1w <= Data14In;
             end
             3'd2: begin
                Phase1R0w <= Data09In;
                Phase1R1w <= Data15In;
             end
             3'd3: begin
                Phase1R0w <= Data13In;
                Phase1R1w <= Data11In;
             end
           endcase // case(Phase1Count)
        end // case: 3'd1
        3'd2:begin
           case(Phase1Count)
             3'd0: begin
                Phase1R0w <= Data16In;
                Phase1R1w <= Data20In;
             end
             3'd1: begin
                Phase1R0w <= Data18In;
                Phase1R1w <= Data22In;
             end
             3'd2: begin
                Phase1R0w <= Data17In;
                Phase1R1w <= Data23In;
             end
             3'd3: begin
                Phase1R0w <= Data21In;
                Phase1R1w <= Data19In;
             end
           endcase // case(Phase1Count)
        end // case: 3'd2
        3'd3:begin
           case(Phase1Count)
             3'd0: begin
                Phase1R0w <= Data24In;
                Phase1R1w <= Data28In;
             end
             3'd1: begin
                Phase1R0w <= Data26In;
                Phase1R1w <= Data30In;
             end
             3'd2: begin
                Phase1R0w <= Data25In;
                Phase1R1w <= Data31In;
             end
             3'd3: begin
                Phase1R0w <= Data29In;
                Phase1R1w <= Data27In;
             end
           endcase // case(Phase1Count)
        end // case: 3'd3
        3'd4:begin
           case(Phase1Count)
             3'd0: begin
                Phase1R0w <= Data32In;
                Phase1R1w <= Data36In;
             end
             3'd1: begin
                Phase1R0w <= Data34In;
                Phase1R1w <= Data38In;
             end
             3'd2: begin
                Phase1R0w <= Data33In;
                Phase1R1w <= Data39In;
             end
             3'd3: begin
                Phase1R0w <= Data37In;
                Phase1R1w <= Data35In;
             end
           endcase // case(Phase1Count)
        end // case: 3'd4
        3'd5:begin
           case(Phase1Count)
             3'd0: begin
                Phase1R0w <= Data40In;
                Phase1R1w <= Data44In;
             end
             3'd1: begin
                Phase1R0w <= Data42In;
                Phase1R1w <= Data46In;
             end
             3'd2: begin
                Phase1R0w <= Data41In;
                Phase1R1w <= Data47In;
             end
             3'd3: begin
                Phase1R0w <= Data45In;
                Phase1R1w <= Data43In;
             end
           endcase // case(Phase1Count)
        end // case: 3'd5
        3'd6:begin
           case(Phase1Count)
             3'd0: begin
                Phase1R0w <= Data48In;
                Phase1R1w <= Data52In;
             end
             3'd1: begin
                Phase1R0w <= Data50In;
                Phase1R1w <= Data54In;
             end
             3'd2: begin
                Phase1R0w <= Data49In;
                Phase1R1w <= Data55In;
             end
             3'd3: begin
                Phase1R0w <= Data53In;
                Phase1R1w <= Data51In;
             end
           endcase // case(Phase1Count)
        end // case: 3'd6
        3'd7:begin
           case(Phase1Count)
             3'd0: begin
                Phase1R0w <= Data56In;
                Phase1R1w <= Data60In;
             end
             3'd1: begin
                Phase1R0w <= Data58In;
                Phase1R1w <= Data62In;
             end
             3'd2: begin
                Phase1R0w <= Data57In;
                Phase1R1w <= Data63In;
             end
             3'd3: begin
                Phase1R0w <= Data61In;
                Phase1R1w <= Data59In;
             end
           endcase // case(Phase1Count)
        end // case: 3'd7
      endcase // case(Phase1Page)
   end // always @ (*)
*/
	function [15:0] Phase1R0wSel;
		input [2:0]	Phase1Page;
		input [2:0]	Phase1Count;
		input [15:0]	Data00In;
		input [15:0]	Data01In;
		input [15:0]	Data02In;
		input [15:0]	Data03In;
		input [15:0]	Data04In;
		input [15:0]	Data05In;
		input [15:0]	Data06In;
		input [15:0]	Data07In;
		input [15:0]	Data08In;
		input [15:0]	Data09In;
		input [15:0]	Data10In;
		input [15:0]	Data11In;
		input [15:0]	Data12In;
		input [15:0]	Data13In;
		input [15:0]	Data14In;
		input [15:0]	Data15In;
		input [15:0]	Data16In;
		input [15:0]	Data17In;
		input [15:0]	Data18In;
		input [15:0]	Data19In;
		input [15:0]	Data20In;
		input [15:0]	Data21In;
		input [15:0]	Data22In;
		input [15:0]	Data23In;
		input [15:0]	Data24In;
		input [15:0]	Data25In;
		input [15:0]	Data26In;
		input [15:0]	Data27In;
		input [15:0]	Data28In;
		input [15:0]	Data29In;
		input [15:0]	Data30In;
		input [15:0]	Data31In;
		input [15:0]	Data32In;
		input [15:0]	Data33In;
		input [15:0]	Data34In;
		input [15:0]	Data35In;
		input [15:0]	Data36In;
		input [15:0]	Data37In;
		input [15:0]	Data38In;
		input [15:0]	Data39In;
		input [15:0]	Data40In;
		input [15:0]	Data41In;
		input [15:0]	Data42In;
		input [15:0]	Data43In;
		input [15:0]	Data44In;
		input [15:0]	Data45In;
		input [15:0]	Data46In;
		input [15:0]	Data47In;
		input [15:0]	Data48In;
		input [15:0]	Data49In;
		input [15:0]	Data50In;
		input [15:0]	Data51In;
		input [15:0]	Data52In;
		input [15:0]	Data53In;
		input [15:0]	Data54In;
		input [15:0]	Data55In;
		input [15:0]	Data56In;
		input [15:0]	Data57In;
		input [15:0]	Data58In;
		input [15:0]	Data59In;
		input [15:0]	Data60In;
		input [15:0]	Data61In;
		input [15:0]	Data62In;
		input [15:0]	Data63In;
	begin
      case(Phase1Page)
        3'd0:begin
           case(Phase1Count)
             3'd0: begin
                Phase1R0wSel = Data00In;
             end
             3'd1: begin
                Phase1R0wSel = Data02In;
             end
             3'd2: begin
                Phase1R0wSel = Data01In;
             end
             3'd3: begin
                Phase1R0wSel = Data05In;
             end
           endcase // case(Phase1Count)
        end // case: 3'd0
        3'd1:begin
           case(Phase1Count)
             3'd0: begin
                Phase1R0wSel = Data08In;
             end
             3'd1: begin
                Phase1R0wSel = Data10In;
             end
             3'd2: begin
                Phase1R0wSel = Data09In;
             end
             3'd3: begin
                Phase1R0wSel = Data13In;
             end
           endcase // case(Phase1Count)
        end // case: 3'd1
        3'd2:begin
           case(Phase1Count)
             3'd0: begin
                Phase1R0wSel = Data16In;
             end
             3'd1: begin
                Phase1R0wSel = Data18In;
             end
             3'd2: begin
                Phase1R0wSel = Data17In;
             end
             3'd3: begin
                Phase1R0wSel = Data21In;
             end
           endcase // case(Phase1Count)
        end // case: 3'd2
        3'd3:begin
           case(Phase1Count)
             3'd0: begin
                Phase1R0wSel = Data24In;
             end
             3'd1: begin
                Phase1R0wSel = Data26In;
             end
             3'd2: begin
                Phase1R0wSel = Data25In;
             end
             3'd3: begin
                Phase1R0wSel = Data29In;
             end
           endcase // case(Phase1Count)
        end // case: 3'd3
        3'd4:begin
           case(Phase1Count)
             3'd0: begin
                Phase1R0wSel = Data32In;
             end
             3'd1: begin
                Phase1R0wSel = Data34In;
             end
             3'd2: begin
                Phase1R0wSel = Data33In;
             end
             3'd3: begin
                Phase1R0wSel = Data37In;
             end
           endcase // case(Phase1Count)
        end // case: 3'd4
        3'd5:begin
           case(Phase1Count)
             3'd0: begin
                Phase1R0wSel = Data40In;
             end
             3'd1: begin
                Phase1R0wSel = Data42In;
             end
             3'd2: begin
                Phase1R0wSel = Data41In;
             end
             3'd3: begin
                Phase1R0wSel = Data45In;
             end
           endcase // case(Phase1Count)
        end // case: 3'd5
        3'd6:begin
           case(Phase1Count)
             3'd0: begin
                Phase1R0wSel = Data48In;
             end
             3'd1: begin
                Phase1R0wSel = Data50In;
             end
             3'd2: begin
                Phase1R0wSel = Data49In;
             end
             3'd3: begin
                Phase1R0wSel = Data53In;
             end
           endcase // case(Phase1Count)
        end // case: 3'd6
        3'd7:begin
           case(Phase1Count)
             3'd0: begin
                Phase1R0wSel = Data56In;
             end
             3'd1: begin
                Phase1R0wSel = Data58In;
             end
             3'd2: begin
                Phase1R0wSel = Data57In;
             end
             3'd3: begin
                Phase1R0wSel = Data61In;
             end
           endcase // case(Phase1Count)
        end // case: 3'd7
      endcase // case(Phase1Page)
	end
	endfunction
	function [15:0] Phase1R1wSel;
		input [2:0]	Phase1Page;
		input [2:0]	Phase1Count;
		input [15:0]	Data00In;
		input [15:0]	Data01In;
		input [15:0]	Data02In;
		input [15:0]	Data03In;
		input [15:0]	Data04In;
		input [15:0]	Data05In;
		input [15:0]	Data06In;
		input [15:0]	Data07In;
		input [15:0]	Data08In;
		input [15:0]	Data09In;
		input [15:0]	Data10In;
		input [15:0]	Data11In;
		input [15:0]	Data12In;
		input [15:0]	Data13In;
		input [15:0]	Data14In;
		input [15:0]	Data15In;
		input [15:0]	Data16In;
		input [15:0]	Data17In;
		input [15:0]	Data18In;
		input [15:0]	Data19In;
		input [15:0]	Data20In;
		input [15:0]	Data21In;
		input [15:0]	Data22In;
		input [15:0]	Data23In;
		input [15:0]	Data24In;
		input [15:0]	Data25In;
		input [15:0]	Data26In;
		input [15:0]	Data27In;
		input [15:0]	Data28In;
		input [15:0]	Data29In;
		input [15:0]	Data30In;
		input [15:0]	Data31In;
		input [15:0]	Data32In;
		input [15:0]	Data33In;
		input [15:0]	Data34In;
		input [15:0]	Data35In;
		input [15:0]	Data36In;
		input [15:0]	Data37In;
		input [15:0]	Data38In;
		input [15:0]	Data39In;
		input [15:0]	Data40In;
		input [15:0]	Data41In;
		input [15:0]	Data42In;
		input [15:0]	Data43In;
		input [15:0]	Data44In;
		input [15:0]	Data45In;
		input [15:0]	Data46In;
		input [15:0]	Data47In;
		input [15:0]	Data48In;
		input [15:0]	Data49In;
		input [15:0]	Data50In;
		input [15:0]	Data51In;
		input [15:0]	Data52In;
		input [15:0]	Data53In;
		input [15:0]	Data54In;
		input [15:0]	Data55In;
		input [15:0]	Data56In;
		input [15:0]	Data57In;
		input [15:0]	Data58In;
		input [15:0]	Data59In;
		input [15:0]	Data60In;
		input [15:0]	Data61In;
		input [15:0]	Data62In;
		input [15:0]	Data63In;
	begin
      case(Phase1Page)
        3'd0:begin
           case(Phase1Count)
             3'd0: begin
                Phase1R1wSel = Data04In;
             end
             3'd1: begin
                Phase1R1wSel = Data06In;
             end
             3'd2: begin
                Phase1R1wSel = Data07In;
             end
             3'd3: begin
                Phase1R1wSel = Data03In;
             end
           endcase // case(Phase1Count)
        end // case: 3'd0
        3'd1:begin
           case(Phase1Count)
             3'd0: begin
                Phase1R1wSel = Data12In;
             end
             3'd1: begin
                Phase1R1wSel = Data14In;
             end
             3'd2: begin
                Phase1R1wSel = Data15In;
             end
             3'd3: begin
                Phase1R1wSel = Data11In;
             end
           endcase // case(Phase1Count)
        end // case: 3'd1
        3'd2:begin
           case(Phase1Count)
             3'd0: begin
                Phase1R1wSel = Data20In;
             end
             3'd1: begin
                Phase1R1wSel = Data22In;
             end
             3'd2: begin
                Phase1R1wSel = Data23In;
             end
             3'd3: begin
                Phase1R1wSel = Data19In;
             end
           endcase // case(Phase1Count)
        end // case: 3'd2
        3'd3:begin
           case(Phase1Count)
             3'd0: begin
                Phase1R1wSel = Data28In;
             end
             3'd1: begin
                Phase1R1wSel = Data30In;
             end
             3'd2: begin
                Phase1R1wSel = Data31In;
             end
             3'd3: begin
                Phase1R1wSel = Data27In;
             end
           endcase // case(Phase1Count)
        end // case: 3'd3
        3'd4:begin
           case(Phase1Count)
             3'd0: begin
                Phase1R1wSel = Data36In;
             end
             3'd1: begin
                Phase1R1wSel = Data38In;
             end
             3'd2: begin
                Phase1R1wSel = Data39In;
             end
             3'd3: begin
                Phase1R1wSel = Data35In;
             end
           endcase // case(Phase1Count)
        end // case: 3'd4
        3'd5:begin
           case(Phase1Count)
             3'd0: begin
                Phase1R1wSel = Data44In;
             end
             3'd1: begin
                Phase1R1wSel = Data46In;
             end
             3'd2: begin
                Phase1R1wSel = Data47In;
             end
             3'd3: begin
                Phase1R1wSel = Data43In;
             end
           endcase // case(Phase1Count)
        end // case: 3'd5
        3'd6:begin
           case(Phase1Count)
             3'd0: begin
                Phase1R1wSel = Data52In;
             end
             3'd1: begin
                Phase1R1wSel = Data54In;
             end
             3'd2: begin
                Phase1R1wSel = Data55In;
             end
             3'd3: begin
                Phase1R1wSel = Data51In;
             end
           endcase // case(Phase1Count)
        end // case: 3'd6
        3'd7:begin
           case(Phase1Count)
             3'd0: begin
                Phase1R1wSel = Data60In;
             end
             3'd1: begin
                Phase1R1wSel = Data62In;
             end
             3'd2: begin
                Phase1R1wSel = Data63In;
             end
             3'd3: begin
                Phase1R1wSel = Data59In;
             end
           endcase // case(Phase1Count)
        end // case: 3'd7
      endcase // case(Phase1Page)
	end
	endfunction

	assign Phase1R0w = Phase1R0wSel(Phase1Page, Phase1Count,
									Data00In, Data01In, Data02In, Data03In, Data04In, Data05In, Data06In, Data07In, Data08In, Data09In,
									Data10In, Data11In, Data12In, Data13In, Data14In, Data15In, Data16In, Data17In, Data18In, Data19In,
									Data20In, Data21In, Data22In, Data23In, Data24In, Data25In, Data26In, Data27In, Data28In, Data29In,
									Data30In, Data31In, Data32In, Data33In, Data34In, Data35In, Data36In, Data37In, Data38In, Data39In,
									Data40In, Data41In, Data42In, Data43In, Data44In, Data45In, Data46In, Data47In, Data48In, Data49In,
									Data50In, Data51In, Data52In, Data53In, Data54In, Data55In, Data56In, Data57In, Data58In, Data59In,
									Data60In, Data61In, Data62In, Data63In
									);
	assign Phase1R1w = Phase1R1wSel(Phase1Page, Phase1Count,
									Data00In, Data01In, Data02In, Data03In, Data04In, Data05In, Data06In, Data07In, Data08In, Data09In,
									Data10In, Data11In, Data12In, Data13In, Data14In, Data15In, Data16In, Data17In, Data18In, Data19In,
									Data20In, Data21In, Data22In, Data23In, Data24In, Data25In, Data26In, Data27In, Data28In, Data29In,
									Data30In, Data31In, Data32In, Data33In, Data34In, Data35In, Data36In, Data37In, Data38In, Data39In,
									Data40In, Data41In, Data42In, Data43In, Data44In, Data45In, Data46In, Data47In, Data48In, Data49In,
									Data50In, Data51In, Data52In, Data53In, Data54In, Data55In, Data56In, Data57In, Data58In, Data59In,
									Data60In, Data61In, Data62In, Data63In
									);
/*
   always @(*) begin
      case(Phase1Count)
        3'd0: begin
           Phase1C0w <= 16'd2896; // C4_16
           Phase1C1w <= 16'd2896; // C4_16
           Phase1C2w <= 16'd2896; // C4_16
           Phase1C3w <= 16'd2896; // C4_16
        end
        3'd1: begin
           Phase1C0w <= 16'd3784; // C2_16
           Phase1C1w <= 16'd1567; // C6_16
           Phase1C2w <= 16'd1567; // C6_16
           Phase1C3w <= 16'd3784; // C2_16
        end
        3'd2: begin
           Phase1C0w <= 16'd4017; // C1_16
           Phase1C1w <= 16'd799;  // C7_16
           Phase1C2w <= 16'd799;  // C7_16
           Phase1C3w <= 16'd4017; // C1_16
        end
        3'd3: begin
           Phase1C0w <= 16'd2276; // C5_16
           Phase1C1w <= 16'd3406; // C3_16
           Phase1C2w <= 16'd3406; // C3_16
           Phase1C3w <= 16'd2276; // C5_16
        end
      endcase // case(Phase1Count)
   end // always @ (*)
*/
	function [15:0] Phase1C0wSel;
		input [2:0]	Phase1Count;
	begin
      case(Phase1Count)
        3'd0: begin
           Phase1C0wSel = 16'd2896; // C4_16
        end
        3'd1: begin
           Phase1C0wSel = 16'd3784; // C2_16
        end
        3'd2: begin
           Phase1C0wSel = 16'd4017; // C1_16
        end
        3'd3: begin
           Phase1C0wSel = 16'd2276; // C5_16
        end
      endcase // case(Phase1Count)
	end
	endfunction

	function [15:0] Phase1C1wSel;
		input [2:0]	Phase1Count;
	begin
      case(Phase1Count)
        3'd0: begin
           Phase1C1wSel = 16'd2896; // C4_16
        end
        3'd1: begin
           Phase1C1wSel = 16'd1567; // C6_16
        end
        3'd2: begin
           Phase1C1wSel = 16'd799;  // C7_16
        end
        3'd3: begin
           Phase1C1wSel = 16'd3406; // C3_16
        end
      endcase // case(Phase1Count)
	end
	endfunction

	function [15:0] Phase1C2wSel;
		input [2:0]	Phase1Count;
	begin
      case(Phase1Count)
        3'd0: begin
           Phase1C2wSel = 16'd2896; // C4_16
        end
        3'd1: begin
           Phase1C2wSel = 16'd1567; // C6_16
        end
        3'd2: begin
           Phase1C2wSel = 16'd799;  // C7_16
        end
        3'd3: begin
           Phase1C2wSel = 16'd3406; // C3_16
        end
      endcase // case(Phase1Count)
	end
	endfunction

	function [15:0] Phase1C3wSel;
		input [2:0]	Phase1Count;
	begin
      case(Phase1Count)
        3'd0: begin
           Phase1C3wSel = 16'd2896; // C4_16
        end
        3'd1: begin
           Phase1C3wSel = 16'd3784; // C2_16
        end
        3'd2: begin
           Phase1C3wSel = 16'd4017; // C1_16
        end
        3'd3: begin
           Phase1C3wSel = 16'd2276; // C5_16
        end
      endcase // case(Phase1Count)
	end
	endfunction

	assign Phase1C0w = Phase1C0wSel(Phase1Count);
	assign Phase1C1w = Phase1C1wSel(Phase1Count);
	assign Phase1C2w = Phase1C2wSel(Phase1Count);
	assign Phase1C3w = Phase1C3wSel(Phase1Count);

   reg signed [31:0] Phase1R0r;
   reg signed [31:0] Phase1R1r;
   reg signed [31:0] Phase1R2r;
   reg signed [31:0] Phase1R3r;
   
   always @(posedge clk or negedge rst) begin
      if(!rst) begin
         Phase1R0r <= 0;
         Phase1R1r <= 0;
         Phase1R2r <= 0;
         Phase1R3r <= 0;
      end else begin
         Phase1R0r <= Phase1R0w * Phase1C0w;
         Phase1R1r <= Phase1R1w * Phase1C1w;
         Phase1R2r <= Phase1R0w * Phase1C2w;
         Phase1R3r <= Phase1R1w * Phase1C3w;
      end // else: !if(!rst)
   end // always @ (posedge clk or negedge rst)

   //-------------------------------------------------------------------------
   // Phase2
   //  R0: s0,s3,s7,s6
   //  R1: s1,s2,s4,s5
   //-------------------------------------------------------------------------
   reg           Phase2Enable;
   reg signed [2:0]     Phase2Page;
   reg signed [2:0]     Phase2Count;
   reg           Phase2EnableD;
   reg signed [2:0]     Phase2PageD;
   reg signed [2:0]     Phase2CountD;
   
   always @(posedge clk or negedge rst) begin
      if(!rst) begin
         Phase2Enable  <= 1'b0;
         Phase2Page    <= 3'd0;
         Phase2Count   <= 3'd0;
         Phase2EnableD <= 1'b0;
         Phase2PageD   <= 3'd0;
         Phase2CountD  <= 3'd0;
      end else begin
         Phase2Enable  <= Phase1Enable;
         Phase2Page    <= Phase1Page;
         Phase2Count   <= Phase1Count;
         Phase2EnableD <= Phase2Enable;
         Phase2PageD   <= Phase2Page;
         Phase2CountD  <= Phase2Count;
      end // else: !if(!rst)
   end // always @ (posedge clk or negedge rst)

   wire signed [31:0] Phase2A0w;
   wire signed [31:0] Phase2A1w;
/*   
   always @(*) begin
      Phase2A0w <= Phase1R0r + Phase1R1r;
      Phase2A1w <= Phase1R2r - Phase1R3r;
   end
*/
	assign Phase2A0w = Phase1R0r + Phase1R1r;
	assign Phase2A1w = Phase1R2r - Phase1R3r;
      
   reg signed [31:0] Phase2Reg [0:7];
   
   always @(posedge clk or negedge rst) begin
      if(!rst) begin
         Phase2Reg[0] <= 0;
         Phase2Reg[1] <= 0;
         Phase2Reg[2] <= 0;
         Phase2Reg[3] <= 0;
         Phase2Reg[4] <= 0;
         Phase2Reg[5] <= 0;
         Phase2Reg[6] <= 0;
         Phase2Reg[7] <= 0;
      end else begin
         case(Phase2Count)
           3'd0: begin
              Phase2Reg[0] <= Phase2A0w;
              Phase2Reg[1] <= Phase2A1w;
           end
           3'd1: begin
              Phase2Reg[3] <= Phase2A0w;
              Phase2Reg[2] <= Phase2A1w;
           end
           3'd2: begin
              Phase2Reg[7] <= Phase2A0w;
              Phase2Reg[4] <= Phase2A1w;
           end
           3'd3: begin
              Phase2Reg[6] <= Phase2A0w;
              Phase2Reg[5] <= Phase2A1w;
           end
         endcase // case(Phase2Count)
      end // else: !if(!rst)
   end // always @ (posedge clk or negedge rst)
   
   //-------------------------------------------------------------------------
   // Phase3
   //  R0: t0,t1,t4,t7
   //  R1: t3,t2,t5,t6
   //-------------------------------------------------------------------------
   reg           Phase3Enable;
   reg [2:0]     Phase3Page;
   reg [2:0]     Phase3Count;
   reg           Phase3EnableD;
   reg [2:0]     Phase3PageD;
   reg [2:0]     Phase3CountD;
   
   always @(posedge clk or negedge rst) begin
      if(!rst) begin
         Phase3Enable  <= 1'b0;
         Phase3Page    <= 3'd0;
         Phase3Count   <= 3'd0;
         Phase3EnableD <= 1'b0;
         Phase3PageD   <= 3'd0;
         Phase3CountD  <= 3'd0;
      end else begin
         Phase3Enable  <= Phase2EnableD;
         Phase3Page    <= Phase2PageD;
         Phase3Count   <= Phase2CountD;
         Phase3EnableD <= Phase3Enable;
         Phase3PageD   <= Phase3Page;
         Phase3CountD  <= Phase3Count;
      end // else: !if(!rst)
   end // always @ (posedge clk or negedge rst)

   //reg signed [31:0] Phase3R0w;
   //reg signed [31:0] Phase3R1w;
   wire signed [31:0] Phase3R0w;
   wire signed [31:0] Phase3R1w;
   
   assign Phase3R0w = (Phase3Count == 3'd0)?Phase2Reg[0]:
                      (Phase3Count == 3'd1)?Phase2Reg[1]:
                      (Phase3Count == 3'd2)?Phase2Reg[4]:
                      (Phase3Count == 3'd3)?Phase2Reg[7]:
                      32'd0;
   assign Phase3R1w = (Phase3Count == 3'd0)?Phase2Reg[3]:
                      (Phase3Count == 3'd1)?Phase2Reg[2]:
                      (Phase3Count == 3'd2)?Phase2Reg[5]:
                      (Phase3Count == 3'd3)?Phase2Reg[6]:
                      32'd0;
   
   
   
   wire signed [31:0] Phase3A0w;
   wire signed [31:0] Phase3A1w;
/*
   always @(*) begin
      Phase3A0w <= Phase3R0w + Phase3R1w;
      Phase3A1w <= Phase3R0w - Phase3R1w;
   end
*/      
	assign Phase3A0w = Phase3R0w + Phase3R1w;
	assign Phase3A1w = Phase3R0w - Phase3R1w;

   reg signed [31:0] Phase3Reg [0:7];
   
   always @(posedge clk or negedge rst) begin
      if(!rst) begin
         Phase3Reg[0] <= 0;
         Phase3Reg[1] <= 0;
         Phase3Reg[2] <= 0;
         Phase3Reg[3] <= 0;
         Phase3Reg[4] <= 0;
         Phase3Reg[5] <= 0;
         Phase3Reg[6] <= 0;
         Phase3Reg[7] <= 0;
      end else begin
         case(Phase3Count)
           3'd0: begin
              Phase3Reg[0] <= Phase3A0w;
              Phase3Reg[3] <= Phase3A1w;
           end
           3'd1: begin
              Phase3Reg[1] <= Phase3A0w;
              Phase3Reg[2] <= Phase3A1w;
           end
           3'd2: begin
              Phase3Reg[4] <= Phase3A0w;
              Phase3Reg[5] <= Phase3A1w;
           end
           3'd3: begin
              Phase3Reg[7] <= Phase3A0w;
              Phase3Reg[6] <= Phase3A1w;
           end
         endcase // case(Phase3Count)
      end // else: !if(!rst)
   end // always @ (posedge clk or negedge rst)
   
   //-------------------------------------------------------------------------
   // Phase4
   //  R0: s6
   //  R1: s5
   //-------------------------------------------------------------------------
   reg           Phase4Enable;
   reg [2:0]     Phase4Page;
   reg [2:0]     Phase4Count;
   reg           Phase4EnableD;
   reg [2:0]     Phase4PageD;
   reg [2:0]     Phase4CountD;
   
   always @(posedge clk or negedge rst) begin
      if(!rst) begin
         Phase4Enable  <= 1'b0;
         Phase4Page    <= 3'd0;
         Phase4Count   <= 3'd0;
         Phase4EnableD <= 1'b0;
         Phase4PageD   <= 3'd0;
         Phase4CountD  <= 3'd0;
      end else begin
         Phase4Enable  <= Phase3EnableD;
         Phase4Page    <= Phase3PageD;
         Phase4Count   <= Phase3CountD;
         Phase4EnableD <= Phase4Enable;
         Phase4PageD   <= Phase4Page;
         Phase4CountD  <= Phase4Count;
      end // else: !if(!rst)
   end // always @ (posedge clk or negedge rst)

   reg signed [42:0] Phase4R0r;
   reg signed [42:0] Phase4R1r;

   wire signed [8:0] C_181;
   assign            C_181 = 9'h0B5;
   
   always @(posedge clk or negedge rst) begin
      if(!rst) begin
         Phase4R0r <= 0;
         Phase4R1r <= 0;
      end else begin
         case(Phase4Count)
           3'd2: begin
              Phase4R0r <= (Phase3Reg[6] + Phase3Reg[5]) * C_181;
              Phase4R1r <= (Phase3Reg[6] - Phase3Reg[5]) * C_181;
           end
         endcase // case(Phase4Count)
      end // else: !if(!rst)
   end // always @ (posedge clk or negedge rst)
   
   //-------------------------------------------------------------------------
   // Phase5
   //  R0: B0,B1,B2,B3
   //  R1: B7,B6,B5,B4
   //-------------------------------------------------------------------------
   reg           Phase5Enable;
   reg [2:0]     Phase5Page;
   reg [2:0]     Phase5Count;
   reg           Phase5EnableD;
   reg [2:0]     Phase5PageD;
   reg [2:0]     Phase5CountD;
   
   always @(posedge clk or negedge rst) begin
      if(!rst) begin
         Phase5Enable  <= 1'b0;
         Phase5Page    <= 3'd0;
         Phase5Count   <= 3'd0;
         Phase5EnableD <= 1'b0;
         Phase5PageD   <= 3'd0;
         Phase5CountD  <= 3'd0;
      end else begin
         Phase5Enable  <= Phase4EnableD;
         Phase5Page    <= Phase4PageD;
         Phase5Count   <= Phase4CountD;
         Phase5EnableD <= Phase5Enable;
         Phase5PageD   <= Phase5Page;
         Phase5CountD  <= Phase5Count;
      end // else: !if(!rst)
   end // always @ (posedge clk or negedge rst)

   wire signed [31:0] Phase5R0w;
   wire signed [31:0] Phase5R1w;
   assign Phase5R0w = (Phase5Count == 3'd0)?Phase3Reg[0]:
                      (Phase5Count == 3'd1)?Phase3Reg[1]:
                      (Phase5Count == 3'd2)?Phase3Reg[2]:
                      (Phase5Count == 3'd3)?Phase3Reg[3]:
                      32'd0;
   assign Phase5R1w = (Phase5Count == 3'd0)?Phase3Reg[7]:
                      (Phase5Count == 3'd1)?Phase4R0r >> 8:
                      (Phase5Count == 3'd2)?Phase4R1r >> 8:
                      (Phase5Count == 3'd3)?Phase3Reg[4]:
                      32'd0; 
  
   
   reg signed [31:0] Phase5R0r;
   reg signed [31:0] Phase5R1r;

   always @(posedge clk or negedge rst) begin
      if(!rst) begin
         Phase5R0r <= 0;
         Phase5R1r <= 0;
      end else begin
         Phase5R0r <= Phase5R0w + Phase5R1w;
         Phase5R1r <= Phase5R0w - Phase5R1w;
      end
   end

   assign DataOutEnable = Phase5EnableD == 1'b1 & Phase5CountD[2] == 1'b0;
   assign DataOutPage   = Phase5PageD;
   assign DataOutCount  = Phase5CountD[1:0];
   
   assign Data0Out = Phase5R0r[26:11];
   assign Data1Out = Phase5R1r[26:11];
   
endmodule // jpeg_idctx
