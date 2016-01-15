#! /bin/bash

DIR=$(pushd "$(dirname "$BASH_SOURCE[0]")" > /dev/null && pwd && popd > /dev/null)

if [[ "x$JMETER_HOME" == "x" ]] ; then
    JMETER_HOME=${DIR}/../binaries/jakarta-jmeter-2.1.1
fi

if [[ "x$JAVA" == "x" ]];
then
    echo "Using default java at $(which java)"
    JAVA=$(which java)
fi

$JAVA $VM_OPTS -jar ${JMETER_HOME}/bin/ApacheJMeter.jar $*
