include ../config.mk

default:: build

clean:
	rm -rf *~ target ../dist/DRUID-$(CDH_VERSION).jar

target/DRUID-$(CDH_VERSION).jar:
	mvn install

build: ../config.mk target/DRUID-$(CDH_VERSION).jar

install: build
	mkdir -p ../$(DIST_DIR)/csd
	cp target/DRUID-$(CDH_VERSION).jar ../$(DIST_DIR)/csd
