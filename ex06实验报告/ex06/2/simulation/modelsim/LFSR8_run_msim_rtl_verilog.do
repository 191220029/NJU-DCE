transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+E:/Quartus/ex06/LFSR8 {E:/Quartus/ex06/LFSR8/RanGen.v}
vlog -vlog01compat -work work +incdir+E:/Quartus/ex06/LFSR8 {E:/Quartus/ex06/LFSR8/clock_1.v}
vlog -vlog01compat -work work +incdir+E:/Quartus/ex06/LFSR8 {E:/Quartus/ex06/LFSR8/hex15.v}
vlog -vlog01compat -work work +incdir+E:/Quartus/ex06/LFSR8 {E:/Quartus/ex06/LFSR8/lfsr8.v}

vlog -vlog01compat -work work +incdir+E:/Quartus/ex06/LFSR8/simulation/modelsim {E:/Quartus/ex06/LFSR8/simulation/modelsim/LFSR8.vt}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -voptargs="+acc"  LFSR8_vlg_tst

add wave *
view structure
view signals
run -all
