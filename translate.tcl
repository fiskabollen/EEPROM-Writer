#
# Two files should be output:
#    <filename>_writer.asm to write the EEPROM
#    <filename>_tester.asm to verify the EEPROM
#
#  
set filename $argv
set systemTime [clock seconds]

puts ";Working on $filename"
puts ";[clock format $systemTime]"

set fp [open $filename r]
fconfigure $fp -translation binary
set inBinData [read $fp]
close $fp

binary scan $inBinData H* str 

# Strip off the first ff0000
# For z80asm only, not zasm
#set str [string range $str 6 [string length $str]]

# Output
#	movelw 0x%x		;HHH
#	call Output
# For each pair of hex digits
set bytecount 0
for {set i 0} {$i < [string length $str]} {set i [expr $i + 2]} {
	set hexpair [string range $str $i [expr $i + 1]]
	set hex_addr [format %03X $bytecount]
	puts "\t\tmovlw\t0x$hexpair\t\t;$hex_addr"
	puts "\t\tcall\tOutput"
	incr bytecount
} 

puts "\n\t\t;$bytecount bytes"
