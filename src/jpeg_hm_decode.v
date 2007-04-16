//---------------------------------------------------------------------------
// File Name   : jpeg_hm_decode.v
// Module Name : jpeg_hm_decode
// Description : Decode of Haffuman data
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
// 1.02 2006/10/04 move for a comment widh OutData,OutDhtNumber register.
//                 remove a ProcessColorNumber,tempPlace register.
//---------------------------------------------------------------------------
// $Id: 
//---------------------------------------------------------------------------
`timescale 1ps / 1ps

module jpeg_hm_decode
  (
   rst, // Reset
   clk, // Clock

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

   // DHT table
   DhtColor,           // Color Number
   DhtNumber,          // Decode Dht Number
   DhtZero,            // Zero Count of Dht Number
   DhtWidth,           // Data Width of Dht Number 

   // DQT Table
   DqtColor,           // Color Number
   DqtNumber,          // Dqt Number
   DqtData,            // Dqt Data

   //
   DataOutIdle,
   DataOutEnable,
   DataOutColor,
   
   // Output decode data   
   DecodeUseBit,        // Used Data Bit
   DecodeUseWidth,      // Used Data Width
   DecodeEnable,        // Data Out Enable
   DecodeColor,         // Data Out Enable
   DecodeCount,         // Data Out Enable
   DecodeZero,          // Data Out with Zero Count
   DecodeCode           // Data Out with Code
   );

   //--------------------------------------------------------------------------
   // Input/Output
   //--------------------------------------------------------------------------
   input         rst,clk;             // Reset and Clock
   input         HaffumanTableEnable; // Table Data In Enable
   input [1:0]   HaffumanTableColor;
   input [3:0]   HaffumanTableCount;  // Table Number
   input [15:0]  HaffumanTableCode;   // Haffuman Table Data
   input [7:0]   HaffumanTableStart;  // Haffuman Table Start Number

   input         DataInRun;
   input         DataInEnable;        // Data In Enable
   input [31:0]  DataIn;              // Data In

   output [1:0]  DhtColor;
   output [7:0]  DhtNumber;          // Decode Dht Number
   input [3:0]   DhtZero;            // Zero Count of Dht Number
   input [3:0]   DhtWidth;           // Data Width of Dht Number

   output        DqtColor;
   output [5:0]  DqtNumber;
   input [7:0]   DqtData;

   input         DataOutIdle;
   output        DataOutEnable;
   output [2:0]  DataOutColor;
   
   
   output        DecodeUseBit;
   output [6:0]  DecodeUseWidth;   // Used Data Width
   output        DecodeEnable;     // Data Out Enable
   output [2:0]  DecodeColor;
   output [5:0]  DecodeCount;
   output [3:0]  DecodeZero;       // Data Out with Zero Count
   output [15:0] DecodeCode;       // Data Out with Code

   //--------------------------------------------------------------------------
   // Register Haffuman Table(YCbCr)
   //--------------------------------------------------------------------------
   // Y-DC Haffuman Table
   reg [15:0]    HaffumanTable0r [0:15]; // Y-DC Haffuman Table
   reg [15:0]    HaffumanTable1r [0:15]; // Y-AC Haffuman Table
   reg [15:0]    HaffumanTable2r [0:15]; // C-DC Haffuman Table
   reg [15:0]    HaffumanTable3r [0:15]; // C-AC Haffuman Table

   reg [15:0]    HaffumanNumber0r [0:15]; // Y-DC Haffuman Number
   reg [15:0]    HaffumanNumber1r [0:15]; // Y-AC Haffuman Number
   reg [15:0]    HaffumanNumber2r [0:15]; // C-DC Haffuman Number
   reg [15:0]    HaffumanNumber3r [0:15]; // C-AC Haffuman Number

   integer       i;
   
   always @(posedge clk or negedge rst) begin
      if(!rst) begin
            HaffumanTable0r[0]  <= 16'h0000; 
            HaffumanNumber0r[0] <=  8'h00;
            HaffumanTable1r[0]  <= 16'h0000; 
            HaffumanNumber1r[0] <=  8'h00;
            HaffumanTable2r[0]  <= 16'h0000; 
            HaffumanNumber2r[0] <=  8'h00;
            HaffumanTable3r[0]  <= 16'h0000; 
            HaffumanNumber3r[0] <=  8'h00;

            HaffumanTable0r[1]  <= 16'h0000; 
            HaffumanNumber0r[1] <=  8'h00;
            HaffumanTable1r[1]  <= 16'h0000; 
            HaffumanNumber1r[1] <=  8'h00;
            HaffumanTable2r[1]  <= 16'h0000; 
            HaffumanNumber2r[1] <=  8'h00;
            HaffumanTable3r[1]  <= 16'h0000; 
            HaffumanNumber3r[1] <=  8'h00;

            HaffumanTable0r[2]  <= 16'h0000; 
            HaffumanNumber0r[2] <=  8'h00;
            HaffumanTable1r[2]  <= 16'h0000; 
            HaffumanNumber1r[2] <=  8'h00;
            HaffumanTable2r[2]  <= 16'h0000; 
            HaffumanNumber2r[2] <=  8'h00;
            HaffumanTable3r[2]  <= 16'h0000; 
            HaffumanNumber3r[2] <=  8'h00;

            HaffumanTable0r[3]  <= 16'h0000; 
            HaffumanNumber0r[3] <=  8'h00;
            HaffumanTable1r[3]  <= 16'h0000; 
            HaffumanNumber1r[3] <=  8'h00;
            HaffumanTable2r[3]  <= 16'h0000; 
            HaffumanNumber2r[3] <=  8'h00;
            HaffumanTable3r[3]  <= 16'h0000; 
            HaffumanNumber3r[3] <=  8'h00;

            HaffumanTable0r[4]  <= 16'h0000; 
            HaffumanNumber0r[4] <=  8'h00;
            HaffumanTable1r[4]  <= 16'h0000; 
            HaffumanNumber1r[4] <=  8'h00;
            HaffumanTable2r[4]  <= 16'h0000; 
            HaffumanNumber2r[4] <=  8'h00;
            HaffumanTable3r[4]  <= 16'h0000; 
            HaffumanNumber3r[4] <=  8'h00;

            HaffumanTable0r[5]  <= 16'h0000; 
            HaffumanNumber0r[5] <=  8'h00;
            HaffumanTable1r[5]  <= 16'h0000; 
            HaffumanNumber1r[5] <=  8'h00;
            HaffumanTable2r[5]  <= 16'h0000; 
            HaffumanNumber2r[5] <=  8'h00;
            HaffumanTable3r[5]  <= 16'h0000; 
            HaffumanNumber3r[5] <=  8'h00;

            HaffumanTable0r[6]  <= 16'h0000; 
            HaffumanNumber0r[6] <=  8'h00;
            HaffumanTable1r[6]  <= 16'h0000; 
            HaffumanNumber1r[6] <=  8'h00;
            HaffumanTable2r[6]  <= 16'h0000; 
            HaffumanNumber2r[6] <=  8'h00;
            HaffumanTable3r[6]  <= 16'h0000; 
            HaffumanNumber3r[6] <=  8'h00;

            HaffumanTable0r[7]  <= 16'h0000; 
            HaffumanNumber0r[7] <=  8'h00;
            HaffumanTable1r[7]  <= 16'h0000; 
            HaffumanNumber1r[7] <=  8'h00;
            HaffumanTable2r[7]  <= 16'h0000; 
            HaffumanNumber2r[7] <=  8'h00;
            HaffumanTable3r[7]  <= 16'h0000; 
            HaffumanNumber3r[7] <=  8'h00;

            HaffumanTable0r[8]  <= 16'h0000; 
            HaffumanNumber0r[8] <=  8'h00;
            HaffumanTable1r[8]  <= 16'h0000; 
            HaffumanNumber1r[8] <=  8'h00;
            HaffumanTable2r[8]  <= 16'h0000; 
            HaffumanNumber2r[8] <=  8'h00;
            HaffumanTable3r[8]  <= 16'h0000; 
            HaffumanNumber3r[8] <=  8'h00;

            HaffumanTable0r[9]  <= 16'h0000; 
            HaffumanNumber0r[9] <=  8'h00;
            HaffumanTable1r[9]  <= 16'h0000; 
            HaffumanNumber1r[9] <=  8'h00;
            HaffumanTable2r[9]  <= 16'h0000; 
            HaffumanNumber2r[9] <=  8'h00;
            HaffumanTable3r[9]  <= 16'h0000; 
            HaffumanNumber3r[9] <=  8'h00;

            HaffumanTable0r[10]  <= 16'h0000; 
            HaffumanNumber0r[10] <=  8'h00;
            HaffumanTable1r[10]  <= 16'h0000; 
            HaffumanNumber1r[10] <=  8'h00;
            HaffumanTable2r[10]  <= 16'h0000; 
            HaffumanNumber2r[10] <=  8'h00;
            HaffumanTable3r[10]  <= 16'h0000; 
            HaffumanNumber3r[10] <=  8'h00;

            HaffumanTable0r[11]  <= 16'h0000; 
            HaffumanNumber0r[11] <=  8'h00;
            HaffumanTable1r[11]  <= 16'h0000; 
            HaffumanNumber1r[11] <=  8'h00;
            HaffumanTable2r[11]  <= 16'h0000; 
            HaffumanNumber2r[11] <=  8'h00;
            HaffumanTable3r[11]  <= 16'h0000; 
            HaffumanNumber3r[11] <=  8'h00;

            HaffumanTable0r[12]  <= 16'h0000; 
            HaffumanNumber0r[12] <=  8'h00;
            HaffumanTable1r[12]  <= 16'h0000; 
            HaffumanNumber1r[12] <=  8'h00;
            HaffumanTable2r[12]  <= 16'h0000; 
            HaffumanNumber2r[12] <=  8'h00;
            HaffumanTable3r[12]  <= 16'h0000; 
            HaffumanNumber3r[12] <=  8'h00;

            HaffumanTable0r[13]  <= 16'h0000; 
            HaffumanNumber0r[13] <=  8'h00;
            HaffumanTable1r[13]  <= 16'h0000; 
            HaffumanNumber1r[13] <=  8'h00;
            HaffumanTable2r[13]  <= 16'h0000; 
            HaffumanNumber2r[13] <=  8'h00;
            HaffumanTable3r[13]  <= 16'h0000; 
            HaffumanNumber3r[13] <=  8'h00;

            HaffumanTable0r[14]  <= 16'h0000; 
            HaffumanNumber0r[14] <=  8'h00;
            HaffumanTable1r[14]  <= 16'h0000; 
            HaffumanNumber1r[14] <=  8'h00;
            HaffumanTable2r[14]  <= 16'h0000; 
            HaffumanNumber2r[14] <=  8'h00;
            HaffumanTable3r[14]  <= 16'h0000; 
            HaffumanNumber3r[14] <=  8'h00;

            HaffumanTable0r[15]  <= 16'h0000; 
            HaffumanNumber0r[15] <=  8'h00;
            HaffumanTable1r[15]  <= 16'h0000; 
            HaffumanNumber1r[15] <=  8'h00;
            HaffumanTable2r[15]  <= 16'h0000; 
            HaffumanNumber2r[15] <=  8'h00;
            HaffumanTable3r[15]  <= 16'h0000; 
            HaffumanNumber3r[15] <=  8'h00;
      end else begin // if (!rst)
         if(HaffumanTableEnable ==2'b1) begin
            if(HaffumanTableColor ==2'b00) begin
               HaffumanTable0r[HaffumanTableCount]  <= HaffumanTableCode;
               HaffumanNumber0r[HaffumanTableCount] <= HaffumanTableStart;
            end else if(HaffumanTableColor ==2'b01) begin
               HaffumanTable1r[HaffumanTableCount]  <= HaffumanTableCode;
               HaffumanNumber1r[HaffumanTableCount] <= HaffumanTableStart;
            end else if(HaffumanTableColor ==2'b10) begin
               HaffumanTable2r[HaffumanTableCount]  <= HaffumanTableCode;
               HaffumanNumber2r[HaffumanTableCount] <= HaffumanTableStart;
            end else begin
               HaffumanTable3r[HaffumanTableCount]  <= HaffumanTableCode;
               HaffumanNumber3r[HaffumanTableCount] <= HaffumanTableStart;
            end
         end // if (HaffumanTableEnable ==2'b1)
      end // else: !if(!rst)
   end // always @ (posedge clk or negedge rst)
   
   //--------------------------------------------------------------------------
   // Decode Process
   //--------------------------------------------------------------------------
   reg [3:0]       Process;            // Process State
   reg [31:0] 	   ProcessData;        // Data
   
   // Haffuman Table
   reg [15:0] 	   HaffumanTable [0:15];
   // Haffuman Table Number
   reg [7:0] 	   HaffumanNumber [0:15];
   
   reg [15:0] 	   Place;           // Place bit
   reg [15:0] 	   TableCode;       // Table Code
   reg [7:0] 	   NumberCode;      // Start Number of Table Code
   reg [3:0] 	   CodeNumber;      // Haffuman code width
   reg [15:0] 	   DataNumber;      // Haffuman code
   //reg [15:0]    SubData;         // Haffuman Dht Number

   //reg [7:0] 	   OutDhtNumber;    // Output Dht Number
   
   reg [2:0] 	   ProcessColor;
   reg [6:0] 	   ProcessCount;
   reg [6:0] 	   NextProcessCount;
   
   reg 		   OutEnable;       // Output Enable
   reg [3:0] 	   OutZero;         // Output Zero Count
   reg [15:0] 	   OutCode;         // Output Data Code
   wire [15:0] 	   OutCodeP;        // Output Data Code
   
   reg [4:0] 	   UseWidth;        // Output used width
   
   //reg [23:0] 	   OutData;
   
   reg 		   DataOutEnable;
   reg [2:0] 	   DataOutColor;
   
   reg signed [31:0] PreData [0:2];
   
   wire [15:0] 	     SubCode;
   
   parameter 	     ProcIdle = 4'h0;
   parameter 	     Phase1   = 4'h1;
   parameter 	     Phase2   = 4'h2;
   parameter 	     Phase3   = 4'h3;
   parameter 	     Phase4   = 4'h4;
   parameter 	     Phase5   = 4'h5;
   parameter 	     Phase6   = 4'h6;
   parameter 	     Phase7   = 4'h7;
   parameter 	     Phase8   = 4'h8;
   parameter 	     Phase9   = 4'h9;
   parameter 	     Phase10  = 4'hA;
   parameter 	     Phase11  = 4'hB;

/*
   always @(*) begin
      case (DhtWidth)
        4'h0: OutCodeP <= 16'h0000;
        4'h1: OutCodeP <= {15'h0000,ProcessData[31]};
        4'h2: OutCodeP <= {14'h0000,ProcessData[31:30]};
        4'h3: OutCodeP <= {13'h0000,ProcessData[31:29]};
        4'h4: OutCodeP <= {12'h000, ProcessData[31:28]};
        4'h5: OutCodeP <= {11'h000, ProcessData[31:27]};
        4'h6: OutCodeP <= {10'h000, ProcessData[31:26]};
        4'h7: OutCodeP <= {9'h000,  ProcessData[31:25]};
        4'h8: OutCodeP <= {8'h00,   ProcessData[31:24]};
        4'h9: OutCodeP <= {7'h00,   ProcessData[31:23]};
        4'hA: OutCodeP <= {6'h00,   ProcessData[31:22]};
        4'hB: OutCodeP <= {5'h00,   ProcessData[31:21]};
        4'hC: OutCodeP <= {4'h0,    ProcessData[31:20]};
        4'hD: OutCodeP <= {3'h0,    ProcessData[31:19]};
        4'hE: OutCodeP <= {2'h0,    ProcessData[31:18]};
        4'hF: OutCodeP <= {1'h0,    ProcessData[31:17]};
      endcase // case(DhtWidth)
      case (DhtWidth)
        4'h0: SubCode <= 16'hFFFF;
        4'h1: SubCode <= 16'hFFFE;
        4'h2: SubCode <= 16'hFFFC;
        4'h3: SubCode <= 16'hFFF8;
        4'h4: SubCode <= 16'hFFF0;
        4'h5: SubCode <= 16'hFFE0;
        4'h6: SubCode <= 16'hFFC0;
        4'h7: SubCode <= 16'hFF80;
        4'h8: SubCode <= 16'hFF00;
        4'h9: SubCode <= 16'hFE00;
        4'hA: SubCode <= 16'hFC00;
        4'hB: SubCode <= 16'hF800;
        4'hC: SubCode <= 16'hF000;
        4'hD: SubCode <= 16'hE000;
        4'hE: SubCode <= 16'hC000;
        4'hF: SubCode <= 16'h8000;
      endcase // case(DhtWidth)
   end // always @ (*)
*/

	function [15:0] OutCodePSel;
		input [3:0]	DhtWidth;
		input [31:0]	ProcessData;
	begin
		case (DhtWidth)
        4'h0: OutCodePSel = 16'h0000;
        4'h1: OutCodePSel = {15'h0000,ProcessData[31]};
        4'h2: OutCodePSel = {14'h0000,ProcessData[31:30]};
        4'h3: OutCodePSel = {13'h0000,ProcessData[31:29]};
        4'h4: OutCodePSel = {12'h000, ProcessData[31:28]};
        4'h5: OutCodePSel = {11'h000, ProcessData[31:27]};
        4'h6: OutCodePSel = {10'h000, ProcessData[31:26]};
        4'h7: OutCodePSel = {9'h000,  ProcessData[31:25]};
        4'h8: OutCodePSel = {8'h00,   ProcessData[31:24]};
        4'h9: OutCodePSel = {7'h00,   ProcessData[31:23]};
        4'hA: OutCodePSel = {6'h00,   ProcessData[31:22]};
        4'hB: OutCodePSel = {5'h00,   ProcessData[31:21]};
        4'hC: OutCodePSel = {4'h0,    ProcessData[31:20]};
        4'hD: OutCodePSel = {3'h0,    ProcessData[31:19]};
        4'hE: OutCodePSel = {2'h0,    ProcessData[31:18]};
        4'hF: OutCodePSel = {1'h0,    ProcessData[31:17]};
		endcase // case(DhtWidth)
	end
	endfunction
	assign OutCodeP = OutCodePSel(DhtWidth, ProcessData);
	
	function [15:0] SubCodeSel;
		input [3:0]	DhtWidth;
	begin
      case (DhtWidth)
        4'h0: SubCodeSel = 16'hFFFF;
        4'h1: SubCodeSel = 16'hFFFE;
        4'h2: SubCodeSel = 16'hFFFC;
        4'h3: SubCodeSel = 16'hFFF8;
        4'h4: SubCodeSel = 16'hFFF0;
        4'h5: SubCodeSel = 16'hFFE0;
        4'h6: SubCodeSel = 16'hFFC0;
        4'h7: SubCodeSel = 16'hFF80;
        4'h8: SubCodeSel = 16'hFF00;
        4'h9: SubCodeSel = 16'hFE00;
        4'hA: SubCodeSel = 16'hFC00;
        4'hB: SubCodeSel = 16'hF800;
        4'hC: SubCodeSel = 16'hF000;
        4'hD: SubCodeSel = 16'hE000;
        4'hE: SubCodeSel = 16'hC000;
        4'hF: SubCodeSel = 16'h8000;
      endcase // case(DhtWidth)
	end
	endfunction
	assign SubCode = SubCodeSel(DhtWidth);
   
   always @(posedge clk or negedge rst) begin
      if(!rst) begin
         Process       <= ProcIdle;
         ProcessData   <= 32'h00000000;
         OutEnable     <= 1'b0;
         DataOutEnable <= 1'b0;
         DataOutColor  <= 3'b000;
         PreData[0]    <= 32'h00000000;
         PreData[1]    <= 32'h00000000;
         PreData[2]    <= 32'h00000000;
         UseWidth      <= 7'h00;
         CodeNumber		<= 4'd0;
      end else begin // if (!rst)
         case (Process)
           ProcIdle: begin
              if(DataInRun == 1'b1) begin
                 Process <= Phase1;
	      end else begin
		 // Reset DC code
		 PreData[0] <= 32'h00000000;
		 PreData[1] <= 32'h00000000;
		 PreData[2] <= 32'h00000000;
              end
              OutEnable     <= 1'b0;
              ProcessColor  <= 3'b000;
              ProcessCount  <= 0;
              DataOutEnable <= 1'b0;
              DataOutColor  <= 3'b000;
           end // case: ProcIdle
           // get a table-data and table-number
           Phase1: begin
              if(DataInEnable ==1'b1 & DataOutIdle == 1'b1) begin
                 Process     <= Phase2;
                 ProcessData <= DataIn;
              end
              OutEnable <= 1'b0;
              DataOutEnable <= 1'b0;
              if(ProcessColor[2] == 1'b0) begin
                 if(ProcessCount == 0) begin
                       HaffumanTable[0]  <= HaffumanTable0r[0];
                       HaffumanNumber[0] <= HaffumanNumber0r[0];
                       HaffumanTable[1]  <= HaffumanTable0r[1];
                       HaffumanNumber[1] <= HaffumanNumber0r[1];
                       HaffumanTable[2]  <= HaffumanTable0r[2];
                       HaffumanNumber[2] <= HaffumanNumber0r[2];
                       HaffumanTable[3]  <= HaffumanTable0r[3];
                       HaffumanNumber[3] <= HaffumanNumber0r[3];
                       HaffumanTable[4]  <= HaffumanTable0r[4];
                       HaffumanNumber[4] <= HaffumanNumber0r[4];
                       HaffumanTable[5]  <= HaffumanTable0r[5];
                       HaffumanNumber[5] <= HaffumanNumber0r[5];
                       HaffumanTable[6]  <= HaffumanTable0r[6];
                       HaffumanNumber[6] <= HaffumanNumber0r[6];
                       HaffumanTable[7]  <= HaffumanTable0r[7];
                       HaffumanNumber[7] <= HaffumanNumber0r[7];
                       HaffumanTable[8]  <= HaffumanTable0r[8];
                       HaffumanNumber[8] <= HaffumanNumber0r[8];
                       HaffumanTable[9]  <= HaffumanTable0r[9];
                       HaffumanNumber[9] <= HaffumanNumber0r[9];
                       HaffumanTable[10]  <= HaffumanTable0r[10];
                       HaffumanNumber[10] <= HaffumanNumber0r[10];
                       HaffumanTable[11]  <= HaffumanTable0r[11];
                       HaffumanNumber[11] <= HaffumanNumber0r[11];
                       HaffumanTable[12]  <= HaffumanTable0r[12];
                       HaffumanNumber[12] <= HaffumanNumber0r[12];
                       HaffumanTable[13]  <= HaffumanTable0r[13];
                       HaffumanNumber[13] <= HaffumanNumber0r[13];
                       HaffumanTable[14]  <= HaffumanTable0r[14];
                       HaffumanNumber[14] <= HaffumanNumber0r[14];
                       HaffumanTable[15]  <= HaffumanTable0r[15];
                       HaffumanNumber[15] <= HaffumanNumber0r[15];
                 end else begin
                       HaffumanTable[0]  <= HaffumanTable1r[0];
                       HaffumanNumber[0] <= HaffumanNumber1r[0];
                       HaffumanTable[1]  <= HaffumanTable1r[1];
                       HaffumanNumber[1] <= HaffumanNumber1r[1];
                       HaffumanTable[2]  <= HaffumanTable1r[2];
                       HaffumanNumber[2] <= HaffumanNumber1r[2];
                       HaffumanTable[3]  <= HaffumanTable1r[3];
                       HaffumanNumber[3] <= HaffumanNumber1r[3];
                       HaffumanTable[4]  <= HaffumanTable1r[4];
                       HaffumanNumber[4] <= HaffumanNumber1r[4];
                       HaffumanTable[5]  <= HaffumanTable1r[5];
                       HaffumanNumber[5] <= HaffumanNumber1r[5];
                       HaffumanTable[6]  <= HaffumanTable1r[6];
                       HaffumanNumber[6] <= HaffumanNumber1r[6];
                       HaffumanTable[7]  <= HaffumanTable1r[7];
                       HaffumanNumber[7] <= HaffumanNumber1r[7];
                       HaffumanTable[8]  <= HaffumanTable1r[8];
                       HaffumanNumber[8] <= HaffumanNumber1r[8];
                       HaffumanTable[9]  <= HaffumanTable1r[9];
                       HaffumanNumber[9] <= HaffumanNumber1r[9];
                       HaffumanTable[10]  <= HaffumanTable1r[10];
                       HaffumanNumber[10] <= HaffumanNumber1r[10];
                       HaffumanTable[11]  <= HaffumanTable1r[11];
                       HaffumanNumber[11] <= HaffumanNumber1r[11];
                       HaffumanTable[12]  <= HaffumanTable1r[12];
                       HaffumanNumber[12] <= HaffumanNumber1r[12];
                       HaffumanTable[13]  <= HaffumanTable1r[13];
                       HaffumanNumber[13] <= HaffumanNumber1r[13];
                       HaffumanTable[14]  <= HaffumanTable1r[14];
                       HaffumanNumber[14] <= HaffumanNumber1r[14];
                       HaffumanTable[15]  <= HaffumanTable1r[15];
                       HaffumanNumber[15] <= HaffumanNumber1r[15];
                 end // else: !if(ProcessCount == 0)
              end else begin // if (ProcessColor[2] == 1'b0)
                 if(ProcessCount == 0) begin
                       HaffumanTable[0]  <= HaffumanTable2r[0];
                       HaffumanNumber[0] <= HaffumanNumber2r[0];
                       HaffumanTable[1]  <= HaffumanTable2r[1];
                       HaffumanNumber[1] <= HaffumanNumber2r[1];
                       HaffumanTable[2]  <= HaffumanTable2r[2];
                       HaffumanNumber[2] <= HaffumanNumber2r[2];
                       HaffumanTable[3]  <= HaffumanTable2r[3];
                       HaffumanNumber[3] <= HaffumanNumber2r[3];
                       HaffumanTable[4]  <= HaffumanTable2r[4];
                       HaffumanNumber[4] <= HaffumanNumber2r[4];
                       HaffumanTable[5]  <= HaffumanTable2r[5];
                       HaffumanNumber[5] <= HaffumanNumber2r[5];
                       HaffumanTable[6]  <= HaffumanTable2r[6];
                       HaffumanNumber[6] <= HaffumanNumber2r[6];
                       HaffumanTable[7]  <= HaffumanTable2r[7];
                       HaffumanNumber[7] <= HaffumanNumber2r[7];
                       HaffumanTable[8]  <= HaffumanTable2r[8];
                       HaffumanNumber[8] <= HaffumanNumber2r[8];
                       HaffumanTable[9]  <= HaffumanTable2r[9];
                       HaffumanNumber[9] <= HaffumanNumber2r[9];
                       HaffumanTable[10]  <= HaffumanTable2r[10];
                       HaffumanNumber[10] <= HaffumanNumber2r[10];
                       HaffumanTable[11]  <= HaffumanTable2r[11];
                       HaffumanNumber[11] <= HaffumanNumber2r[11];
                       HaffumanTable[12]  <= HaffumanTable2r[12];
                       HaffumanNumber[12] <= HaffumanNumber2r[12];
                       HaffumanTable[13]  <= HaffumanTable2r[13];
                       HaffumanNumber[13] <= HaffumanNumber2r[13];
                       HaffumanTable[14]  <= HaffumanTable2r[14];
                       HaffumanNumber[14] <= HaffumanNumber2r[14];
                       HaffumanTable[15]  <= HaffumanTable2r[15];
                       HaffumanNumber[15] <= HaffumanNumber2r[15];
                 end else begin
                       HaffumanTable[0]  <= HaffumanTable3r[0];
                       HaffumanNumber[0] <= HaffumanNumber3r[0];
                       HaffumanTable[1]  <= HaffumanTable3r[1];
                       HaffumanNumber[1] <= HaffumanNumber3r[1];
                       HaffumanTable[2]  <= HaffumanTable3r[2];
                       HaffumanNumber[2] <= HaffumanNumber3r[2];
                       HaffumanTable[3]  <= HaffumanTable3r[3];
                       HaffumanNumber[3] <= HaffumanNumber3r[3];
                       HaffumanTable[4]  <= HaffumanTable3r[4];
                       HaffumanNumber[4] <= HaffumanNumber3r[4];
                       HaffumanTable[5]  <= HaffumanTable3r[5];
                       HaffumanNumber[5] <= HaffumanNumber3r[5];
                       HaffumanTable[6]  <= HaffumanTable3r[6];
                       HaffumanNumber[6] <= HaffumanNumber3r[6];
                       HaffumanTable[7]  <= HaffumanTable3r[7];
                       HaffumanNumber[7] <= HaffumanNumber3r[7];
                       HaffumanTable[8]  <= HaffumanTable3r[8];
                       HaffumanNumber[8] <= HaffumanNumber3r[8];
                       HaffumanTable[9]  <= HaffumanTable3r[9];
                       HaffumanNumber[9] <= HaffumanNumber3r[9];
                       HaffumanTable[10]  <= HaffumanTable3r[10];
                       HaffumanNumber[10] <= HaffumanNumber3r[10];
                       HaffumanTable[11]  <= HaffumanTable3r[11];
                       HaffumanNumber[11] <= HaffumanNumber3r[11];
                       HaffumanTable[12]  <= HaffumanTable3r[12];
                       HaffumanNumber[12] <= HaffumanNumber3r[12];
                       HaffumanTable[13]  <= HaffumanTable3r[13];
                       HaffumanNumber[13] <= HaffumanNumber3r[13];
                       HaffumanTable[14]  <= HaffumanTable3r[14];
                       HaffumanNumber[14] <= HaffumanNumber3r[14];
                       HaffumanTable[15]  <= HaffumanTable3r[15];
                       HaffumanNumber[15] <= HaffumanNumber3r[15];
                 end // else: !if(ProcessCount == 0)
              end // else: !if(ProcessColor[2] == 1'b0)
           end // case: Phase1
           // compare table
           Phase2: begin
              Process    <= Phase4;
				if(ProcessData[31:16] >= HaffumanTable[0])	Place[0] <= 1'b1;
				else												Place[0] <= 1'b0;
				if(ProcessData[31:16] >= HaffumanTable[1])	Place[1] <= 1'b1;
				else												Place[1] <= 1'b0;
				if(ProcessData[31:16] >= HaffumanTable[2])	Place[2] <= 1'b1;
				else												Place[2] <= 1'b0;
				if(ProcessData[31:16] >= HaffumanTable[3])	Place[3] <= 1'b1;
				else												Place[3] <= 1'b0;
				if(ProcessData[31:16] >= HaffumanTable[4])	Place[4] <= 1'b1;
				else												Place[4] <= 1'b0;
				if(ProcessData[31:16] >= HaffumanTable[5])	Place[5] <= 1'b1;
				else												Place[5] <= 1'b0;
				if(ProcessData[31:16] >= HaffumanTable[6])	Place[6] <= 1'b1;
				else												Place[6] <= 1'b0;
				if(ProcessData[31:16] >= HaffumanTable[7])	Place[7] <= 1'b1;
				else												Place[7] <= 1'b0;
				if(ProcessData[31:16] >= HaffumanTable[8])	Place[8] <= 1'b1;
				else												Place[8] <= 1'b0;
				if(ProcessData[31:16] >= HaffumanTable[9])	Place[9] <= 1'b1;
				else												Place[9] <= 1'b0;
				if(ProcessData[31:16] >= HaffumanTable[10])	Place[10] <= 1'b1;
				else												Place[10] <= 1'b0;
				if(ProcessData[31:16] >= HaffumanTable[11])	Place[11] <= 1'b1;
				else												Place[11] <= 1'b0;
				if(ProcessData[31:16] >= HaffumanTable[12])	Place[12] <= 1'b1;
				else												Place[12] <= 1'b0;
				if(ProcessData[31:16] >= HaffumanTable[13])	Place[13] <= 1'b1;
				else												Place[13] <= 1'b0;
				if(ProcessData[31:16] >= HaffumanTable[14])	Place[14] <= 1'b1;
				else												Place[14] <= 1'b0;
				if(ProcessData[31:16] >= HaffumanTable[15])	Place[15] <= 1'b1;
				else												Place[15] <= 1'b0;
           end
           // shift code
           Phase4: begin
              Process <= Phase6;
              case (Place)
                16'b0000000000000001: begin
                   TableCode   <= {15'h0000,HaffumanTable[0][15]};
                   NumberCode  <= HaffumanNumber[0];
                   CodeNumber  <= 4'h0;
                   DataNumber  <= {15'h0000,ProcessData[31]};
                   ProcessData <= {ProcessData[30:0],1'b0};
                end
                16'b0000000000000011: begin
                   TableCode   <= {14'h0000,HaffumanTable[1][15:14]};
                   NumberCode  <= HaffumanNumber[1];
                   CodeNumber  <= 4'h1;
                   DataNumber  <= {14'h0000,ProcessData[31:30]};
                   ProcessData <= {ProcessData[29:0],2'b00};
                end
                16'b0000000000000111: begin
                   TableCode   <= {13'h0000,HaffumanTable[2][15:13]};
                   NumberCode  <= HaffumanNumber[2];
                   CodeNumber  <= 4'h2;
                   DataNumber  <= {13'h0000,ProcessData[31:29]};
                   ProcessData <= {ProcessData[28:0],3'b000};
                end
                16'b0000000000001111: begin
                   TableCode   <= {12'h000,HaffumanTable[3][15:12]};
                   NumberCode  <= HaffumanNumber[3];
                   CodeNumber  <= 4'h3;
                   DataNumber  <= {12'h000,ProcessData[31:28]};
                   ProcessData <= {ProcessData[27:0],4'h0};
                end
                16'b0000000000011111: begin
                   TableCode   <= {11'h000,HaffumanTable[4][15:11]};
                   NumberCode  <= HaffumanNumber[4];
                   CodeNumber  <= 4'h4;
                   DataNumber  <= {11'h000,ProcessData[31:27]};
                   ProcessData <= {ProcessData[26:0],5'h00};
                end
                16'b0000000000111111: begin
                   TableCode   <= {10'h000,HaffumanTable[5][15:10]};
                   NumberCode  <= HaffumanNumber[5];
                   CodeNumber  <= 4'h5;
                   DataNumber  <= {10'h000,ProcessData[31:26]};
                   ProcessData <= {ProcessData[25:0],6'h00};
                end
                16'b0000000001111111: begin
                   TableCode   <= {9'h000,HaffumanTable[6][15:9]};
                   NumberCode  <= HaffumanNumber[6];
                   CodeNumber  <= 4'h6;
                   DataNumber  <= {9'h000,ProcessData[31:25]};
                   ProcessData <= {ProcessData[24:0],7'h00};
                end
                16'b0000000011111111: begin
                   TableCode   <= {8'h00,HaffumanTable[7][15:8]};
                   NumberCode  <= HaffumanNumber[7];
                   CodeNumber  <= 4'h7;
                   DataNumber  <= {8'h00,ProcessData[31:24]};
                   ProcessData <= {ProcessData[23:0],8'h00};
                end
                16'b0000000111111111: begin
                   TableCode   <= {7'h00,HaffumanTable[8][15:7]};
                   NumberCode  <= HaffumanNumber[8];
                   CodeNumber  <= 4'h8;
                   DataNumber  <= {7'h00,ProcessData[31:23]};
                   ProcessData <= {ProcessData[22:0],9'h000};
                end
                16'b0000001111111111: begin
                   TableCode   <= {6'h00,HaffumanTable[9][15:6]};
                   NumberCode  <= HaffumanNumber[9];
                   CodeNumber  <= 4'h9;
                   DataNumber  <= {6'h00,ProcessData[31:22]};
                   ProcessData <= {ProcessData[21:0],10'h000};
                end
                16'b0000011111111111: begin
                   TableCode   <= {5'h00,HaffumanTable[10][15:5]};
                   NumberCode  <= HaffumanNumber[10];
                   CodeNumber  <= 4'hA;
                   DataNumber  <= {5'h00,ProcessData[31:21]};
                   ProcessData <= {ProcessData[20:0],11'h000};
                end
                16'b0000111111111111: begin
                   TableCode   <= {4'h0,HaffumanTable[11][15:4]};
                   NumberCode  <= HaffumanNumber[11];
                   CodeNumber  <= 4'hB;
                   DataNumber  <= {4'h0,ProcessData[31:20]};
                   ProcessData <= {ProcessData[19:0],12'h000};
                end
                16'b0001111111111111: begin
                   TableCode   <= {3'h0,HaffumanTable[12][15:3]};
                   NumberCode  <= HaffumanNumber[12];
                   CodeNumber  <= 4'hC;
                   DataNumber  <= {3'h0,ProcessData[31:19]};
                   ProcessData <= {ProcessData[18:0],13'h0000};
                end
                16'b0011111111111111: begin
                   TableCode   <= {2'h0,HaffumanTable[13][15:2]};
                   NumberCode  <= HaffumanNumber[13];
                   CodeNumber  <= 4'hD;
                   DataNumber  <= {2'h0,ProcessData[31:18]};
                   ProcessData <= {ProcessData[17:0],14'h0000};
                end
                16'b0111111111111111: begin
                   TableCode   <= {1'h0,HaffumanTable[14][15:1]};
                   NumberCode  <= HaffumanNumber[14];
                   CodeNumber  <= 4'hE;
                   DataNumber  <= {1'h0,ProcessData[31:17]};
                   ProcessData <= {ProcessData[16:0],15'h0000};
                end
                16'b1111111111111111: begin
                   TableCode   <= HaffumanTable[15];
                   NumberCode  <= HaffumanNumber[15];
                   CodeNumber  <= 4'hF;
                   DataNumber  <= ProcessData[31:16] ;
                   ProcessData <= {ProcessData[15:0],16'h0000};
                end
              endcase // case(Place)
           end // case: Phase4
           Phase5: begin
              Process <= Phase6;
              //SubData <= DataNumber - TableCode;
              //OutDhtNumber <= DataNumber - TableCode + NumberCode;
           end
           Phase6: begin
              if(DataOutIdle == 1'b1) Process   <= Phase7;
              //DhtNumber <= SubData[7:0] + NumberCode;
           end
           Phase7: begin
              Process          <= Phase9;
              OutZero          <= DhtZero;
              UseWidth         <= CodeNumber   + DhtWidth +1;
              if(ProcessCount == 0) begin
                 NextProcessCount <= 7'd1;
                 OutEnable        <= 1'b1;
              end else begin
                 if(DhtZero == 4'h0 & DhtWidth == 4'h0) begin
                    ProcessCount     <= 7'd64;
                    NextProcessCount <= 7'd64;
                    OutEnable        <= 1'b0;
                 end else if(DhtZero == 4'hF & DhtWidth == 4'h0) begin
                    ProcessCount     <= ProcessCount + 4'hF;
                    NextProcessCount <= ProcessCount + 4'hF;
                    OutEnable        <= 1'b0;
                 end else begin
                    ProcessCount     <= ProcessCount + DhtZero;
                    NextProcessCount <= ProcessCount + DhtZero +1;
                    OutEnable        <= 1'b1;
                 end
              end // else: !if(ProcessCount == 0)
                 
              if(ProcessData[31] == 1'b0 & DhtWidth != 0) begin
                 OutCode <= (OutCodeP | SubCode) + 16'h0001;
              end else begin
                 OutCode <= OutCodeP;
              end
           end // case: Phase7
           Phase8: begin
              Process <= Phase9;
           end
           Phase9: begin
              Process <= Phase11;
              if(ProcessCount == 0) begin
                 if(ProcessColor[2] == 1'b0) begin
                    OutCode    <= OutCode + PreData[0];
                    PreData[0] <= OutCode + PreData[0];
                 end else begin
                    if(ProcessColor[0] == 1'b0) begin
                       OutCode    <= OutCode + PreData[1];
                       PreData[1] <= OutCode + PreData[1];
                    end else begin
                       OutCode    <= OutCode + PreData[2];
                       PreData[2] <= OutCode + PreData[2];
                    end
                 end // else: !if(ProcessColor[2] == 1'b0)
              end // if (ProcessCount == 0)
           end // case: Phase9
           Phase10: begin
              Process   <= Phase11;
              //OutData   <= DqtData * OutCode;
           end
           Phase11: begin
              OutEnable <= 1'b0;
              if(NextProcessCount <64) begin
                 Process      <= Phase1;
                 ProcessCount <= NextProcessCount;
              end else begin
                 ProcessCount  <= 7'd0;
                 DataOutEnable <= 1'b1;
                 DataOutColor  <= ProcessColor;
                 if(ProcessColor == 5) begin
                    ProcessColor <= 3'b000;
                    if(DataInRun == 1'b0) Process <= ProcIdle;
                    else Process <= Phase1;
                 end else begin
                    Process <= Phase1;
                    ProcessColor <= ProcessColor +1;
                 end
              end // else: !if(NextProcessCount <64)
           end // case: Phase11
         endcase // case(Process)
      end // else: !if(!rst)
   end // always @ (posedge clk or negedge rst)
   
   assign DhtColor[1]    = ProcessColor[2];
   assign DhtColor[0]    = ProcessCount != 0;
   //assign DhtNumber      = OutDhtNumber[7:0];
   assign DhtNumber      = DataNumber - TableCode + NumberCode;

   assign DqtColor       = ProcessColor[2];
   assign DqtNumber      = ProcessCount[5:0];

   //assign DecodeUseBit   = Process == Phase8;
   assign DecodeUseBit   = Process == Phase9;
   assign DecodeUseWidth = UseWidth;

   assign DecodeEnable   = OutEnable == 1'b1 & Process == Phase11;
   assign DecodeColor    = ProcessColor;
   assign DecodeCount    = ProcessCount[5:0];
   assign DecodeZero     = OutZero;
   //assign DecodeCode     = OutData[15:0];
   assign DecodeCode     = DqtData * OutCode;

endmodule // jpeg_hm_decode
