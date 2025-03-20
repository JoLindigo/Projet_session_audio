## ========================
##   Constraint File for Zybo Z7-10
## ========================

## ==========
## System Clock (100 MHz)
## ==========
set_property -dict { PACKAGE_PIN K17 IOSTANDARD LVCMOS33 } [get_ports { clk }];
create_clock -add -name sys_clk -period 10.00 -waveform {0 5} [get_ports { clk }];

## ==========
## I2S Audio Output
## ==========
set_property -dict { PACKAGE_PIN R19 IOSTANDARD LVCMOS33 } [get_ports { i2s_bclk }];    # Bit Clock (BCLK)
set_property -dict { PACKAGE_PIN T19 IOSTANDARD LVCMOS33 } [get_ports { i2s_lrclk }];   # LR Clock (LRCLK)
set_property -dict { PACKAGE_PIN R18 IOSTANDARD LVCMOS33 } [get_ports { i2s_data }];    # Data Out (I2S DATA)
set_property -dict { PACKAGE_PIN R17 IOSTANDARD LVCMOS33 } [get_ports { i2s_mclk }];    # Master Clock (MCLK)

## ==========
## PMOD - Track Selection & Effect Input
## ==========
set_property -dict { PACKAGE_PIN N15 IOSTANDARD LVCMOS33 PULLUP TRUE } [get_ports { track_select[0] }];  # Track Select Bit 0
set_property -dict { PACKAGE_PIN L14 IOSTANDARD LVCMOS33 PULLUP TRUE } [get_ports { track_select[1] }];  # Track Select Bit 1
set_property -dict { PACKAGE_PIN K16 IOSTANDARD LVCMOS33 PULLUP TRUE } [get_ports { track_select[2] }];  # Track Select Bit 2
set_property -dict { PACKAGE_PIN K14 IOSTANDARD LVCMOS33 PULLUP TRUE } [get_ports { effect_enable }];    # Effect Enable Bit

## ==========
## Debug LEDs (Optional)
## ==========
set_property -dict { PACKAGE_PIN M14 IOSTANDARD LVCMOS33 } [get_ports { led_debug[0] }]; # Debug LED 0
set_property -dict { PACKAGE_PIN M15 IOSTANDARD LVCMOS33 } [get_ports { led_debug[1] }]; # Debug LED 1
set_property -dict { PACKAGE_PIN G14 IOSTANDARD LVCMOS33 } [get_ports { led_debug[2] }]; # Debug LED 2
set_property -dict { PACKAGE_PIN D18 IOSTANDARD LVCMOS33 } [get_ports { led_debug[3] }]; # Debug LED 3
