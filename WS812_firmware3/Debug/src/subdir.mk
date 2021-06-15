################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../src/main.c \
../src/utils.c 

OBJS += \
./src/main.o \
./src/utils.o 

C_DEPS += \
./src/main.d \
./src/utils.d 


# Each subdirectory must supply rules for building sources it contributes
src/%.o: ../src/%.c
	@echo 'Building file: $<'
	@echo 'Invoking: GNU RISC-V Cross C Compiler'
	riscv-none-embed-gcc -march=rv32ic -mabi=ilp32 -msmall-data-limit=8 -mno-save-restore -O0 -fmessage-length=0 -fsigned-char -ffunction-sections -fdata-sections  -g3 -DLSCC_STDIO_UART_APB -I"D:\docs\FPGA\SOC_IP\WS812_firmware3/src/bsp" -I"D:\docs\FPGA\SOC_IP\WS812_firmware3/src/bsp/driver" -I"D:\docs\FPGA\SOC_IP\WS812_firmware3/src/bsp/driver/gpio" -I"D:\docs\FPGA\SOC_IP\WS812_firmware3/src/bsp/driver/riscv_mc" -I"D:\docs\FPGA\SOC_IP\WS812_firmware3/src/bsp/driver/uart" -I"D:\docs\FPGA\SOC_IP\WS812_firmware3\src\bsp\driver\WS2812" -std=gnu11 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -c -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


