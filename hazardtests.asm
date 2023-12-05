li s5, 0x6000

# Simple Data Hazard
#add x5, x5, x1
#sub x2, x5, x3

# Forwarding
# Set up
addi s3, x0, 3
nop
nop
# Begin 
addi s8, x0, 5 
sub s2, s8, s3 # Hazard detected
or s9, t6, s8
and s7, s8, t2

# Stalling to solve lw Data Dependency
# Set up
sw s2, 0(s5)
nop
nop
nop
# Begin lw Data Dependency test
lw s8, 0(s5)
add s8, s8, s2
or t2, s6, s7
sub s3, s7, s2

# Branching / Flushing
addi s1, x0, 0
addi s2, x0, 0
nop 
nop
nop
nop
nop
beq s1, s2, L1
sub s8, t1, s3
or s9, t6, s5
nop
nop
nop
L1: add s7, s3, s4

# Quiz 4 1
#addi x1, x0, 3
#addi x2, x1, 2
#lw x3, 0(x1)
#add x2, x2, x3
#addi x3, x1, 1
#sw x0, 0(x7)