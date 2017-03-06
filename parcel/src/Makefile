include ../../config.mk

default:: build

clean:
	rm -f *~ parcel.json druid_env.sh

%.json: %.json.in
	sed -e 's/%%PARCEL_VERSION%%/$(PARCEL_VERSION)/g' \
	-e 's/%%DRUID_VERSION%%/$(DRUID_VERSION)/g' \
	-e 's/%%OS%%/$(OS)/g' \
	<$<>$@

%.sh: %.sh.in
	sed -e 's/%%DRUID_PARCEL%%/$(DRUID_PARCEL)/g' \
	<$<>$@

build: ../../config.mk parcel.json druid_env.sh
