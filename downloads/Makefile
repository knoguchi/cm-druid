include ../config.mk

.SUFFIXES: .sha1

default:: download

clean:
	rm -f *~ *.tar.gz *.tgz 

$(DRUID_TAR).sha1: $(DRUID_TAR)
	shasum $< > $@

$(TRANQUILITY_TAR).sha1: $(TRANQUILITY_TAR)
	shasum $< > $@

$(MYSQL_EXT_TAR).sha1: $(MYSQL_EXT_TAR)
	shasum $< > $@

$(DRUID_TAR):
	wget $(DRUID_URL) -O $(DRUID_TAR)

$(TRANQUILITY_TAR):
	wget $(TRANQUILITY_URL) -O $(TRANQUILITY_TAR)

$(MYSQL_EXT_TAR): 
	wget $(MYSQL_EXT_URL) -O $(MYSQL_EXT_TAR)

download: $(DRUID_TAR).sha1 $(TRANQUILITY_TAR).sha1 $(MYSQL_EXT_TAR).sha1
