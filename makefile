# C Options
CC := clang
STD := c99
TARGET := program.exe

CFLAGS := -Wall -Wextra -Wconversion -pedantic
DEBUG_FLAGS := -g -O2
RELEASE_FLAGS := -O3

# Directories
SRCDIR := src
OUTDIR := out

# Functions
rwildcard = $(foreach d,$(wildcard $(1:=/*)),$(call rwildcard,$d,$2) $(filter $(subst *,%,$2),$d))

# Sources
SRCS := $(call rwildcard,$(SRCDIR),*.c)
OBJS := $(patsubst $(SRCDIR)/%.c, $(OUTDIR)/o/%.o, $(SRCS))

# Libraries
LIBS :=

# Phony
.PHONY: all debug release fresh run clean

all: debug
debug: $(OUTDIR)/debug/$(TARGET)
fresh: clean $(OUTDIR)/debug/$(TARGET)
release: $(OUTDIR)/release/$(TARGET) 
	
run: debug
	@echo [Running "$(OUTDIR)/debug/$(TARGET)"]
	@$(OUTDIR)/debug/$(TARGET)

clean:
	@echo [Cleaning up...]
	@rm -rf $(OUTDIR)/debug/*
	@rm -rf $(OUTDIR)/release/*
	@rm -rf $(OUTDIR)/o/*

# Outputs
$(OUTDIR)/debug:
	@mkdir -p "$(OUTDIR)/debug"
$(OUTDIR)/release:
	@mkdir -p "$(OUTDIR)/release"
$(OUTDIR)/o:
	@mkdir -p "$(OUTDIR)/o"

# Targets
$(OUTDIR)/debug/$(TARGET): $(eval CFLAGS += $(DEBUG_FLAGS)) $(OUTDIR)/debug $(OBJS)
	@echo [Building Target $@]
	@$(CC) -g -std=$(STD) $(CFLAGS) -o "$@" $(filter $(OUTDIR)/o/%.o,$(OBJS))

$(OUTDIR)/release/$(TARGET): $(eval CFLAGS += $(RELEASE_FLAGS)) $(OUTDIR)/release $(OBJS)
	@echo [Building Target $@]
	@$(CC) -std=$(STD) $(CFLAGS) $(LIBS) -o "$@" $(filter $(OUTDIR)/o/%.o,$(OBJS))

# Build objects
$(OUTDIR)/o/%.o: $(SRCDIR)/%.c $(OUTDIR)/o
	@echo [Building Object $@]
	@mkdir -p "$(@D)"
	@$(CC) -std=$(STD) $(CFLAGS) $(LIBS) -c $< -o "$@"