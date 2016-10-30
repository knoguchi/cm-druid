include ../config.mk

default:: build

clean:
	rm -f *~ parcel.json

%.json: %.json.in
	sed -e 's/%%PARCEL_VERSION%%/$(PARCEL_VERSION)/g' \
	-e 's/%%DRUID_VERSION%%/$(DRUID_VERSION)/g' \
	-e 's/%%OS%%/$(OS)/g' \
	<$<>$@

build: parcel.json
