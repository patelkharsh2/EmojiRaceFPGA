## Clock signal
set_property -dict { PACKAGE_PIN E3    IOSTANDARD LVCMOS33 } [get_ports { clk }]; #IO_L12P_T1_MRCC_35 Sch=clk
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports {clk}];


##VGA Connector

set_property -dict { PACKAGE_PIN A3    IOSTANDARD LVCMOS33 } [get_ports { red[0] }]; #IO_L8N_T1_AD14N_35 Sch=red[0]
set_property -dict { PACKAGE_PIN B4    IOSTANDARD LVCMOS33 } [get_ports { red[1] }]; #IO_L7N_T1_AD6N_35 Sch=red[1]
set_property -dict { PACKAGE_PIN C5    IOSTANDARD LVCMOS33 } [get_ports { red[2] }]; #IO_L1N_T0_AD4N_35 Sch=red[2]
set_property -dict { PACKAGE_PIN A4    IOSTANDARD LVCMOS33 } [get_ports { red[3] }]; #IO_L8P_T1_AD14P_35 Sch=red[3]

set_property -dict { PACKAGE_PIN C6    IOSTANDARD LVCMOS33 } [get_ports { green[0] }]; #IO_L1P_T0_AD4P_35 Sch=green[0]
set_property -dict { PACKAGE_PIN A5    IOSTANDARD LVCMOS33 } [get_ports { green[1] }]; #IO_L3N_T0_DQS_AD5N_35 Sch=green[1]
set_property -dict { PACKAGE_PIN B6    IOSTANDARD LVCMOS33 } [get_ports { green[2] }]; #IO_L2N_T0_AD12N_35 Sch=green[2]
set_property -dict { PACKAGE_PIN A6    IOSTANDARD LVCMOS33 } [get_ports { green[3] }]; #IO_L3P_T0_DQS_AD5P_35 Sch=green[3]

set_property -dict { PACKAGE_PIN B7    IOSTANDARD LVCMOS33 } [get_ports { blue[0] }]; #IO_L2P_T0_AD12P_35 Sch=blue[0]
set_property -dict { PACKAGE_PIN C7    IOSTANDARD LVCMOS33 } [get_ports { blue[1] }]; #IO_L4N_T0_35 Sch=blue[1]
set_property -dict { PACKAGE_PIN D7    IOSTANDARD LVCMOS33 } [get_ports { blue[2] }]; #IO_L6N_T0_VREF_35 Sch=blue[2]
set_property -dict { PACKAGE_PIN D8    IOSTANDARD LVCMOS33 } [get_ports { blue[3] }]; #IO_L4P_T0_35 Sch=blue[3]

set_property -dict { PACKAGE_PIN B11   IOSTANDARD LVCMOS33 } [get_ports { vga_hsync }]; #IO_L4P_T0_15 Sch=vga_hs
set_property -dict { PACKAGE_PIN B12   IOSTANDARD LVCMOS33 } [get_ports { vga_vsync }]; #IO_L3N_T0_DQS_AD1N_15 Sch=vga_vs

#set_property -dict { PACKAGE_PIN N17   IOSTANDARD LVCMOS33 } [get_ports { btnC }]; #IO_L9P_T1_DQS_14 Sch=btnC
set_property -dict { PACKAGE_PIN M18   IOSTANDARD LVCMOS33 } [get_ports { U }]; #IO_L4N_T0_D05_14 Sch=btnU
set_property -dict { PACKAGE_PIN P17   IOSTANDARD LVCMOS33 } [get_ports { L }]; #IO_L12P_T1_MRCC_14 Sch=btnL
set_property -dict { PACKAGE_PIN M17   IOSTANDARD LVCMOS33 } [get_ports { R }]; #IO_L10N_T1_D15_14 Sch=btnR
set_property -dict { PACKAGE_PIN P18   IOSTANDARD LVCMOS33 } [get_ports { D }]; #IO_L9N_T1_DQS_D13_14 Sch=btnD
set_property -dict { PACKAGE_PIN N17   IOSTANDARD LVCMOS33 } [get_ports { C }]; #IO_L9N_T1_DQS_D13_14 Sch=btnC



#segment
##7 segment display
#Bank = 34, Pin name = IO_L2N_T0_34,						Sch name =SSEG_CA
set_property PACKAGE_PIN T10 [get_ports {SSEG_CA[0]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {SSEG_CA[0]}]
#Bank = 34, Pin name = IO_L3N_T0_DQS_34,					Sch name = CB
set_property PACKAGE_PIN R10 [get_ports {SSEG_CA[1]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {SSEG_CA[1]}]
#Bank = 34, Pin name = IO_L6N_T0_VREF_34,					Sch name = CC
set_property PACKAGE_PIN K16 [get_ports {SSEG_CA[2]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {SSEG_CA[2]}]
#Bank = 34, Pin name = IO_L5N_T0_34,						Sch name = CD
set_property PACKAGE_PIN K13 [get_ports {SSEG_CA[3]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {SSEG_CA[3]}]
#Bank = 34, Pin name = IO_L2P_T0_34,						Sch name = CE
set_property PACKAGE_PIN P15 [get_ports {SSEG_CA[4]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {SSEG_CA[4]}]
#Bank = 34, Pin name = IO_L4N_T0_34,						Sch name = CF
set_property PACKAGE_PIN T11 [get_ports {SSEG_CA[5]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {SSEG_CA[5]}]
#Bank = 34, Pin name = IO_L6P_T0_34,						Sch name = CG
set_property PACKAGE_PIN L18 [get_ports {SSEG_CA[6]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {SSEG_CA[6]}]
	
#Bank = 34, Pin name = IO_L16P_T2_34,						Sch name = DP
set_property PACKAGE_PIN H15 [get_ports SSEG_CA[7]]							
	set_property IOSTANDARD LVCMOS33 [get_ports SSEG_CA[7]]

#Bank = 34, Pin name = IO_L18N_T2_34,						Sch name =SSEG_AN0
set_property PACKAGE_PIN J17 [get_ports {SSEG_AN[0]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {SSEG_AN[0]}]
#Bank = 34, Pin name = IO_L18P_T2_34,						Sch name =SSEG_AN1
set_property PACKAGE_PIN J18 [get_ports {SSEG_AN[1]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {SSEG_AN[1]}]
#Bank = 34, Pin name = IO_L4P_T0_34,						Sch name =SSEG_AN2
set_property PACKAGE_PIN T9 [get_ports {SSEG_AN[2]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {SSEG_AN[2]}]
#Bank = 34, Pin name = IO_L13_T2_MRCC_34,					Sch name =SSEG_AN3
set_property PACKAGE_PIN J14 [get_ports {SSEG_AN[3]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {SSEG_AN[3]}]
#Bank = 34, Pin name = IO_L3P_T0_DQS_34,					Sch name =SSEG_AN4
set_property PACKAGE_PIN P14 [get_ports {SSEG_AN[4]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {SSEG_AN[4]}]
#Bank = 34, Pin name = IO_L16N_T2_34,						Sch name =SSEG_AN5
set_property PACKAGE_PIN T14 [get_ports {SSEG_AN[5]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {SSEG_AN[5]}]
#Bank = 34, Pin name = IO_L1P_T0_34,						Sch name =SSEG_AN6
set_property PACKAGE_PIN K2 [get_ports {SSEG_AN[6]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {SSEG_AN[6]}]
#Bank = 34, Pin name = IO_L1N_T034,							Sch name =SSEG_AN7
set_property PACKAGE_PIN U13 [get_ports {SSEG_AN[7]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {SSEG_AN[7]}]