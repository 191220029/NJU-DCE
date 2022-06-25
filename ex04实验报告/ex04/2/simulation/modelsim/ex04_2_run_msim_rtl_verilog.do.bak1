transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+E:/Quartus/ex04/2 {E:/Quartus/ex04/2/synDff.v}
vlog -vlog01compat -work work +incdir+E:/Quartus/ex04/2 {E:/Quartus/ex04/2/aynDff.v}
vlog -vlog01compat -work work +incdir+E:/Quartus/ex04/2 {E:/Quartus/ex04/2/ex04_2.v}

vlog -vlog01compat -work work +incdir+E:/Quartus/ex04/2/simulation/modelsim {E:/Quartus/ex04/2/simulation/modelsim/ex04_2.vt}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -voptargs="+acc"  ex04_2_vlg_tst

add wave *
view structure
view signals
run -all
