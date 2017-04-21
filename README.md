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
cp dist/parcels/DRUID-0.10.0-0.0.4-el6.parcel /opt/cloudera/parcel-repo
cp dist/parcels/DRUID-0.10.0-0.0.4-el6.parcel.sha /opt/cloudera/parcel-repo
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

# Upgrade Druid

In order to upgrade Druid from 0.9.2...
- checkout this repo
- rebuild the parcel
- upload the parcel
- distribute, activate it
- restart the Druid

Please note, Druid 0.10.0 requires Java1.8.  Please upgrade Java for CM, agent and the services if not 1.8.
The Druid batch job runs in Hadoop.  The batch job would fail if the Java for the Hadoop is not 1.8.