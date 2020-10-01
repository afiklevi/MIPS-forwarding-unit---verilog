forwarding_unit forwarding_unit (
	// INPUTS
		.op_code(op_code_EXE),
		.EX_MEM_RegWrite(reg_write_MEM),
		.MEM_WB_RegWrite(reg_write_WB),
		.EX_MEM_RegisterRd(dest_MEM),
		.MEM_WB_RegisterRd(dest_WB),
		.ID_EX_RegisterRs(rs_EXE),
		.ID_EX_RegisterRt(rt_EXE),
	// OUTPUTS
		.Forward_A(sel_alu1),
		.Forward_B(sel_alu2),
		.Forward_C(sel_store_val)
	);