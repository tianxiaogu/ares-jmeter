#! /bin/bash

DIR=$(pushd "$(dirname "$BASH_SOURCE[0]")" > /dev/null && pwd && popd > /dev/null)

[ -z "$JMETER_HOME" ] && JMETER_HOME=${DIR}/../../binaries/apache-jmeter-2.8
[ -z "$JAVA" ] && echo "Using default java at $(which java)" && JAVA=$(which java)

$JAVA $VM_OPTS -jar ${JMETER_HOME}/bin/ApacheJMeter.jar -t ${DIR}/bug.jmx
