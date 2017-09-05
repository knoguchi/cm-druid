#!/bin/bash

SCRIPT_DIR=$(dirname "$0")

# Time marker for both stderr and stdout
date; date 1>&2

usage="Usage: contorl.sh nodeType (start|stop|status)"

if [ $# -le 1 ]; then
  echo $usage
  exit 1
fi

NODE_TYPE=$1
shift

CMD=$1

set -ex

function log {
  timestamp=$(date)
  echo "$timestamp: $1"       #stdout
  echo "$timestamp: $1" 1>&2; #stderr
}

# Time marker for both stderr and stdout
log "Running Druid CSD control script..."
log "Detected CDH_VERSION of [$CDH_VERSION]"


if [ -d "/usr/lib/jvm/java-8-oracle" ]; then
  log "Detected Oracle Java 8"
  export JAVA_HOME=/usr/lib/jvm/java-8-oracle
fi

# Set this to not source defaults
export BIGTOP_DEFAULTS_DIR=""

export HADOOP_HOME=${HADOOP_HOME:-$(readlink -m "$CDH_HADOOP_HOME")}
export HDFS_BIN=$HADOOP_HOME/../../bin/hdfs

USE_EMPTY_DEFAULT_FS=0
if [ -d "$CONF_DIR/yarn-conf" ]; then
  HADOOP_CONF_DIR="$CONF_DIR/yarn-conf"
elif [ -d "$CONF_DIR/hadoop-conf" ]; then
  HADOOP_CONF_DIR="$CONF_DIR/hadoop-conf"
else
  # No YARN nor HDFS, so create an empty directory just so that
  # the commands we run can work. On top of that, when reading
  # fs.defaultFS with an empty config, it contains a leading slash
  # which makes the final URL of the event log directory invalid,
  # so we override that with a default value.
  mkdir "$CONF_DIR/empty-hadoop-conf"
  HADOOP_CONF_DIR="$CONF_DIR/empty-hadoop-conf"
  USE_EMPTY_DEFAULT_FS=1
fi

# FIXME: CM copies core-site.xml and hdfs-site.xml only for unknown reasons.
# Druid needs mapred-site.xml and yarn-site.xml.
# For now set the HADOOP_CONF_DIR to point /etc/hadoop/conf/
HADOOP_CONF_DIR=/etc/hadoop/conf/

export HADOOP_CONF_DIR
export USE_EMPTY_DEFAULT_FS

# If DRUID_HOME is not set, make it the default
DEFAULT_DRUID_HOME=/opt/druid
export DRUID_HOME=${DRUID_HOME:-$DEFAULT_DRUID_HOME}

# We want to use a local conf dir
export DRUID_CONF_DIR="$CONF_DIR/conf"
if [ ! -d "$DRUID_CONF_DIR" ]; then
  mkdir "$DRUID_CONF_DIR"
fi

export DRUID_CONF_DIR="$CONF_DIR/conf"
if [ ! -d "$CONF_DIR/tmp" ]; then
  mkdir "$CONF_DIR/tmp"
fi


export DRUID_LIB_DIR=$DRUID_HOME/lib

perl -pi -e "s#{{DRUID_HOME}}#${DRUID_HOME}#" ${DRUID_CONF_DIR}/_common/common.runtime.properties

# convert log4j properties to log4j2 xml
python $SCRIPT_DIR/log4j_conv.py -i $CONF_DIR/log4j.properties -o $CONF_DIR/log4j2.xml

COMMON_JAVA_OPTS="-server -Djava.net.preferIPv4Stack=true -Duser.timezone=UTC -Dfile.encoding=UTF-8 -Djava.io.tmpdir=$CONF_DIR/tmp -Djava.util.logging.manager=org.apache.logging.log4j.jul.LogManager -Dlog4j.configurationFile=$CONF_DIR/log4j2.xml -XX:MaxPermSize=256m"


# Configure JAVA options for each type
case ${NODE_TYPE} in
    (overlord)
        DRUID_JAVA_OPTS="-Xmx${OVERLORD_HEAP_SIZE}M -XX:MaxDirectMemorySize=1280m"
        ;;
    (coordinator)
        DRUID_JAVA_OPTS="-Xmx${COORDINATOR_HEAP_SIZE}M -XX:MaxDirectMemorySize=1280m"
        ;;
    (middleManager)
        DRUID_JAVA_OPTS="-Xmx${MIDDLE_MANAGER_HEAP_SIZE}M -XX:MaxDirectMemorySize=1280m"
        ;;
    (historical)
        DRUID_JAVA_OPTS="-Xmx${HISTORICAL_HEAP_SIZE}M -XX:MaxDirectMemorySize=1280m"
        ;;
    (broker)
        DRUID_JAVA_OPTS="-Xmx${BROKER_HEAP_SIZE}M -XX:MaxDirectMemorySize=4096m"
        ;;
    (*)
        ;;
esac

DRUID_JAVA_OPTS="$DRUID_JAVA_OPTS $CSD_JAVA_OPTS $COMMON_JAVA_OPTS"

case ${CMD} in
    (start)
        echo $JAVA_HOME/bin/java $DRUID_JAVA_OPTS -cp $DRUID_PLUGIN_DIR:$HADOOP_CONF_DIR:$DRUID_CONF_DIR/_common:$DRUID_CONF_DIR/$NODE_TYPE:$DRUID_LIB_DIR/* io.druid.cli.Main server $NODE_TYPE
        exec $JAVA_HOME/bin/java $DRUID_JAVA_OPTS -cp $DRUID_PLUGIN_DIR:$HADOOP_CONF_DIR:$DRUID_CONF_DIR/_common:$DRUID_CONF_DIR/$NODE_TYPE:$DRUID_LIB_DIR/* io.druid.cli.Main server $NODE_TYPE
        ;;
    (*)
        echo "Unknown command ${CMD}"
        exit 1
        ;;
esac
