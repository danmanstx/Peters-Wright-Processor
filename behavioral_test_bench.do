onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -color Gray60 -format Logic -label {global clock} /Processor/g_clk
add wave -noupdate -color Gray60 -format Logic -label {global clear} /Processor/g_clr
add wave -noupdate -format Logic /Processor/ext_int
add wave -noupdate -divider -height 50 {vv PC vv}
add wave -noupdate -color Gold -format Literal -label {PC out} -radix unsigned /Processor/PC/out
add wave -noupdate -format Literal -label {PC load input} -radix hexadecimal /Processor/PC/ld_in
add wave -noupdate -format Literal -label {PC control} /Processor/PC/ctrl
add wave -noupdate -format Literal -label {PC input mux select} /Processor/PC_MUX_0/sel
add wave -noupdate -color Gold -format Literal -label {PC out} -radix hexadecimal /Processor/PC_MUX_0/in
add wave -noupdate -color Red -format Literal -label {bubble register} -radix unsigned /Processor/PSR0/bubble_reg
add wave -noupdate -format Logic -label {bubble clear} /Processor/PSR0/bubble_clr
add wave -noupdate -format Logic -label {bubble in} /Processor/PSR0/bubble
add wave -noupdate -divider -height 30 {vv States vv}
add wave -noupdate -color Red -format Literal -label {state 0} -radix unsigned /Processor/CNTRL/state0
add wave -noupdate -color White -format Literal -label {state 1} -radix unsigned /Processor/CNTRL/state1
add wave -noupdate -color Blue -format Literal -label {state 2} -radix unsigned /Processor/CNTRL/state2
add wave -noupdate -divider -height 50 {vv ALU vv}
add wave -noupdate -format Literal -label A -radix hexadecimal /Processor/ALU/a
add wave -noupdate -format Literal -label B -radix hexadecimal /Processor/ALU/b
add wave -noupdate -format Logic -label cin /Processor/ALU/cin
add wave -noupdate -format Literal -label ctrl /Processor/ALU/ctrl
add wave -noupdate -format Literal -label F -radix hexadecimal /Processor/ALU/f
add wave -noupdate -format Logic /Processor/ALU/v
add wave -noupdate -format Logic /Processor/ALU/z
add wave -noupdate -divider -height 50 {vv MHVPIS vv}
add wave -noupdate -format Literal -label {irupt in} /Processor/INT_SYS/irupt_in
add wave -noupdate -format Literal -label {mask in} /Processor/INT_SYS/mask_in
add wave -noupdate -format Logic /Processor/INT_SYS/enable
add wave -noupdate -format Logic /Processor/INT_SYS/i_pending
add wave -noupdate -format Literal -radix unsigned /Processor/INT_SYS/PC_out
add wave -noupdate -divider -height 50 {vv Stack vv}
add wave -noupdate -format Logic -label push/pop /Processor/RETURN_STACK/c
add wave -noupdate -format Logic -label enable /Processor/RETURN_STACK/en
add wave -noupdate -format Literal -label {push (input)} -radix hexadecimal /Processor/RETURN_STACK/push
add wave -noupdate -format Literal -label {peek (output)} -radix hexadecimal /Processor/RETURN_STACK/peek
add wave -noupdate -format Logic -label {is full} /Processor/RETURN_STACK/full
add wave -noupdate -format Logic -label {is empty} /Processor/RETURN_STACK/empty
add wave -noupdate -format Literal -label {stack data} -radix hexadecimal /Processor/RETURN_STACK/data
add wave -noupdate -format Literal -label pointer -radix unsigned /Processor/RETURN_STACK/ptr
add wave -noupdate -divider -height 50 {vv IR vv}
add wave -noupdate -format Literal -label {IR in} -expand /Processor/IR/in
add wave -noupdate -format Logic -label load /Processor/IR/c
add wave -noupdate -format Literal -label {IR out} /Processor/IR/out
add wave -noupdate -divider -height 50 {vv PSR0 vv}
add wave -noupdate -format Literal -label {PSR0 in} -expand /Processor/PSR0/in
add wave -noupdate -format Literal -label {PSR0 in data register} /Processor/PSR0/in_data
add wave -noupdate -color White -format Literal -label {PSR0 out} /Processor/PSR0/out
add wave -noupdate -format Logic -label {load Ri} /Processor/PSR0/ld_ri
add wave -noupdate -divider -height 50 {vv Controller vv}
add wave -noupdate -format Literal /Processor/CNTRL/opcode
add wave -noupdate -divider -height 30 {vv PSR0 MUX vv}
add wave -noupdate -format Literal -label {SEX in} -radix hexadecimal /Processor/SEX/in
add wave -noupdate -format Literal -label {SEX out} -radix hexadecimal /Processor/SEX/out
add wave -noupdate -format Literal -label {PSR0 MUX inputs} -radix hexadecimal /Processor/PSR0_MUX/in
add wave -noupdate -format Literal -label {PSR0 MUX sel} /Processor/PSR0_MUX/sel
add wave -noupdate -format Literal -label {PSR0 Ri in} -radix hexadecimal /Processor/PSR0_MUX/out
add wave -noupdate -divider -height 50 {vv PSR1 vv}
add wave -noupdate -format Literal -label {PSR1 in} /Processor/PSR1/in
add wave -noupdate -format Literal -label {PSR1 in data register} /Processor/PSR1/in_data
add wave -noupdate -color White -format Literal -label {PSR1 out} /Processor/PSR1/out
add wave -noupdate -divider -height 50 {vv Register File vv}
add wave -noupdate -color {Dark Orchid} -format Literal -label {register data} -radix decimal -expand /Processor/REG_FILE/registers
add wave -noupdate -format Logic -label {write line} /Processor/REG_FILE/write
add wave -noupdate -format Literal -label {write data address} -radix unsigned /Processor/REG_FILE/writeaddr
add wave -noupdate -format Literal -label {write data} -radix hexadecimal /Processor/REG_FILE/data_in
add wave -noupdate -format Literal -label {Rd address} -radix unsigned /Processor/REG_FILE/reg1addr
add wave -noupdate -format Literal -label {Rd data out} -radix hexadecimal /Processor/REG_FILE/data0
add wave -noupdate -format Literal -label {Rs address} -radix unsigned /Processor/REG_FILE/reg0addr
add wave -noupdate -format Literal -label {Rs data out} -radix hexadecimal /Processor/REG_FILE/data1
add wave -noupdate -divider -height 50 {vv Data RAM vv}
add wave -noupdate -format Literal -label {data line} -radix hexadecimal /Processor/D_RAM/data
add wave -noupdate -format Logic -label {chip enable} /Processor/D_RAM/ce
add wave -noupdate -format Logic -label read/write /Processor/D_RAM/rw
add wave -noupdate -format Literal -label address -radix hexadecimal /Processor/D_RAM/addr
add wave -noupdate -format Literal -label data -radix decimal /Processor/D_RAM/memory
add wave -noupdate -format Literal -height 15 -label {data[0]} -radix decimal {/Processor/D_RAM/memory[0]}
add wave -noupdate -divider -height 50 {vv Instruction RAM vv}
add wave -noupdate -format Literal -label address -radix hexadecimal /Processor/I_RAM/addr
add wave -noupdate -format Logic -label {chip enabled (read only)} /Processor/I_RAM/ce
add wave -noupdate -format Literal -label {instruction out} /Processor/I_RAM/data
add wave -noupdate -divider -height 30 {vv select lines vv}
add wave -noupdate -format Literal /Processor/s
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1885 ps} 0}
configure wave -namecolwidth 256
configure wave -valuecolwidth 61
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
WaveRestoreZoom {1828 ps} {2058 ps}
view wave 
wave clipboard store
wave modify -driver freeze -pattern constant -value 0 -starttime 0ps -endtime 10ps sim:/Processor/g_clr 
wave modify -driver freeze -pattern constant -value 1 -starttime 10ps -endtime 5000ps Edit:/Processor/g_clr 
wave modify -driver freeze -pattern constant -value St1 -starttime 10ps -endtime 50000ps Edit:/Processor/g_clr 
wave modify -driver freeze -pattern constant -value St1 -starttime 10ps -endtime 60000ps Edit:/Processor/g_clr 
wave modify -driver freeze -pattern constant -value 0 -starttime 0ps -endtime 10ps sim:/Processor/g_clr 
wave modify -driver freeze -pattern constant -value 1 -starttime 10ps -endtime 5000ps Edit:/Processor/g_clr 
wave modify -driver freeze -pattern clock -initialvalue 0 -period 10ps -dutycycle 50 -starttime 0ps -endtime 50000ps sim:/Processor/g_clk 
wave modify -driver freeze -pattern constant -value St1 -starttime 10ps -endtime 50000ps Edit:/Processor/g_clr 
wave modify -driver freeze -pattern clock -initialvalue St0 -period 10ps -dutycycle 50 -starttime 0ps -endtime 50000ps Edit:/Processor/g_clk 
wave modify -driver freeze -pattern constant -value St1 -starttime 10ps -endtime 60000ps Edit:/Processor/g_clr 
wave modify -driver freeze -pattern clock -initialvalue St0 -period 10ps -dutycycle 50 -starttime 0ps -endtime 60000ps Edit:/Processor/g_clk 
wave modify -driver freeze -pattern clock -initialvalue St0 -period 10ps -dutycycle 50 -starttime 0ps -endtime 60000ps Edit:/Processor/g_clk 
wave modify -driver freeze -pattern constant -value 0 -starttime 0ps -endtime 10000ps sim:/Processor/ext_int 
wave modify -driver freeze -pattern constant -value 1 -starttime 3035ps -endtime 10000ps Edit:/Processor/ext_int 
wave modify -driver freeze -pattern constant -value St1 -starttime 1885ps -endtime 10000ps Edit:/Processor/ext_int 
[findWindow wave].tree collapseall -1
wave clipboard restore
