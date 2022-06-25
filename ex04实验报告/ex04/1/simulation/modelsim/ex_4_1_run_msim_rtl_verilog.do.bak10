transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+E:/Quartus/ex04/1 {E:/Quartus/ex04/1/nonblocing_assign.v}
vlog -vlog01compat -work work +incdir+E:/Quartus/ex04/1 {E:/Quartus/ex04/1/ex_4_1.v}

vlog -vlog01compat -work work +incdir+E:/Quartus/ex04/1/simulation/modelsim {E:/Quartus/ex04/1/simulation/modelsim/ex_4_1.vt}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -voptargs="+acc"  ex_4_1_vlg_tst

add wave *
view structure
view signals
run -all
