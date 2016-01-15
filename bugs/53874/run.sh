#! /bin/bash

DIR=$(pushd "$(dirname "$BASH_SOURCE[0]")" > /dev/null && pwd && popd > /dev/null)


COMMON_RUN=${DIR}/../run.sh

export JMETER_HOME=${DIR}/../../binaries/apache-jmeter-2.7/

JAVA=$ARES_BIN VM_OPTS=$VM_OPTS ${COMMON_RUN} -t ${DIR}/bug.jmx