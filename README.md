# Druid for Cloudera CDH

- Create CDH parcels from Druid distribution.
- Create Druid services descriptor

# Build

Run make at the top directory.  The parcels and CSD will be created at dist/parcels and dist/csd.

```
make clean install
```

# Parcels Installation

Put dist/pracels and manifest files in a web server.
Add the URL to the CDH Parcel Repo

Refersh parcel screen and make sure DRUID appears in the list.
Download, distribute, and activate.


# CSD Installation

Copy CSD jar file to /opt/cloudera/csd.

```
cp dist/csd/DRUID-5.8.0.jar /opt/cloudera/csd
chown cloudera-scm:cloudera-scm /opt/cloudera/csd/DRUID-5.8.0.jar
chmod 644 /opt/cloudera/csd/DRUID-5.8.0.jar
```

(re)install CSD

```
curl http://localhost:7180/cmf/csd/reinstall?csdName=DRUID-5.8.0
```
