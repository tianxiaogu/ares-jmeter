#! /bin/bash

DIR=$(pushd "$(dirname "$BASH_SOURCE[0]")" > /dev/null && pwd && popd > /dev/null)

BUG_RUN=$1

if [[ ! -x ${BUG_RUN} ]] ; then
    echo "Bug run.sh [$BUG_RUN] is not executable!"
    exit 1
fi

BUG_RUN=`dirname $BUG_RUN`/`basename $BUG_RUN`

echo "Run Stack-based Error Transformation"
JAVA=$ARES_BIN VM_OPTS=$SBET $BUG_RUN $*

echo "Run Force-Throwable Error Transformation"
JAVA=$ARES_BIN VM_OPTS=$FTET $BUG_RUN $*

echo "Run First Early Return"
JAVA=$ARES_BIN VM_OPTS=$FER $BUG_RUN $*

echo "Run Void-Only Early Return"
JAVA=$ARES_BIN VM_OPTS=$VOER $BUG_RUN $*

