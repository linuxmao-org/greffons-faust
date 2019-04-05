PREFIX ?= /usr/local
LV2_URI_PREFIX = https://github.com/linuxmao-org/greffons-faust

GREFFONS := flanger.lv2

all: $(GREFFONS)

clean:
	rm -rf $(GREFFONS)

install: all
	install -d $(DESTDIR)$(PREFIX)/lib/lv2
	$(foreach g,$(GREFFONS),cp -rfd $(g) $(DESTDIR)$(PREFIX)/lib/lv2;)

%.lv2: %.dsp
	faust2lv2 -uri-prefix $(LV2_URI_PREFIX) $<

.PHONY: all clean install
