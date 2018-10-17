CONTROLLER=stm8s105k6
SDCC=sdcc
STM8FLASH=stm8flash
PROGRAMMER=stlinkv2

MAIN=main.c
CFLAGS = -lstm8 -mstm8 --std-c11 --opt-code-size
SRC=system.c systemtimer.c strings.c flash.c uart.c displays.c button.c encoder.c encoderbutton.c beep.c fan.c load.c adc.c ringbuffer.c
BUILDDIR=bin
RELS=$(patsubst %.c,$(BUILDDIR)/%.rel, $(MAIN) $(SRC))
IHX=$(MAIN:%.c=$(BUILDDIR)/%.ihx)

.PHONY: all mkdir clean flash eeprom unlock bin

all: bin

mkdir:
	@mkdir -p $(BUILDDIR)

bin: mkdir $(IHX)

$(IHX): $(RELS)
	$(SDCC) $(CFLAGS) $(RELS) -o $@

$(BUILDDIR)/%.rel: %.c
	$(SDCC) -c $(CFLAGS) $< -o $@

clean:
	@rm -rf bin

#echo "0000ff00ff00ff00ff00ff00ff00ff" | xxd -r -p > misc/default_opt.bin
unlock:
	$(STM8FLASH) -c $(PROGRAMMER) -p $(CONTROLLER) -s opt -w misc/default_opt.bin
	#$(STM8FLASH) -c $(PROGRAMMER) -p $(CONTROLLER) -u # Works only in stm8flash versions after git commit f3f547b4

flash: $(IHX)
	$(STM8FLASH) -c $(PROGRAMMER) -p $(CONTROLLER) -w $(IHX)

eeprom:
	$(STM8FLASH) -c $(PROGRAMMER) -p $(CONTROLLER) -s eeprom -w misc/eeprom.bin
