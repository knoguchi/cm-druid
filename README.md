Notice:  this repo is no longer maintained.  My employer moved away from both CDH and Druid.

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

Refersh the CM's parcels screen, and make sure DRUID appears in the list.
Then, click distribute, and activate.

If you are using one of extensions from "contributes", you'd have to manually run pull-deps
command at /opt/cloudera/pracels/DRUID.  This is a known limitation for now.


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

The Druid 0.10, the latest release, requires Java1.8. Java version for Hadoop must be upgraded as well in order for the Druid batch job to run.

- install oracle-java8
- set Java Home in the CM "Hosts" -> "Configurations" -> "Advanced".
- restart CDH services.

- checkout this repo
- rebuild the parcel
- upload the parcel
- distribute, activate it
- restart the Druid
