onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider -height 30 {Clock and Clear}
add wave -noupdate -color Gray60 -format Logic -label clear /asdf/g_clr
add wave -noupdate -color Gray60 -format Logic -label {global clock} /asdf/g_clk
add wave -noupdate -divider -height 30 Inputs
add wave -noupdate -format Logic /asdf/hs_in
add wave -noupdate -format Logic /asdf/ext_int
add wave -noupdate -format Literal /asdf/bus_in
add wave -noupdate -divider -height 30 {PC AND INSTR}
add wave -noupdate -color Blue -format Literal -radix binary /asdf/ir_out
add wave -noupdate -color Gold -format Literal -label {Program Counter} -radix hexadecimal /asdf/program_counter
add wave -noupdate -divider -height 30 Outputs
add wave -noupdate -format Literal /asdf/bus_out
add wave -noupdate -format Logic /asdf/hs_out
add wave -noupdate -divider -height 30 Registers
add wave -noupdate -color {Dark Orchid} -format Literal -label {Register 0} -radix decimal /asdf/reg0
add wave -noupdate -color {Dark Orchid} -format Literal -label {Register 1} -radix decimal /asdf/reg1
add wave -noupdate -color {Dark Orchid} -format Literal -label {Register 2} -radix decimal /asdf/reg2
add wave -noupdate -color {Dark Orchid} -format Literal -label {Register 3} -radix decimal /asdf/reg3
add wave -noupdate -color {Dark Orchid} -format Literal -label {Register 4} -radix decimal /asdf/reg4
add wave -noupdate -color {Dark Orchid} -format Literal -label {Register 5} -radix decimal /asdf/reg5
add wave -noupdate -color {Dark Orchid} -format Literal -label {Register 6} -radix decimal /asdf/reg6
add wave -noupdate -color {Dark Orchid} -format Literal -label {Register 7} -radix decimal /asdf/reg7
add wave -noupdate -color {Dark Orchid} -format Literal -label {Register 8} -radix decimal /asdf/reg8
add wave -noupdate -color {Dark Orchid} -format Literal -label {Register 9} -radix decimal /asdf/reg9
add wave -noupdate -color {Dark Orchid} -format Literal -label {Register 10} -radix decimal /asdf/reg10
add wave -noupdate -color {Dark Orchid} -format Literal -label {Register 11} -radix decimal /asdf/reg11
add wave -noupdate -color {Dark Orchid} -format Literal -label {Register 12} -radix decimal /asdf/reg12
add wave -noupdate -color {Dark Orchid} -format Literal -label {Register 13} -radix decimal /asdf/reg13
add wave -noupdate -color {Dark Orchid} -format Literal -label {Register 14} -radix decimal /asdf/reg14
add wave -noupdate -color {Dark Orchid} -format Literal -label {Register 15} -radix decimal /asdf/reg15
add wave -noupdate -divider -height 30 Memory
add wave -noupdate -color Khaki -format Literal -radix decimal /asdf/mem0
add wave -noupdate -color Khaki -format Literal -radix decimal /asdf/mem1
add wave -noupdate -color Khaki -format Literal -radix decimal /asdf/mem2
add wave -noupdate -color Khaki -format Literal -radix decimal /asdf/mem3
add wave -noupdate -color Khaki -format Literal -radix decimal /asdf/mem4
add wave -noupdate -color Khaki -format Literal -radix decimal /asdf/mem5
add wave -noupdate -color Khaki -format Literal -radix decimal /asdf/mem6
add wave -noupdate -color Khaki -format Literal -radix decimal /asdf/mem7
add wave -noupdate -color Khaki -format Literal -radix decimal /asdf/mem8
add wave -noupdate -color Khaki -format Literal -radix decimal /asdf/mem9
add wave -noupdate -color Khaki -format Literal -radix decimal /asdf/mem10
add wave -noupdate -color Khaki -format Literal -radix decimal /asdf/mem11
add wave -noupdate -color Khaki -format Literal -radix decimal /asdf/mem12
add wave -noupdate -color Khaki -format Literal -radix decimal /asdf/mem13
add wave -noupdate -color Khaki -format Literal -radix decimal /asdf/mem14
add wave -noupdate -color Khaki -format Literal -radix decimal /asdf/mem15
add wave -noupdate -divider -height 30 ALU
add wave -noupdate -color Green -format Literal -label {Alu input A} /asdf/a
add wave -noupdate -color Green -format Literal -label {Alu input B} /asdf/b
add wave -noupdate -color Green -format Literal /asdf/f
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
WaveRestoreZoom {0 ps} {65536 ns}
