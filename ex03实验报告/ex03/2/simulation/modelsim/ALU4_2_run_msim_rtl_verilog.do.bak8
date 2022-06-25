transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+E:/Quartus/ex03/ALU4_2 {E:/Quartus/ex03/ALU4_2/myALU4_2.v}
vlog -vlog01compat -work work +incdir+E:/Quartus/ex03/ALU4_2 {E:/Quartus/ex03/ALU4_2/alu4_2.v}

vlog -vlog01compat -work work +incdir+E:/Quartus/ex03/ALU4_2/simulation/modelsim {E:/Quartus/ex03/ALU4_2/simulation/modelsim/ALU4_2.vt}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -voptargs="+acc"  ALU4_2_vlg_tst

add wave *
view structure
view signals
run -all
