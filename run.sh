#!/bin/sh

echo "Processing..."

echo "\t loading model from /work/model"

ls /work/model


if test -f "/work/model/run.sh"; then
    echo "\t Found model run script at /work/model/run.sh"
    echo "\t Running model script /work/model/run.sh"
    cd /work/model
    sh run.sh

    if test -f "/work/model/post-process.sh"; then
       echo "\t Found model post-process script at /work/model/post-process.sh"
       echo "\t Running model script /work/model/post-process.sh"
       sh post-process.sh
      
    fi
fi

echo "Done"
