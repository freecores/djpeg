JPEG Decoder

[Product Name] JPEG Decoder
[Update Date ] 2006/10/04
[Version     ] Ver 1.01
[License     ] LGPL
[Langage     ] Verilog
[Author      ] Hidemi Ishihara(E-Mail:hidemi@sweetcafe.jp)

This documents converted that used a Altavista Babel Fish from Japanese to 
English.

1.Feature
JPEG Decoder is the hardware source code of Verilog which decodes the RGB 
data from the JPEG data.
External RAM for processing is not necessary. However, a some territory in 
order to store FIFO and the output result to one for input is necessary.

2.Specification
To decode the below-mentioned JPEG data it is possible with this source code.

    * Base line DCT
    * Huffman mark
    * Sampling only 4:1:1
    * Sum nail failure
    * Only DQT, DHT, SOF0, SOS, SOI and EOI read.
    * DRI and RSTm failure
    * You ignore the APP marker. 

3.The throughput of this JPGE Decoder


If the picture is drawn up with GIMP, picture quality at 1,920x1,080 size 
with about 80-85% is settled to 200-300KB.
The JPEG data which was drawn up at description above 30fps comes out 
generally.
The synthetic result example with Xilinx is published.

Item 	Result
Tool 	Xilinx WebPack ISE8.2i
Setting 	Other than device selecting default
Device 	XC4VLX25-10F363C
The number of slices 	8,758 (81%)
Block RAM 	16 (22%)
DSP 	21 (43%)
The highest operational frequency 	84.189MHz


4.Source code and file
The below-mentioned file is included in this source code.

Software of execute form
The software of execute form Linux (Fedora Core 5) verifies that it 
operates at on.
When it executes with other OS environment, compiling the source code 
which is attached, please use.
File name   Details
convbtoh    In order to be able to use the binary file of JPEG with 
            simulation, it converts to the file of hexadecimal number.
convsim     The simulation result is converted to Bitmap.
djpeg       It is JPEG Decode of equal efficiency to the hardware 
            source code.

Software (source code)
It is the source code of the software which you have supplied with 
execute form.
When you use with OS environment other than Linux, compiling, please use.
File name   Details
convbtoh.c  The source code of convbtoh
convsim.c   The source code of convsim
djpeg.c     The source code of djpeg

Source code
File name            Details
jpeg_decode.v        JPEG Decoder top module
jpeg_decode_fsm.v    JPEG marker decoding
jpeg_dht.v           DHT table memory
jpeg_dqt.v           DQT table memory
jpeg_haffuman.v      Huffman decoding top module
jpeg_hm_decode.v     Huffman decoding circuit
jpeg_idct.v          IDCT top module
jpeg_idctb.v         IDCT buffer
jpeg_idctx.v         IDCT X direction processing circuit
jpeg_idcty.v         IDCT Y direction processing circuit
jpeg_regdata.v       JPEG data reading circuit
jpeg_test.v          JPEG Decoder test bench
jpeg_ycbcr.v         YCbCr - RGB conversion top module
jpeg_ycbcr2rgb.v     YCbCr - RGB converting circuit
jpeg_ycbcr_mem.v     YCbCr memory
jpeg_ziguzagu.v      Zigzag processing top module
jpeg_ziguzagu_reg.v  Zigzag processing register

Simulation execution script
File name   Details
Run.ms      Execution script for simulation(ModelSim)

5.Signal details
Signal name  IN/OUT  Bit  Details
Rst          IN       1   Asynchronous reset
                          Low Active
Clk          IN       1   Clock
DataIn       IN      32   JPEG data entry
                          The JPEG data which it decodes is input.
                          When DataInEnable is High, the data must be 
                          effective with little endian.
DataInEnable IN       1   JPEG data enabling
                          The fact that DataInData is effective with 
                          High Active is shown. After, basic, with 
                          JpegDecodeStart as High this signal must 
                          become High. Before JpegDecodeStart becomes 
                          High, when this signal becomes High, it 
                          drives recklessly probably will be.
DataInRead   OUT      1   JPEG data lead/read
                          The fact that JpegInData was led/read with 
                          High Active is shown.
JpegDecodeStart IN    1   JPEG decoding start
                          When starting JPEG decoding with High Active,
                          1t just it makes High.
JpegDecodeIdle  OUT   1   JPEG decoding idling
                          The fact that JPEG Decoder is idling with 
                          High Active is shown. When this signal is 
                          not High, during JPEG decoding with 
                          JpegDecodeStart as High it cannot go.
OutEnable       OUT   1   Graphics data enabling
                          The graphics data (RGB) the fact that it has
                          output is shown with High Active.
OutWidth        OUT  16   Graphics data size (X direction)
                          Width of the graphics data size which is in
                          the midst of processing is shown.
OutHeight       OUT  16   Graphics data size (Y direction)
                          Height of the graphics data size which is in 
                          the midst of processing is shown.
OutPixelX       OUT  16   Graphics data X position
                          Position of cross direction of the graphics
                          data which are in the midst of outputting is
                          shown.
OutPixelY       OUT  16   Graphics data Y position
                          Position of lengthwise of the graphics data
                          which are in the midst of outputting is shown.
OutR            OUT   8   Graphics data (red)
OutG            OUT   8   Graphics data (green)
OutB            OUT   8   Graphics data (blue)

As in the upper figure you suppose that FIFO and output side the memory 
controller etc. are placed to input side.
FIFO being to be good being simple FIFO excludes explanation.
Output side it is desirable to place the memory controller and the like, 
is, but if memory of 24bit width is put in place, ahead retaining address 
becomes the position of OutHeight × OutPixelY + OutPixelX.

6.Simulation
If it is the environment which can use ModelSim, simulation can be done by 
the fact that the below-mentioned command is executed.

% /run.ms test_jpeg

In case description above, the JPEG picture of the file name, beforehand,
test_jpeg.jpg must be prepared.
With simulation it decodes test_jpeg.jpg with simulation, it forms the 
file, sim.dat as the result.
The bit map file, sim.bmp from the result is formed.

When simulation is executed, after and the below-mentioned way the loading 
the module message is indicated.

# START Clock: 3
...
#  RGB[1259,   3,1920,1080](       7019): 1ba,1fe,1fc = 34,3d,36
...
# End Clock 2983674

As for the result the clock where JpegDecodeStart becomes High is 3, the 
clock which JPEG decoding completes 2,983,674 has shown the fact that is.
Therefore, the above-mentioned simulation has shown the fact that it is 
2,983,671 clocks necessary to decoding one JPEG data.

7.Lastly
This documents converted that used a Altavista Babel Fish from Japanese 
to English.

If You look at the block diagram. 

As for the datasheet please look at URl below.
(However, it is Japanese.)

http://www.sweetcafe.jp/LEAFGREEN/JPEG_DECODER/datasheet.html

You see with the Hidemi Ishihara (E-Mail: Hidemi@sweetcafe.jp) 

[Comment]
Ver 0.90: 2006/10/01 PreRelease
Ver 1.00: 2006/10/02 Release
Ver 1.01: 2006/10/04 Modify or remove some registers(not use a register).
                     Add the ProcessIdle register.
