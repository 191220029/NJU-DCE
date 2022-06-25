transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+E:/Quartus/ex02/priority_encoder83 {E:/Quartus/ex02/priority_encoder83/hex15.v}
vlog -vlog01compat -work work +incdir+E:/Quartus/ex02/priority_encoder83 {E:/Quartus/ex02/priority_encoder83/pri_encoder83.v}
vlog -vlog01compat -work work +incdir+E:/Quartus/ex02/priority_encoder83 {E:/Quartus/ex02/priority_encoder83/priority_encoder83.v}

vlog -vlog01compat -work work +incdir+E:/Quartus/ex02/priority_encoder83/simulation/modelsim {E:/Quartus/ex02/priority_encoder83/simulation/modelsim/priority_encoder83.vt}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -voptargs="+acc"  priority_encoder83_vlg_tst

add wave *
view structure
view signals
run -all
