################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../src/bsp/driver/riscv_mc/interrupt.c \
../src/bsp/driver/riscv_mc/pic.c \
../src/bsp/driver/riscv_mc/reg_access.c \
../src/bsp/driver/riscv_mc/stdlib.c \
../src/bsp/driver/riscv_mc/timer.c \
../src/bsp/driver/riscv_mc/util.c 

S_UPPER_SRCS += \
../src/bsp/driver/riscv_mc/crt0.S 

OBJS += \
./src/bsp/driver/riscv_mc/crt0.o \
./src/bsp/driver/riscv_mc/interrupt.o \
./src/bsp/driver/riscv_mc/pic.o \
./src/bsp/driver/riscv_mc/reg_access.o \
./src/bsp/driver/riscv_mc/stdlib.o \
./src/bsp/driver/riscv_mc/timer.o \
./src/bsp/driver/riscv_mc/util.o 

S_UPPER_DEPS += \
./src/bsp/driver/riscv_mc/crt0.d 

C_DEPS += \
./src/bsp/driver/riscv_mc/interrupt.d \
./src/bsp/driver/riscv_mc/pic.d \
./src/bsp/driver/riscv_mc/reg_access.d \
./src/bsp/driver/riscv_mc/stdlib.d \
./src/bsp/driver/riscv_mc/timer.d \
./src/bsp/driver/riscv_mc/util.d 


# Each subdirectory must supply rules for building sources it contributes
src/bsp/driver/riscv_mc/%.o: ../src/bsp/driver/riscv_mc/%.S
	@echo 'Building file: $<'
	@echo 'Invoking: GNU RISC-V Cross Assembler'
	riscv-none-embed-gcc -march=rv32ic -mabi=ilp32 -msmall-data-limit=8 -mno-save-restore -O2 -fmessage-length=0 -fsigned-char -ffunction-sections -fdata-sections  -g3 -x assembler-with-cpp -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -c -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '

src/bsp/driver/riscv_mc/%.o: ../src/bsp/driver/riscv_mc/%.c
	@echo 'Building file: $<'
	@echo 'Invoking: GNU RISC-V Cross C Compiler'
	riscv-none-embed-gcc -march=rv32ic -mabi=ilp32 -msmall-data-limit=8 -mno-save-restore -O2 -fmessage-length=0 -fsigned-char -ffunction-sections -fdata-sections  -g3 -DLSCC_STDIO_UART_APB -I"D:\docs\FPGA\SOC_IP\WS812_firmware2/src/bsp" -I"D:\docs\FPGA\SOC_IP\WS812_firmware2/src/bsp/driver" -I"D:\docs\FPGA\SOC_IP\WS812_firmware2/src/bsp/driver/gpio" -I"D:\docs\FPGA\SOC_IP\WS812_firmware2/src/bsp/driver/riscv_mc" -I"D:\docs\FPGA\SOC_IP\WS812_firmware2/src/bsp/driver/uart" -std=gnu11 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -c -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


