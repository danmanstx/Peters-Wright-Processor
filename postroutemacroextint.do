onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider -height 30 {Clock and Clear}
add wave -noupdate -color Gray60 -format Logic -label clear /finaltbw/g_clr
add wave -noupdate -color Gray60 -format Logic -label {global clock} /finaltbw/g_clk
add wave -noupdate -divider -height 30 Opcode
add wave -noupdate -format Literal -radix octal /finaltbw/opcode
add wave -noupdate -divider -height 30 States
add wave -noupdate -color Blue -format Literal -label State1 /finaltbw/state1
add wave -noupdate -color Red -format Literal -label State2 /finaltbw/state2
add wave -noupdate -color White -format Literal -label State3 /finaltbw/state3
add wave -noupdate -divider -height 30 Inputs
add wave -noupdate -format Logic /finaltbw/hs_in
add wave -noupdate -format Logic /finaltbw/ext_int
add wave -noupdate -format Literal /finaltbw/bus_in
add wave -noupdate -divider -height 30 {PC AND INSTR}
add wave -noupdate -color Blue -format Literal -radix binary /finaltbw/ir_out
add wave -noupdate -color Gold -format Literal -label {Program Counter} -radix hexadecimal /finaltbw/program_counter
add wave -noupdate -divider -height 30 Outputs
add wave -noupdate -format Literal /finaltbw/bus_out
add wave -noupdate -format Logic /finaltbw/hs_out
add wave -noupdate -divider -height 30 Registers
add wave -noupdate -color {Dark Orchid} -format Literal -label {Register 0} -radix decimal /finaltbw/reg0
add wave -noupdate -color {Dark Orchid} -format Literal -label {Register 1} -radix decimal /finaltbw/reg1
add wave -noupdate -color {Dark Orchid} -format Literal -label {Register 2} -radix decimal /finaltbw/reg2
add wave -noupdate -color {Dark Orchid} -format Literal -label {Register 3} -radix decimal /finaltbw/reg3
add wave -noupdate -color {Dark Orchid} -format Literal -label {Register 4} -radix decimal /finaltbw/reg4
add wave -noupdate -color {Dark Orchid} -format Literal -label {Register 5} -radix decimal /finaltbw/reg5
add wave -noupdate -color {Dark Orchid} -format Literal -label {Register 6} -radix decimal /finaltbw/reg6
add wave -noupdate -color {Dark Orchid} -format Literal -label {Register 7} -radix decimal /finaltbw/reg7
add wave -noupdate -color {Dark Orchid} -format Literal -label {Register 8} -radix decimal /finaltbw/reg8
add wave -noupdate -color {Dark Orchid} -format Literal -label {Register 9} -radix decimal /finaltbw/reg9
add wave -noupdate -color {Dark Orchid} -format Literal -label {Register 10} -radix decimal /finaltbw/reg10
add wave -noupdate -color {Dark Orchid} -format Literal -label {Register 11} -radix decimal /finaltbw/reg11
add wave -noupdate -color {Dark Orchid} -format Literal -label {Register 12} -radix decimal /finaltbw/reg12
add wave -noupdate -color {Dark Orchid} -format Literal -label {Register 13} -radix decimal /finaltbw/reg13
add wave -noupdate -color {Dark Orchid} -format Literal -label {Register 14} -radix decimal /finaltbw/reg14
add wave -noupdate -color {Dark Orchid} -format Literal -label {Register 15} -radix decimal /finaltbw/reg15
add wave -noupdate -divider -height 30 Memory
add wave -noupdate -color Khaki -format Literal -radix decimal /finaltbw/mem0
add wave -noupdate -color Khaki -format Literal -radix decimal /finaltbw/mem1
add wave -noupdate -color Khaki -format Literal -radix decimal /finaltbw/mem2
add wave -noupdate -color Khaki -format Literal -radix decimal /finaltbw/mem3
add wave -noupdate -color Khaki -format Literal -radix decimal /finaltbw/mem4
add wave -noupdate -color Khaki -format Literal -radix decimal /finaltbw/mem5
add wave -noupdate -color Khaki -format Literal -radix decimal /finaltbw/mem6
add wave -noupdate -color Khaki -format Literal -radix decimal /finaltbw/mem7
add wave -noupdate -color Khaki -format Literal -radix decimal /finaltbw/mem8
add wave -noupdate -color Khaki -format Literal -radix decimal /finaltbw/mem9
add wave -noupdate -color Khaki -format Literal -radix decimal /finaltbw/mem10
add wave -noupdate -color Khaki -format Literal -radix decimal /finaltbw/mem11
add wave -noupdate -color Khaki -format Literal -radix decimal /finaltbw/mem12
add wave -noupdate -color Khaki -format Literal -radix decimal /finaltbw/mem13
add wave -noupdate -color Khaki -format Literal -radix decimal /finaltbw/mem14
add wave -noupdate -color Khaki -format Literal -radix decimal /finaltbw/mem15
add wave -noupdate -divider -height 30 ALU
add wave -noupdate -color Green -format Literal -label {Alu input A} /finaltbw/a
add wave -noupdate -color Green -format Literal -label {Alu input B} /finaltbw/b
add wave -noupdate -color Green -format Literal /finaltbw/f
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
update
WaveRestoreZoom {0 ps} {16384 ns}
view wave 
wave clipboard store
wave modify -driver freeze -pattern constant -value 0 -starttime 0us -endtime 4us sim:/finaltbw/ext_int 
wave modify -driver freeze -pattern constant -value 1 -starttime 4us -endtime 20us Edit:/finaltbw/ext_int 
[findWindow wave].tree collapseall -1
wave clipboard restore
