transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+E:/Quartus/ex06/shift_register {E:/Quartus/ex06/shift_register/ShiftReg.v}
vlog -vlog01compat -work work +incdir+E:/Quartus/ex06/shift_register {E:/Quartus/ex06/shift_register/clock_1.v}
vlog -vlog01compat -work work +incdir+E:/Quartus/ex06/shift_register {E:/Quartus/ex06/shift_register/shift_register.v}

vlog -vlog01compat -work work +incdir+E:/Quartus/ex06/shift_register/simulation/modelsim {E:/Quartus/ex06/shift_register/simulation/modelsim/shift_register.vt}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -voptargs="+acc"  shift_register_vlg_tst

add wave *
view structure
view signals
run -all
