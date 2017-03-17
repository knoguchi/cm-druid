# Druid for Cloudera CDH

- Create CDH parcels from Druid distribution.
- Create Druid services descriptor

# Build

Run make at the top directory.  The parcels and CSD will be created at dist/parcels and dist/csd.

```
make clean install
```

# Parcels Installation

Copy dist/parcels/* to /opt/cloudera/parcel-repo

```
cp dist/parcels/DRUID-0.9.2-0.0.3-el6.parcel /opt/cloudera/parcel-repo
cp dist/parcels/DRUID-0.9.2-0.0.3-el6.parcel.sha /opt/cloudera/parcel-repo
cp dist/manifest.json /opt/cloudera/parcel-repo
chown cloudera-scm:cloudera-scm /opt/cloudera/parcel-repo/*
```

Refersh parcel screen and make sure DRUID appears in the list.
Ddistribute, and activate.


# CSD Installation

Copy CSD jar file to /opt/cloudera/csd.

```
cp dist/csd/DRUID-5.8.0.jar /opt/cloudera/csd
chown cloudera-scm:cloudera-scm /opt/cloudera/csd/DRUID-5.8.0.jar
chmod 644 /opt/cloudera/csd/DRUID-5.8.0.jar
```

Install CSD

```
curl http://localhost:7180/cmf/csd/refresh
curl http://localhost:7180/cmf/csd/install?csdName=DRUID-5.8.0
```

Reinstall CSD

```
curl http://localhost:7180/cmf/csd/reinstall?csdName=DRUID-5.8.0
```