START: 
	bne x0, x0, FAIL
	addi s0, x0, 0x10
	beq s0, x0 FAIL
	j START

FAIL: 
	j FAIL