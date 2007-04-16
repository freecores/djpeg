//---------------------------------------------------------------------------
// File Name	: jpeg_decode_fsm.v
// Module Name	: jpeg_decode_fsm
// Description	: Decode Maker
// Project		: JPEG Decoder
// Belong to	: 
// Author		: H.Ishihara
// E-Mail		: hidemi@sweetcafe.jp
// HomePage		: http://www.sweetcafe.jp/
// Date			: 2007/04/11
// Rev.			: 1.03
//---------------------------------------------------------------------------
// Rev. Date		 Description
//---------------------------------------------------------------------------
// 1.01 2006/10/01 1st Release
// 1.02 2006/10/04 Remove a HmOldData register.
//						When reset, clear a ReadDqtTable register.
// 1.03 2007/04/11 Remove JpegDecodeStart
//                 Exchange StateMachine(Add ImageData)
//                 Remove JpegDecodeStart
//---------------------------------------------------------------------------
// $Id: 
//---------------------------------------------------------------------------
`timescale 1ps / 1ps
	
module jpeg_decode_fsm
	(
	rst,
	clk,

	// From FIFO
	DataInEnable,
	DataIn,

	JpegDecodeIdle,		// Deocdeer Process Idle(1:Idle, 0:Run)

	OutWidth,
	OutHeight,
	OutBlockWidth,
	OutEnable,
	OutPixelX,
	OutPixelY,
	
	//
	DqtEnable,
	DqtTable,
	DqtCount,
	DqtData,

	//
	DhtEnable,
	DhtTable,
	DhtCount,
	DhtData,

	//
	HaffumanEnable,
	HaffumanTable,
	HaffumanCount,
	HaffumanData,
	HaffumanStart,

	//
	ImageEnable,
	ImageEnd,
	EnableFF00,
	
	//
	UseByte,
	UseWord
	);

	input			 rst;
	input			 clk;

	input 			DataInEnable;
	input [31:0]	DataIn;
	
	output			JpegDecodeIdle;

	output [15:0]	OutWidth;
	output [15:0]	OutHeight;
	output [11:0]	OutBlockWidth;
	input			OutEnable;
	input [15:0]	OutPixelX;
	input [15:0]	OutPixelY;
	
	output 			DqtEnable;
	output 			DqtTable;
	output [5:0]	DqtCount;
	output [7:0]	DqtData;

	output 			DhtEnable;
	output [1:0]	DhtTable;
	output [7:0]	DhtCount;
	output [7:0]	DhtData;

	//
	output 			HaffumanEnable;
	output [1:0]	HaffumanTable;
	output [3:0]	HaffumanCount;
	output [15:0]	HaffumanData;
	output [7:0]	HaffumanStart;
	
	//
	output 			ImageEnable;
	input 			ImageEnd;
	output 			EnableFF00;
	
	//
	output 			UseByte;
	output 			UseWord;


	//--------------------------------------------------------------------------
	// Read Maker from Jpeg Data
	//--------------------------------------------------------------------------
	reg [1:0]		State;
	reg [3:0]		Process;
	wire			StateReadByte;
	wire			StateReadWord;
	wire			ImageEnable;

	wire			ReadSegmentEnd;

	parameter		Idle		= 2'b00;
	parameter		GetMarker	= 2'b01;
	parameter		ReadSegment	= 2'b10;
	parameter		ImageData	= 2'b11;

	parameter		NoProcess	= 4'h0;
	parameter		SegSOI		= 4'h1;
	parameter		SegAPP		= 4'h2;
	parameter		SegDQT		= 4'h3;
	parameter		SegDHT		= 4'h4;
	parameter		SegSOF0		= 4'h5;
	parameter		SegSOS		= 4'h6;
	parameter		SegDRI		= 4'h7;
	parameter		SegRST		= 4'h8;
	parameter		SegEOI		= 4'h9;
	
	reg [15:0]		JpegWidth;
	reg [15:0]		JpegHeight;

	always @(posedge clk or negedge rst) begin
		if(!rst) begin
			State		<= Idle;
			Process		<= NoProcess;
		end else begin
			case(State)
				Idle: begin
					if(DataInEnable == 1'b1) begin
						State	<= GetMarker;
					end
					Process		<= NoProcess;
				end
				GetMarker: begin
					if(DataInEnable == 1'b1) begin
						State	<= ReadSegment;
						case(DataIn[31:16])
						16'hFFD8: begin		// SOI Segment
							Process <= SegSOI;
						end
						16'hFFE0: begin		// APP0 Segment
							Process <= SegAPP;
						end
						16'hFFDB: begin		// DQT Segment
							Process <= SegDQT;
						end
						16'hFFC4: begin		// DHT Segment
							Process <= SegDHT;
						end
						16'hFFC0: begin		// SOF0 Segment
							Process <= SegSOF0;
						end
						16'hFFDA: begin		// SOS Segment
							Process <= SegSOS;
						end
						//16'hFFDD: begin	// DRI Segment
						//	Process <= SegDRI;
						//end
						//16'hFFDx: begin	// RSTn Segment
						//	Process <= SegRST;
						//end
						//16'hFFD9: begin	// EOI Segment
						//	Process <= SegEOI;
						//end
						default: begin
							Process <= SegAPP;
						end
						endcase
					end
				end
				ReadSegment: begin
					if(ReadSegmentEnd == 1'b1) begin
						Process <= NoProcess;
						if(Process == SegSOS) begin
							State	<= ImageData;
						end else begin
							State	<= GetMarker;
						end
					end
				end
				ImageData: begin
					if(OutEnable & (JpegWidth == OutPixelX +1) & (JpegHeight == OutPixelY +1)) begin
						State	 <= Idle;
					end
				end
			endcase
		end
	end

	assign JpegDecodeIdle	= (State == Idle);
	assign StateReadByte	= 1'b0;
	assign StateReadWord	= ((State == GetMarker) & (DataInEnable == 1'b1));
	assign ImageEnable		= (State == ImageData);

	wire	ReadNopEnd;

	assign	ReadNopEnd = ((Process == SegSOI) | (Process == SegRST));
	
	//--------------------------------------------------------------------------
	// APP Segment
	// Skip read data!
	//--------------------------------------------------------------------------

	reg [1:0]	StateAPP;
	reg [15:0]	ReadAppCount;
	wire		ReadAppByte;
	wire		ReadAppWord;
	wire		ReadAppEnd;

	parameter	AppIdle		= 2'd0;
	parameter	AppLength	= 2'd1;
	parameter	AppRead		= 2'd2;
	
	always @(posedge clk or negedge rst) begin
		if(!rst) begin
			StateAPP		<= AppIdle;
			ReadAppCount	<= 16'd0;
		end else begin
			case(StateAPP)
				AppIdle: begin
					if(Process == SegAPP) StateAPP <= AppLength;
					ReadAppCount <= 16'd0;
				end
				AppLength: begin
					if(DataInEnable == 1'b1) begin
						ReadAppCount	<= DataIn[31:16] -2;
						StateAPP		<= AppRead;
					end
				end
				AppRead: begin
					if(DataInEnable == 1'b1) begin
						if(ReadAppCount == 1) begin
							StateAPP		<= AppIdle;
						end else begin
							ReadAppCount	<= ReadAppCount -1;
						end
					end
				end
			endcase
		end
	end
	assign ReadAppByte	= (StateAPP == AppRead);
	assign ReadAppWord	= (StateAPP == AppLength);
	assign ReadAppEnd	= ((StateAPP == AppRead) & (DataInEnable == 1'b1) & (ReadAppCount == 1));
	
	//--------------------------------------------------------------------------
	// DQT Segment
	//--------------------------------------------------------------------------

	reg [1:0]	 StateDQT;
	reg [15:0]	ReadDqtCount;
	wire			ReadDqtByte;
	wire			ReadDqtWord;
	wire			ReadDqtEnd;
	wire			ReadDqtEnable;
	wire [7:0]	ReadDqtData;
	reg			 ReadDqtTable;

	parameter	 DQTIdle	= 2'b00;
	parameter	 DQTLength = 2'b01;
	parameter	 DQTTable	= 2'b10;
	parameter	 DQTRead	= 2'b11;
	
	always @(posedge clk or negedge rst) begin
		if(!rst) begin
			StateDQT		<= DQTIdle;
			ReadDqtCount	<= 16'h0000;
	 ReadDqtTable	<= 1'b0;
		end else begin
			case(StateDQT)
				DQTIdle: begin
					if(Process == SegDQT) begin
						StateDQT <= DQTLength;
					end
					ReadDqtCount	<= 16'h0000;
				end
				DQTLength: begin
					if(DataInEnable == 1'b1) begin
						StateDQT		<= DQTTable;
						ReadDqtCount <= DataIn[31:16] -2;
					end
				end
				DQTTable: begin
					if(DataInEnable == 1'b1) begin
						StateDQT		<= DQTRead;
						ReadDqtTable <= DataIn[24];
						ReadDqtCount <= 16'd0;
					end
				end
				DQTRead: begin
					if(DataInEnable == 1'b1) begin
						if(ReadDqtCount ==63) begin
							StateDQT		<= DQTIdle;
						end
						ReadDqtCount	<= ReadDqtCount +1;
					end
				end
			endcase
		end
	end

	assign ReadDqtEnable = StateDQT == DQTRead;
	assign ReadDqtData	= DataIn[31:24];
	
	assign ReadDqtByte = StateDQT == DQTRead | StateDQT == DQTTable;
	assign ReadDqtWord = StateDQT == DQTLength;
	assign ReadDqtEnd	= StateDQT == DQTRead & DataInEnable == 1'b1 & ReadDqtCount ==63;

	//--------------------------------------------------------------------------
	// DHT Segment
	//--------------------------------------------------------------------------
	reg [2:0]		StateDHT;
	reg [15:0]	 ReadDhtCount;
	wire			 ReadDhtByte;
	wire			 ReadDhtWord;
	wire			 ReadDhtEnd;
	wire			 ReadDhtEnable;
	wire [7:0]	 ReadDhtData;
	reg [1:0]		ReadDhtTable;

	reg [15:0]	 HmShift;
	reg [15:0]	 HmData;
	reg [7:0]		HmMax;
	reg [7:0]		HmCount;
	reg				HmEnable;

	parameter		DHTIdle = 3'h0;
	parameter		DHTLength = 3'h1;
	parameter		DHTTable = 3'h2;
	parameter		DHTMakeHm0 = 3'h3;
	parameter		DHTMakeHm1 = 3'h4;
	parameter		DHTMakeHm2 = 3'h5;
	parameter		DHTReadTable = 3'h6;
	
	always @(posedge clk or negedge rst)
		begin
			if(!rst) begin
				StateDHT <= DHTIdle;
				ReadDhtCount	<= 16'h0000;
				ReadDhtTable	<= 2'b00;
				HmEnable		<= 1'b0;
				HmShift		 <= 16'h8000;
				HmData			<= 16'h0000;
				HmMax			<= 8'h00;
				HmCount		 <= 8'h00;
			end else begin // if (!rst)
				case(StateDHT)
				 DHTIdle: begin
					 if(Process == SegDHT) begin
						 StateDHT <= DHTLength;
					 end
					 HmEnable		<= 1'b0;
				 end
				 DHTLength: begin
					 if(DataInEnable == 1'b1) begin
						 StateDHT		<= DHTTable;
						 ReadDhtCount <= DataIn[31:16];
					 end
				 end
				 DHTTable: begin
					 if(DataInEnable == 1'b1) begin
						 StateDHT <= DHTMakeHm0;
						 case(DataIn[31:24])
							8'h00: ReadDhtTable <= 2'b00;
							8'h10: ReadDhtTable <= 2'b01;
							8'h01: ReadDhtTable <= 2'b10;
							8'h11: ReadDhtTable <= 2'b11;
						 endcase
					 end
					 HmShift <= 16'h8000;
					 HmData	<= 16'h0000;
					 HmMax	<= 8'h00;
					 ReadDhtCount <= 0;
				 end // case: DHTTable
				 DHTMakeHm0: begin
					 if(DataInEnable == 1'b1) begin
						 StateDHT		<= DHTMakeHm1;
						 HmCount		<= DataIn[31:24];
					 end
					 HmEnable		<= 1'b0;
				 end
				 DHTMakeHm1: begin
					 StateDHT <= DHTMakeHm2;
					 HmMax	 <= HmMax + HmCount;
				 end
				 DHTMakeHm2: begin
					 if(HmCount != 0) begin
						 HmData	<= HmData + HmShift;
						 HmCount <= HmCount -1;
					 end else begin
						 if(ReadDhtCount == 15) begin
							 StateDHT <= DHTReadTable;
							 HmCount	<= 8'h00;
							 //HmMax	 <= HmMax -1;
						 end else begin
							 HmEnable		<= 1'b1;
							 StateDHT		<= DHTMakeHm0;
							 ReadDhtCount <= ReadDhtCount +1;
						 end
						 HmShift <= HmShift >> 1;
					 end
				 end
				 DHTReadTable: begin
					 HmEnable		<= 1'b0;
					 if(DataInEnable == 1'b1) begin
						 if(HmMax == HmCount +1) begin
							 StateDHT <= DHTIdle;
						 end
						 HmCount				<= HmCount +1;
					 end
				 end
				endcase
			end
		end

	assign ReadDhtEnable = StateDHT == DHTReadTable;
	assign ReadDhtData	= DataIn[31:24];
	
	assign ReadDhtByte = StateDHT == DHTTable | StateDHT == DHTMakeHm0 |
								StateDHT == DHTReadTable;
	assign ReadDhtWord = StateDHT == DHTLength;
	assign ReadDhtEnd	= StateDHT == DHTReadTable & DataInEnable == 1'b1 & HmMax == HmCount +1;

	//--------------------------------------------------------------------------
	// SOS Segment
	//--------------------------------------------------------------------------
	reg [3:0] StateSOS;
	reg [15:0] ReadSosCount;
	wire		 ReadSosByte;
	wire		 ReadSosWord;
	wire		 ReadSosEnd;

	parameter	SOSIdle		 = 4'h0;
	parameter	SOSLength		= 4'h1;
	parameter	SOSRead0		= 4'h2;
	parameter	SOSRead1		= 4'h3;
	parameter	SOSRead2		= 4'h4;
	parameter	SOSRead3		= 4'h5;
	parameter	SOSRead4		= 4'h6;

	reg 			EnableFF00;
	
	always @(posedge clk or negedge rst)
		begin
			if(!rst) begin
				StateSOS			<= SOSIdle;
				ReadSosCount	 <= 16'h0000;
		EnableFF00		<= 1'b0;
			end else begin
				case(StateSOS)
				 SOSIdle: begin
					 if(Process == SegSOS) begin
						 StateSOS <= SOSLength;
			EnableFF00 <= 1'b1;
					 end
				 end
				 SOSLength: begin
					 if(DataInEnable == 1'b1) begin			
						 StateSOS		<= SOSRead0;
						 ReadSosCount <= DataIn[31:16];
					 end
				 end
				 SOSRead0: begin
					 if(DataInEnable == 1'b1) begin			
						 StateSOS		<= SOSRead1;
						 ReadSosCount <= {8'h00,DataIn[31:24]};
					 end
				 end
				 SOSRead1: begin
					 if(DataInEnable == 1'b1) begin
						 if(ReadSosCount == 1) begin
							 StateSOS		<= SOSRead2;
						 end else begin
							 ReadSosCount <= ReadSosCount -1;
						 end
					 end
				 end
				 SOSRead2: begin
					 if(DataInEnable == 1'b1) begin			
						 StateSOS			<= SOSRead3;
					 end
				 end
				 SOSRead3: begin
					 if(DataInEnable == 1'b1) begin			
						 StateSOS			<= SOSRead4;
					 end
				 end
				 SOSRead4: begin
					 if(DataInEnable == 1'b1) begin			
						 StateSOS			<= SOSIdle;
					 end
				 end
				endcase
			end
		end
	assign ReadSosByte = StateSOS == SOSRead0 | StateSOS == SOSRead2 | StateSOS == SOSRead3 | StateSOS == SOSRead4;
	assign ReadSosWord = StateSOS == SOSLength | StateSOS == SOSRead1;
	assign ReadSosEnd	= DataInEnable == 1'b1 & StateSOS == SOSRead4;

	//--------------------------------------------------------------------------
	// SOF0 Segment
	//--------------------------------------------------------------------------
	reg [3:0] StateSOF;
	reg [15:0] ReadSofCount;
	wire		 ReadSofByte;
	wire		 ReadSofWord;
	wire		 ReadSofEnd;

	reg [15:0] JpegBlockWidth;
	reg [15:0] JpegBlockHeight;

	parameter	SOFIdle		 = 4'h0;
	parameter	SOFLength		= 4'h1;
	parameter	SOFRead0		= 4'h2;
	parameter	SOFReadY		= 4'h3;
	parameter	SOFReadX		= 4'h4;
	parameter	SOFReadComp	= 4'h5;
	parameter	SOFMakeBlock0 = 4'H6;
	parameter	SOFMakeBlock1 = 4'h7;
	
	always @(posedge clk or negedge rst)
		begin
			if(!rst) begin
				StateSOF			<= SOFIdle;
				ReadSofCount	 <= 16'h0000;
				JpegWidth		 <= 16'h0000;
				JpegHeight		<= 16'h0000;
				JpegBlockWidth	<= 16'h0000;
				JpegBlockHeight <= 16'h0000;
			end else begin
				case(StateSOF)
				 SOFIdle: begin
					 if(Process == SegSOF0) begin
						 StateSOF <= SOFLength;
					 end
				 end
				 SOFLength: begin
					 if(DataInEnable == 1'b1) begin			
						 StateSOF		<= SOFRead0;
						 ReadSofCount <= DataIn[31:16];
					 end
				 end
				 SOFRead0: begin
					 if(DataInEnable == 1'b1) begin			
						 StateSOF <= SOFReadY;
					 end
				 end
				 SOFReadY: begin
					 if(DataInEnable == 1'b1) begin			
						 StateSOF		 <= SOFReadX;
						 JpegHeight		<= DataIn[31:16];
						 JpegBlockHeight <= DataIn[31:16];
					 end
				 end
				 SOFReadX: begin
					 if(DataInEnable == 1'b1) begin			
						 StateSOF			<= SOFReadComp;
						 JpegWidth		<= DataIn[31:16];
						 JpegBlockWidth <= DataIn[31:16];
						 ReadSofCount	 <= 16'h0000;
					 end
				 end
				 SOFReadComp: begin
					 if(DataInEnable == 1'b1) begin
						 if(ReadSofCount == 9) begin
							 StateSOF <= SOFMakeBlock0;
						 end else begin
							 ReadSofCount <= ReadSofCount +1;
						 end
					 end
				 end
				 SOFMakeBlock0:begin
					 StateSOF			<= SOFMakeBlock1;
					 JpegBlockWidth	<= JpegBlockWidth	+15;
					 JpegBlockHeight <= JpegBlockHeight +15;
				 end
				 SOFMakeBlock1:begin
					 StateSOF			<= SOFIdle;
					 JpegBlockWidth	<= JpegBlockWidth	>> 4;
					 JpegBlockHeight <= JpegBlockHeight >> 4;
				 end
				endcase
			end
		end
	assign ReadSofByte = StateSOF == SOFRead0 | StateSOF == SOFReadComp;
	assign ReadSofWord = StateSOF == SOFLength | StateSOF == SOFReadX | StateSOF == SOFReadY ;
	assign ReadSofEnd	= StateSOF == SOFMakeBlock1;

	assign OutWidth	= JpegWidth;
	assign OutHeight = JpegHeight;
	assign 		OutBlockWidth = JpegBlockWidth[11:0];
	
	//
	assign			UseByte = DataInEnable == 1'b1 & (StateReadByte | ReadAppByte | ReadDqtByte | ReadDhtByte | ReadSosByte | ReadSofByte) ;
	assign			UseWord = DataInEnable == 1'b1 & (StateReadWord | ReadAppWord | ReadDqtWord | ReadDhtWord | ReadSosWord | ReadSofWord) ;
	assign			ReadSegmentEnd = ReadNopEnd | ReadAppEnd | ReadDqtEnd | ReadDhtEnd | ReadSosEnd | ReadSofEnd ;

	//
	assign 		DqtEnable = ReadDqtEnable;
	assign 		DqtTable	= ReadDqtTable;
	assign 		DqtCount	= ReadDqtCount[5:0];
	assign 		DqtData	= ReadDqtData;

	//
	assign 		DhtEnable = ReadDhtEnable;
	assign 		DhtTable	= ReadDhtTable;
	assign 		DhtCount	= HmCount;
	assign 		DhtData	= ReadDhtData;

	//
	assign 		HaffumanEnable = HmEnable;
	assign 		HaffumanTable	= ReadDhtTable;
	assign 		HaffumanCount	= ReadDhtCount[3:0];
	assign 		HaffumanData	= HmData;
	assign 		HaffumanStart	= HmMax;

endmodule
