################################################################################
# Automatically-generated file. Do not edit!
################################################################################

-include ../makefile.init

RM := rm -rf

# All of the sources participating in the build are defined here
-include sources.mk
-include src/bsp/driver/uart/subdir.mk
-include src/bsp/driver/riscv_mc/subdir.mk
-include src/bsp/driver/gpio/subdir.mk
-include src/subdir.mk
-include subdir.mk
-include objects.mk

ifneq ($(MAKECMDGOALS),clean)
ifneq ($(strip $(ASM_DEPS)),)
-include $(ASM_DEPS)
endif
ifneq ($(strip $(S_UPPER_DEPS)),)
-include $(S_UPPER_DEPS)
endif
ifneq ($(strip $(C_DEPS)),)
-include $(C_DEPS)
endif
endif

-include ../makefile.defs

# Add inputs and outputs from these tool invocations to the build variables 
SECONDARY_LIST += \
WS812_firmware2.lst \

SECONDARY_SIZE += \
WS812_firmware2.siz \

SECONDARY_MEMORY += \
WS812_firmware2.mem \


# All Target
all: WS812_firmware2.elf secondary-outputs

# Tool invocations
WS812_firmware2.elf: $(OBJS) $(USER_OBJS)
	@echo 'Building target: $@'
	@echo 'Invoking: GNU RISC-V Cross C Linker'
	riscv-none-embed-gcc -march=rv32ic -mabi=ilp32 -msmall-data-limit=8 -mno-save-restore -O2 -fmessage-length=0 -fsigned-char -ffunction-sections -fdata-sections  -g3 -T "D:/docs/FPGA/SOC_IP/WS812_firmware2/src/linker.ld" -nostartfiles -Xlinker --gc-sections -Wl,-Map,"WS812_firmware2.map" --specs=nano.specs --specs=nosys.specs -o "WS812_firmware2.elf" $(OBJS) $(USER_OBJS) $(LIBS)
	@echo 'Finished building target: $@'
	@echo ' '

WS812_firmware2.lst: WS812_firmware2.elf
	@echo 'Invoking: GNU RISC-V Cross Create Listing'
	riscv-none-embed-objdump --source --all-headers --demangle --line-numbers --wide "WS812_firmware2.elf" > "WS812_firmware2.lst"
	@echo 'Finished building: $@'
	@echo ' '

WS812_firmware2.siz: WS812_firmware2.elf
	@echo 'Invoking: GNU RISC-V Cross Print Size'
	riscv-none-embed-size --format=berkeley "WS812_firmware2.elf"
	@echo 'Finished building: $@'
	@echo ' '

WS812_firmware2.mem: WS812_firmware2.elf
	@echo 'Invoking: Lattice Create Memory Deployment'
	riscv-none-embed-objcopy -O binary --gap-fill 0 "WS812_firmware2.elf" "WS812_firmware2.bin"; srec_cat "WS812_firmware2.bin" -Binary -byte-swap 4 -DISable Header -Output "WS812_firmware2.mem" -MEM 32
	@echo 'Finished building: $@'
	@echo ' '

# Other Targets
clean:
	-$(RM) $(SECONDARY_MEMORY)$(OBJS)$(SECONDARY_LIST)$(SECONDARY_SIZE)$(ASM_DEPS)$(S_UPPER_DEPS)$(C_DEPS) WS812_firmware2.elf
	-@echo ' '

secondary-outputs: $(SECONDARY_LIST) $(SECONDARY_SIZE) $(SECONDARY_MEMORY)

.PHONY: all clean dependents

-include ../makefile.targets
