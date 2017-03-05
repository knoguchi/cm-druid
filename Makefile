include config.mk

default:: build

clean:
	rm -rf *~ build $(PARCEL_DIR)
	mkdir -p downloads
	mkdir -p $(PARCEL_DIR)
	$(MAKE) -C druid clean

downloads/druid-$(DRUID_VERSION)-bin.tar.gz:
	cd downloads && $(MAKE)

druid/parcel.json:
	$(MAKE) -C druid

build/$(DRUID_PARCEL_NAME): druid/parcel.json downloads/druid-$(DRUID_VERSION)-bin.tar.gz
	mkdir -p build
	cd build && \
		tar xf ../downloads/$(DRUID_TAR) && \
		mv druid-$(DRUID_VERSION) $(DRUID_PARCEL) && \
                tar xf ../downloads/$(MYSQL_EXT_TAR) -C $(DRUID_PARCEL)/extensions && \
		mkdir -p $(DRUID_PARCEL)/meta && \
		cp ../druid/parcel.json $(DRUID_PARCEL)/meta && \
		cp ../druid/druid_env.sh $(DRUID_PARCEL)/meta && \
		tar czf $(DRUID_PARCEL_NAME) $(DRUID_PARCEL)

build/$(DRUID_PARCEL_NAME).sha: build/$(DRUID_PARCEL_NAME)
	$(SHA1) build/$(DRUID_PARCEL_NAME) | awk '{print $$1}' > build/$(DRUID_PARCEL_NAME).sha

build: build/$(DRUID_PARCEL_NAME).sha

install:
	cp build/$(DRUID_PARCEL_NAME) $(PARCEL_DIR)
	cp build/$(DRUID_PARCEL_NAME).sha $(PARCEL_DIR)
	python make_manifest.py $(PARCEL_DIR)

