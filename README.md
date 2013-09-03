EEPROM-Writer
=============

Using a PIC microcontroller as an EEPROM writer.
I needed a way of writing bytes to an EEPROM chip and my PIC microcontroller seemed a good-ish way to do it.  I had a few binary counter chips and a breadboard so I thought I could use the counter chips to hold address lines on the EEPROM while the PIC holds the data byte to be written on the data bus.  Then the PIC could pulse the "write" line and then pulse the 'increment' line to the counter chips.  Loop and repeat until you get to the end of the bytes to be written.
It's a bit of a faff, but it works!

It's quite a long-winded process to actually write an EEPROM:
1. run your rom file (a binary file of the bytes you want written) through translate.tcl - this will output PIC source
2. add the output PIC source to Template_writer.asm in the indicated place
2. load and assemble your resultant file in the PIC IDE
3. burn the resulting PIC program to the PIC
4. connect the PIC to the EEPROM writer circuit illustrated
5. insert your EEPROM into the circuit
6. reset the address counter (or set it to where you want the bytes written somehow)
7. run the PIC program

There's a verification mechanism to reveal any errors in the EEPROM contents.
