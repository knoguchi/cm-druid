include ./config.mk

default:: build

clean:
	rm -rf *~ build $(DIST_DIR)
	mkdir -p $(DIST_DIR)
	$(MAKE) -C csd clean
	$(MAKE) -C parcel clean

build:
	$(MAKE) -C csd build
	$(MAKE) -C parcel build

install:
	$(MAKE) -C csd install
	$(MAKE) -C parcel install
