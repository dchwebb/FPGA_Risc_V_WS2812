# FPGA Risc V SOC with custom LED IP

This project implements a Risc V processor on a Lattice Mach X03LF FPGA (using the MachX0LF Starter Kit development board). The SOC is built using Lattice's Propel Builder software and implements a Risc V CPU with 16KB of RAM (using EBR blocks), AHB and APB buses, an 8 pin GPIO peripheral, UART and a custom WS2812 addressible led driver.

![Image](https://raw.githubusercontent.com/dchwebb/FPGA_Risc_V_WS2812/main/pictures/propel_builder.png "icon")

The custom WS2812 addressible led driver was developed in Verilog and the IP implemented in Lattice's IP Packager. The registers are memory mapped over the APB bus and supports interrupts. A simple C driver is also included. Source for the IP package is [here](https://github.com/dchwebb/WS2812_IP). 

![Image](https://raw.githubusercontent.com/dchwebb/FPGA_Risc_V_WS2812/main/pictures/ip_packager.png "icon")

The test firmare is written in C and demonstrates memory mapped register access and interrupt handling. The firmware is supplied as a Propel Eclipse C project in the appropriate firmware folder of this repository.
