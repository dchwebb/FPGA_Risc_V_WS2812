################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../src/bsp/driver/uart/uart.c 

OBJS += \
./src/bsp/driver/uart/uart.o 

C_DEPS += \
./src/bsp/driver/uart/uart.d 


# Each subdirectory must supply rules for building sources it contributes
src/bsp/driver/uart/%.o: ../src/bsp/driver/uart/%.c
	@echo 'Building file: $<'
	@echo 'Invoking: GNU RISC-V Cross C Compiler'
	riscv-none-embed-gcc -march=rv32ic -mabi=ilp32 -msmall-data-limit=8 -mno-save-restore -O2 -fmessage-length=0 -fsigned-char -ffunction-sections -fdata-sections  -g3 -DLSCC_STDIO_UART_APB -I"D:\docs\FPGA\SOC_IP\WS812_firmware4/src/bsp" -I"D:\docs\FPGA\SOC_IP\WS812_firmware4/src/bsp/driver" -I"D:\docs\FPGA\SOC_IP\WS812_firmware4/src/bsp/driver/WS2812_IP" -I"D:\docs\FPGA\SOC_IP\WS812_firmware4/src/bsp/driver/gpio" -I"D:\docs\FPGA\SOC_IP\WS812_firmware4/src/bsp/driver/riscv_mc" -I"D:\docs\FPGA\SOC_IP\WS812_firmware4/src/bsp/driver/uart" -std=gnu11 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -c -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


