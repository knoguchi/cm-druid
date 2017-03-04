PARCEL_VERSION=0.0.3
PARCEL_DIR=parcels

DRUID_VERSION=0.9.2
#DRUID_VERSION=0.10.0-rc1

TRANQUILITY_VERSION=0.8.2

MYSQL_EXT_VERSION=0.9.2
#MYSQL_EXT_VERSION=0.10.0-rc1

DRUID_TAR=druid-${DRUID_VERSION}-bin.tar.gz
TRANQUILITY_TAR=tranquility-distribution-${TRANQUILITY_VERSION}.tgz
MYSQL_EXT_TAR=mysql-metadata-storage-${MYSQL_EXT_VERSION}.tar.gz

DRUID_URL=http://static.druid.io/artifacts/releases/${DRUID_TAR}
TRANQUILITY_URL=http://static.druid.io/tranquility/releases/${TRANQUILITY_TAR}
MYSQL_EXT_URL=http://static.druid.io/artifacts/releases/${MYSQL_EXT_TAR}

SHA1=shasum

OS=el6

# do not edit below
DRUID_PARCEL=DRUID-${DRUID_VERSION}-${PARCEL_VERSION}
DRUID_PARCEL_NAME=${DRUID_PARCEL}-${OS}.parcel
