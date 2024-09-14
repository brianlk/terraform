#!/bin/sh

config=./development.config
#config=./staging.config
#config=./production.config

sh clean.sh
sh generateRootCert.sh $config
sh generateIntermediateCert.sh $config
#sh generateRadiusCert.sh
