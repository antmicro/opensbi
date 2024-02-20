#
# SPDX-License-Identifier: BSD-2-Clause
#
# Copyright (c) 2020 Antmicro.
#

# Compiler flags
platform-cppflags-y =
platform-cflags-y =
platform-asflags-y =
platform-ldflags-y =

# Objects to build
DT_NAME = RocketConfig

platform-objs-y += ../generic/platform.o
platform-objs-y += ../generic/platform_override_modules.o
platform-objs-y += $(DT_NAME).o

GENFLAGS += -I$(platform_parent_dir)/generic/include

# Blobs to build
FW_TEXT_START=0x80000000
FW_DYNAMIC=y
FW_JUMP=y

ifeq ($(PLATFORM_RISCV_XLEN), 32)
  # This needs to be 4MB aligned for 32-bit system
  FW_JUMP_ADDR=$(shell printf "0x%X" $$(($(FW_TEXT_START) + 0x400000)))
else
  # This needs to be 2MB aligned for 64-bit system
  FW_JUMP_ADDR=$(shell printf "0x%X" $$(($(FW_TEXT_START) + 0x200000)))
endif

FW_PAYLOAD=y
ifeq ($(PLATFORM_RISCV_XLEN), 32)
  # This needs to be 4MB aligned for 32-bit system
  FW_PAYLOAD_OFFSET=0x400000
else
  # This needs to be 2MB aligned for 64-bit system
  FW_PAYLOAD_OFFSET=0x200000
endif

# Attach custom-built device tree
FW_FDT_PATH=$(platform_build_dir)/$(DT_NAME).dtb
