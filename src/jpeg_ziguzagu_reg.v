//---------------------------------------------------------------------------
// File Name   : jpeg_ziguzagu_reg.v
// Module Name : jpeg_ziguzagu_reg
// Description : Register for ziguzagu
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

module jpeg_ziguzagu_reg
  (
   rst,
   clk,

   DataInEnable,
   DataInAddress,
   DataIn,

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
   Data63Reg
   );

   input         clk;
   input         rst;

   input 	 DataInEnable;
   input [5:0] 	 DataInAddress;
   input [15:0]  DataIn;

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
   
   reg [15:0] 	 RegData [0:63]; // Register Memory

   integer 	 i;

/*   
   always @(posedge clk or negedge rst) begin
      if(!rst) begin
         RegData[0] <= 16'h0000;
         RegData[1] <= 16'h0000;
         RegData[2] <= 16'h0000;
         RegData[3] <= 16'h0000;
         RegData[4] <= 16'h0000;
         RegData[5] <= 16'h0000;
         RegData[6] <= 16'h0000;
         RegData[7] <= 16'h0000;
         RegData[8] <= 16'h0000;
         RegData[9] <= 16'h0000;
         RegData[10] <= 16'h0000;
         RegData[11] <= 16'h0000;
         RegData[12] <= 16'h0000;
         RegData[13] <= 16'h0000;
         RegData[14] <= 16'h0000;
         RegData[15] <= 16'h0000;
         RegData[16] <= 16'h0000;
         RegData[17] <= 16'h0000;
         RegData[18] <= 16'h0000;
         RegData[19] <= 16'h0000;
         RegData[20] <= 16'h0000;
         RegData[21] <= 16'h0000;
         RegData[22] <= 16'h0000;
         RegData[23] <= 16'h0000;
         RegData[24] <= 16'h0000;
         RegData[25] <= 16'h0000;
         RegData[26] <= 16'h0000;
         RegData[27] <= 16'h0000;
         RegData[28] <= 16'h0000;
         RegData[29] <= 16'h0000;
         RegData[30] <= 16'h0000;
         RegData[31] <= 16'h0000;
         RegData[32] <= 16'h0000;
         RegData[33] <= 16'h0000;
         RegData[34] <= 16'h0000;
         RegData[35] <= 16'h0000;
         RegData[36] <= 16'h0000;
         RegData[37] <= 16'h0000;
         RegData[38] <= 16'h0000;
         RegData[39] <= 16'h0000;
         RegData[40] <= 16'h0000;
         RegData[41] <= 16'h0000;
         RegData[42] <= 16'h0000;
         RegData[43] <= 16'h0000;
         RegData[44] <= 16'h0000;
         RegData[45] <= 16'h0000;
         RegData[46] <= 16'h0000;
         RegData[47] <= 16'h0000;
         RegData[48] <= 16'h0000;
         RegData[49] <= 16'h0000;
         RegData[50] <= 16'h0000;
         RegData[51] <= 16'h0000;
         RegData[52] <= 16'h0000;
         RegData[53] <= 16'h0000;
         RegData[54] <= 16'h0000;
         RegData[55] <= 16'h0000;
         RegData[56] <= 16'h0000;
         RegData[57] <= 16'h0000;
         RegData[58] <= 16'h0000;
         RegData[59] <= 16'h0000;
         RegData[60] <= 16'h0000;
         RegData[61] <= 16'h0000;
         RegData[62] <= 16'h0000;
         RegData[63] <= 16'h0000;
      end else begin // if (!rst)
	 if(DataInEnable == 1'b1) begin
	    RegData[DataInAddress] <= DataIn;
	    if(DataInAddress == 6'h00) begin
	       for(i=1;i<64;i=i+1) begin
		  RegData[i]  <= 16'h0000;
	       end
	    end
         end
      end // else: !if(!rst)
   end // always @ (posedge clk or negedge rst)
*/
	always @(posedge clk or negedge rst) begin
		if(!rst) begin
			RegData[0] <= 16'h0000;
			RegData[1] <= 16'h0000;
         RegData[2] <= 16'h0000;
         RegData[3] <= 16'h0000;
         RegData[4] <= 16'h0000;
         RegData[5] <= 16'h0000;
         RegData[6] <= 16'h0000;
         RegData[7] <= 16'h0000;
         RegData[8] <= 16'h0000;
         RegData[9] <= 16'h0000;
         RegData[10] <= 16'h0000;
         RegData[11] <= 16'h0000;
         RegData[12] <= 16'h0000;
         RegData[13] <= 16'h0000;
         RegData[14] <= 16'h0000;
         RegData[15] <= 16'h0000;
         RegData[16] <= 16'h0000;
         RegData[17] <= 16'h0000;
         RegData[18] <= 16'h0000;
         RegData[19] <= 16'h0000;
         RegData[20] <= 16'h0000;
         RegData[21] <= 16'h0000;
         RegData[22] <= 16'h0000;
         RegData[23] <= 16'h0000;
         RegData[24] <= 16'h0000;
         RegData[25] <= 16'h0000;
         RegData[26] <= 16'h0000;
         RegData[27] <= 16'h0000;
         RegData[28] <= 16'h0000;
         RegData[29] <= 16'h0000;
         RegData[30] <= 16'h0000;
         RegData[31] <= 16'h0000;
         RegData[32] <= 16'h0000;
         RegData[33] <= 16'h0000;
         RegData[34] <= 16'h0000;
         RegData[35] <= 16'h0000;
         RegData[36] <= 16'h0000;
         RegData[37] <= 16'h0000;
         RegData[38] <= 16'h0000;
         RegData[39] <= 16'h0000;
         RegData[40] <= 16'h0000;
         RegData[41] <= 16'h0000;
         RegData[42] <= 16'h0000;
         RegData[43] <= 16'h0000;
         RegData[44] <= 16'h0000;
         RegData[45] <= 16'h0000;
         RegData[46] <= 16'h0000;
         RegData[47] <= 16'h0000;
         RegData[48] <= 16'h0000;
         RegData[49] <= 16'h0000;
         RegData[50] <= 16'h0000;
         RegData[51] <= 16'h0000;
         RegData[52] <= 16'h0000;
         RegData[53] <= 16'h0000;
         RegData[54] <= 16'h0000;
         RegData[55] <= 16'h0000;
         RegData[56] <= 16'h0000;
         RegData[57] <= 16'h0000;
         RegData[58] <= 16'h0000;
         RegData[59] <= 16'h0000;
         RegData[60] <= 16'h0000;
         RegData[61] <= 16'h0000;
         RegData[62] <= 16'h0000;
         RegData[63] <= 16'h0000;
		end else begin
			if(DataInEnable == 1'b1) begin
				case(DataInAddress)
				6'd0: begin
			RegData[0] <= DataIn;
			RegData[1] <= 16'h0000;
         RegData[2] <= 16'h0000;
         RegData[3] <= 16'h0000;
         RegData[4] <= 16'h0000;
         RegData[5] <= 16'h0000;
         RegData[6] <= 16'h0000;
         RegData[7] <= 16'h0000;
         RegData[8] <= 16'h0000;
         RegData[9] <= 16'h0000;
         RegData[10] <= 16'h0000;
         RegData[11] <= 16'h0000;
         RegData[12] <= 16'h0000;
         RegData[13] <= 16'h0000;
         RegData[14] <= 16'h0000;
         RegData[15] <= 16'h0000;
         RegData[16] <= 16'h0000;
         RegData[17] <= 16'h0000;
         RegData[18] <= 16'h0000;
         RegData[19] <= 16'h0000;
         RegData[20] <= 16'h0000;
         RegData[21] <= 16'h0000;
         RegData[22] <= 16'h0000;
         RegData[23] <= 16'h0000;
         RegData[24] <= 16'h0000;
         RegData[25] <= 16'h0000;
         RegData[26] <= 16'h0000;
         RegData[27] <= 16'h0000;
         RegData[28] <= 16'h0000;
         RegData[29] <= 16'h0000;
         RegData[30] <= 16'h0000;
         RegData[31] <= 16'h0000;
         RegData[32] <= 16'h0000;
         RegData[33] <= 16'h0000;
         RegData[34] <= 16'h0000;
         RegData[35] <= 16'h0000;
         RegData[36] <= 16'h0000;
         RegData[37] <= 16'h0000;
         RegData[38] <= 16'h0000;
         RegData[39] <= 16'h0000;
         RegData[40] <= 16'h0000;
         RegData[41] <= 16'h0000;
         RegData[42] <= 16'h0000;
         RegData[43] <= 16'h0000;
         RegData[44] <= 16'h0000;
         RegData[45] <= 16'h0000;
         RegData[46] <= 16'h0000;
         RegData[47] <= 16'h0000;
         RegData[48] <= 16'h0000;
         RegData[49] <= 16'h0000;
         RegData[50] <= 16'h0000;
         RegData[51] <= 16'h0000;
         RegData[52] <= 16'h0000;
         RegData[53] <= 16'h0000;
         RegData[54] <= 16'h0000;
         RegData[55] <= 16'h0000;
         RegData[56] <= 16'h0000;
         RegData[57] <= 16'h0000;
         RegData[58] <= 16'h0000;
         RegData[59] <= 16'h0000;
         RegData[60] <= 16'h0000;
         RegData[61] <= 16'h0000;
         RegData[62] <= 16'h0000;
         RegData[63] <= 16'h0000;
				end
				6'd1:	RegData[1]	<= DataIn;
				6'd2:	RegData[2]	<= DataIn;
				6'd3:	RegData[3]	<= DataIn;
				6'd4:	RegData[4]	<= DataIn;
				6'd5:	RegData[5]	<= DataIn;
				6'd6:	RegData[6]	<= DataIn;
				6'd7:	RegData[7]	<= DataIn;
				6'd8:	RegData[8]	<= DataIn;
				6'd9:	RegData[9]	<= DataIn;
				6'd10:	RegData[10]	<= DataIn;
				6'd11:	RegData[11]	<= DataIn;
				6'd12:	RegData[12]	<= DataIn;
				6'd13:	RegData[13]	<= DataIn;
				6'd14:	RegData[14]	<= DataIn;
				6'd15:	RegData[15]	<= DataIn;
				6'd16:	RegData[16]	<= DataIn;
				6'd17:	RegData[17]	<= DataIn;
				6'd18:	RegData[18]	<= DataIn;
				6'd19:	RegData[19]	<= DataIn;
				6'd20:	RegData[20]	<= DataIn;
				6'd21:	RegData[21]	<= DataIn;
				6'd22:	RegData[22]	<= DataIn;
				6'd23:	RegData[23]	<= DataIn;
				6'd24:	RegData[24]	<= DataIn;
				6'd25:	RegData[25]	<= DataIn;
				6'd26:	RegData[26]	<= DataIn;
				6'd27:	RegData[27]	<= DataIn;
				6'd28:	RegData[28]	<= DataIn;
				6'd29:	RegData[29]	<= DataIn;
				6'd30:	RegData[30]	<= DataIn;
				6'd31:	RegData[31]	<= DataIn;
				6'd32:	RegData[32]	<= DataIn;
				6'd33:	RegData[33]	<= DataIn;
				6'd34:	RegData[34]	<= DataIn;
				6'd35:	RegData[35]	<= DataIn;
				6'd36:	RegData[36]	<= DataIn;
				6'd37:	RegData[37]	<= DataIn;
				6'd38:	RegData[38]	<= DataIn;
				6'd39:	RegData[39]	<= DataIn;
				6'd40:	RegData[40]	<= DataIn;
				6'd41:	RegData[41]	<= DataIn;
				6'd42:	RegData[42]	<= DataIn;
				6'd43:	RegData[43]	<= DataIn;
				6'd44:	RegData[44]	<= DataIn;
				6'd45:	RegData[45]	<= DataIn;
				6'd46:	RegData[46]	<= DataIn;
				6'd47:	RegData[47]	<= DataIn;
				6'd48:	RegData[48]	<= DataIn;
				6'd49:	RegData[49]	<= DataIn;
				6'd50:	RegData[50]	<= DataIn;
				6'd51:	RegData[51]	<= DataIn;
				6'd52:	RegData[52]	<= DataIn;
				6'd53:	RegData[53]	<= DataIn;
				6'd54:	RegData[54]	<= DataIn;
				6'd55:	RegData[55]	<= DataIn;
				6'd56:	RegData[56]	<= DataIn;
				6'd57:	RegData[57]	<= DataIn;
				6'd58:	RegData[58]	<= DataIn;
				6'd59:	RegData[59]	<= DataIn;
				6'd60:	RegData[60]	<= DataIn;
				6'd61:	RegData[61]	<= DataIn;
				6'd62:	RegData[62]	<= DataIn;
				6'd63:	RegData[63]	<= DataIn;
				endcase
			end
		end // else: !if(!rst)
	end // always @ (posedge clk or negedge rst)
  
   assign Data00Reg = RegData[00];
   assign Data01Reg = RegData[01];
   assign Data08Reg = RegData[02];
   assign Data16Reg = RegData[03];
   assign Data09Reg = RegData[04];
   assign Data02Reg = RegData[05];
   assign Data03Reg = RegData[06];
   assign Data10Reg = RegData[07];
   assign Data17Reg = RegData[08];
   assign Data24Reg = RegData[09];
   assign Data32Reg = RegData[10];
   assign Data25Reg = RegData[11];
   assign Data18Reg = RegData[12];
   assign Data11Reg = RegData[13];
   assign Data04Reg = RegData[14];
   assign Data05Reg = RegData[15];
   assign Data12Reg = RegData[16];
   assign Data19Reg = RegData[17];
   assign Data26Reg = RegData[18];
   assign Data33Reg = RegData[19];
   assign Data40Reg = RegData[20];
   assign Data48Reg = RegData[21];
   assign Data41Reg = RegData[22];
   assign Data34Reg = RegData[23];
   assign Data27Reg = RegData[24];
   assign Data20Reg = RegData[25];
   assign Data13Reg = RegData[26];
   assign Data06Reg = RegData[27];
   assign Data07Reg = RegData[28];
   assign Data14Reg = RegData[29];
   assign Data21Reg = RegData[30];
   assign Data28Reg = RegData[31];
   assign Data35Reg = RegData[32];
   assign Data42Reg = RegData[33];
   assign Data49Reg = RegData[34];
   assign Data56Reg = RegData[35];
   assign Data57Reg = RegData[36];
   assign Data50Reg = RegData[37];
   assign Data43Reg = RegData[38];
   assign Data36Reg = RegData[39];
   assign Data29Reg = RegData[40];
   assign Data22Reg = RegData[41];
   assign Data15Reg = RegData[42];
   assign Data23Reg = RegData[43];
   assign Data30Reg = RegData[44];
   assign Data37Reg = RegData[45];
   assign Data44Reg = RegData[46];
   assign Data51Reg = RegData[47];
   assign Data58Reg = RegData[48];
   assign Data59Reg = RegData[49];
   assign Data52Reg = RegData[50];
   assign Data45Reg = RegData[51];
   assign Data38Reg = RegData[52];
   assign Data31Reg = RegData[53];
   assign Data39Reg = RegData[54];
   assign Data46Reg = RegData[55];
   assign Data53Reg = RegData[56];
   assign Data60Reg = RegData[57];
   assign Data61Reg = RegData[58];
   assign Data54Reg = RegData[59];
   assign Data47Reg = RegData[60];
   assign Data55Reg = RegData[61];
   assign Data62Reg = RegData[62];
   assign Data63Reg = RegData[63];
   
endmodule // jpeg_ziguzagu_reg
