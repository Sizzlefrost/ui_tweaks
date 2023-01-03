#
# To get started, copy makeconfig.example.mk as makeconfig.mk and fill in the appropriate paths.
#
# build (default): Build all the zips and kwads. "out/" is suitable for uploading to Steam.
# install: Copy mod files into a local installation of Invisible Inc
#

include makeconfig.mk

.PHONY: build install clean distclean
.SECONDEXPANSION:

files := modinfo.txt scripts.zip anims.kwad gui.kwad images.kwad rrni_gui.kwad tlv_anims.kwad
outfiles := $(addprefix out/, $(files))
installfiles := $(addprefix $(INSTALL_PATH)/, $(files))

ensuredir = @mkdir -p $(@D)

ifneq ($(INSTALL_PATH2),)
	installfiles += $(addprefix $(INSTALL_PATH2)/, $(files))
endif

build: $(outfiles)
install: build $(installfiles)

$(installfiles): %: out/$$(@F)
	$(ensuredir)
	cp $< $@

clean:
	rm tactical-lamp-mod/build/*
	rm out/*

distclean:
	rm -f $(INSTALL_PATH)/*.kwad $(INSTALL_PATH)/*.zip
ifneq ($(INSTALL_PATH2),)
	rm -f $(INSTALL_PATH2)/*.kwad $(INSTALL_PATH2)/*.zip
endif

out/modinfo.txt: modinfo.txt
	$(ensuredir)
	cp modinfo.txt out/modinfo.txt

out/rrni_gui.kwad: rrni_gui.kwad
	$(ensuredir)
	cp rrni_gui.kwad out/rrni_gui.kwad

#
## kwads and contained files
#

rawanims := $(patsubst %.py,%.xml,$(shell find anims -type f -name "animation.py"))
anims := $(patsubst %.anim.d,%.anim,$(shell find anims -type d -name "*.anim.d"))
gui_files := $(wildcard gui/**/*.png gui/*.lua gui/**/*.lua)
images_files := $(wildcard images/**/*.png)

$(rawanims): %.xml: %.py $$(wildcard $$*.vanilla.xml)
	python3 $*.py

$(anims): %.anim: $$(wildcard $$*.anim.d/animation.xml $$*.anim.d/build.xml $$*.anim.d/*.png)
	cd $*.anim.d && zip ../$(notdir $@) animation.xml build.xml *.png


out/anims.kwad out/gui.kwad out/images.kwad: $(anims) $(gui_files) $(images_files)
	$(ensuredir)
	$(KWAD_BUILDER) -i build.lua -o out

#
## scripts
#

out/scripts.zip: $(shell find scripts -type f -name "*.lua")
	$(ensuredir)
	cd scripts && zip -r ../$@ . -i '*.lua'

#
## Tactical Lamp View kwads
#

out/tlv_anims.kwad: tactical-lamp-mod/build/anims.kwad
	$(ensuredir)
	cp tactical-lamp-mod/build/anims.kwad out/tlv_anims.kwad

tlv_anims := $(wildcard tactical-lamp-mod/src/kwads/anims/**/*.anim)
tactical-lamp-mod/build/anims.kwad: $(tlv_anims)
	$(ensuredir)
	cd tactical-lamp-mod/src/kwads && $(KWAD_BUILDER) -i build.lua -o ../../build
