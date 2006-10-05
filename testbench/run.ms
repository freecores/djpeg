#!/bin/csh

if($#argv == 0) then
  echo Usage: run.ms IMAGENAME
  exit
endif

./convbtoh ../image/$argv[1].jpg test.mem 

if(-d ./work) rm -rf work

vlib work
vlog ../src/jpeg_regdata.v
vlog ../src/jpeg_ziguzagu_reg.v
vlog ../src/jpeg_ziguzagu.v
vlog ../src/jpeg_dqt.v
vlog ../src/jpeg_dht.v
vlog ../src/jpeg_hm_decode.v
vlog ../src/jpeg_haffuman.v
vlog ../src/jpeg_idctb.v
vlog ../src/jpeg_idctx.v
vlog ../src/jpeg_idcty.v
vlog ../src/jpeg_idct.v
vlog ../src/jpeg_ycbcr_mem.v
vlog ../src/jpeg_ycbcr2rgb.v
vlog ../src/jpeg_ycbcr.v
vlog ../src/jpeg_decode_fsm.v
vlog ../src/jpeg_decode.v
vlog jpeg_test.v

echo "vsim  -t 1ps -lib work jpeg_test" > modelsim.fdo
#echo "view wave" >> modelsim.fdo
#echo "do wave.do" >> modelsim.fdo
#echo "vcd file vcd/jpeg_test.vcd" >> modelsim.fdo
#echo "vcd add -r *" >> modelsim.fdo
echo "run 100 ms" >> modelsim.fdo
echo "quit" >> modelsim.fdo

vsim -c -do modelsim.fdo
#vsim -do modelsim.fdo

./convsim sim.dat sim.bmp 

rm -rf ./work
rm transcript
rm modelsim.fdo
