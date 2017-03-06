include ../config.mk

default:: downloads/druid-$(DRUID_VERSION)-bin.tar.gz build

clean:
	rm -rf *~ build
	mkdir -p downloads
	$(MAKE) -C src clean

downloads/druid-$(DRUID_VERSION)-bin.tar.gz:
	cd downloads && $(MAKE)

src/parcel.json:
	$(MAKE) -C src

build/$(DRUID_PARCEL_NAME): src/parcel.json downloads/druid-$(DRUID_VERSION)-bin.tar.gz
	mkdir -p build
	cd build && \
		tar xf ../downloads/$(DRUID_TAR) && \
		mv druid-$(DRUID_VERSION) $(DRUID_PARCEL) && \
                tar xf ../downloads/$(MYSQL_EXT_TAR) -C $(DRUID_PARCEL)/extensions && \
		mkdir -p $(DRUID_PARCEL)/meta && \
		cp ../src/parcel.json $(DRUID_PARCEL)/meta && \
		cp ../src/druid_env.sh $(DRUID_PARCEL)/meta && \
		tar czf $(DRUID_PARCEL_NAME) $(DRUID_PARCEL)

build/$(DRUID_PARCEL_NAME).sha: build/$(DRUID_PARCEL_NAME)
	$(SHA1) build/$(DRUID_PARCEL_NAME) | awk '{print $$1}' > build/$(DRUID_PARCEL_NAME).sha

build: build/$(DRUID_PARCEL_NAME).sha

install: build
	mkdir -p ../$(DIST_DIR)/parcels
	cp build/$(DRUID_PARCEL_NAME) ../$(DIST_DIR)/parcels
	cp build/$(DRUID_PARCEL_NAME).sha ../$(DIST_DIR)/parcels
	python make_manifest.py ../$(DIST_DIR)/parcels

