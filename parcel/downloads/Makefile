include ../config.mk

.SUFFIXES: .sha

default:: download

clean:
	rm -f *~ *.tar.gz *.tgz *.sha

$(DRUID_TAR).sha: $(DRUID_TAR)
	shasum $< > $@

$(TRANQUILITY_TAR).sha: $(TRANQUILITY_TAR)
	shasum $< > $@

$(MYSQL_EXT_TAR).sha: $(MYSQL_EXT_TAR)
	shasum $< > $@

$(DRUID_TAR):
	wget $(DRUID_URL) -O $(DRUID_TAR)

$(TRANQUILITY_TAR):
	wget $(TRANQUILITY_URL) -O $(TRANQUILITY_TAR)

$(MYSQL_EXT_TAR): 
	wget $(MYSQL_EXT_URL) -O $(MYSQL_EXT_TAR)

download: $(DRUID_TAR).sha $(TRANQUILITY_TAR).sha $(MYSQL_EXT_TAR).sha
