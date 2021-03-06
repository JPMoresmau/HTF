#!/bin/bash

compilers=$(gawk -F == '/GHC==/ {print $2}' HTF.cabal  | tr -d ,)

for x in $compilers
do
    switch-ghc $x > /dev/null
    ghc_version=$(ghc --version | sed -E 's/.*version ([.0-9]*)/\1/g')
    if [ "$x" != "$ghc_version" ]
    then
        echo "Could not switch to GHC version $x as requested, version is now $ghc_version"
        exit 1
    fi
    echo
    echo
    echo "============================================================"
    echo "============================================================"
    echo "==> Running tests for GHC version $ghc_version <=="
    echo "==> Running tests for GHC version $ghc_version <=="
    echo "==> Running tests for GHC version $ghc_version <=="
    echo "============================================================"
    echo "============================================================"
    echo
    ./run-all-tests.sh
    ecode=$?
    if [ $ecode -eq 0 ]
    then
        result="ok"
    else
        result="FAIL"
    fi
    RESULT="$RESULT\nResult for GHC version $ghc_version: $result"
    if [ $ecode -ne 0 ]
    then
        exit 1
    fi
done

echo
echo -e $RESULT
