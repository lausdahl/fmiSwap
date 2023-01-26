#!/bin/sh

echo Configuring extension
export MAESTRO_EXT_CP=$(ls -p /work/model/classpath/*.jar | tr '\n' ':')
echo "\t Extension cp $MAESTRO_EXT_CP"

echo "Generating Mabl specifications"

mkdir -p transition

maestro import sg1 ./FaultInject.mabl mm1.json simulation-config.json -fsp . -output stage1/

maestro import sg1 ./FaultInject.mabl mm2.json simulation-config.json -fsp . -output transition/stage2/


echo "Simulating specifications"

maestro  interpret stage1/spec.mabl ./FaultInject.mabl -tms 220 -transition transition -output stage1 2>&1 | tee out.txt
