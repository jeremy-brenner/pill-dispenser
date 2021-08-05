#!/bin/bash

while `true`; do 
  ds=`date -Idate`
  status=`curl pillbox/status 2>/dev/null`
  echo ${status} >> log-${ds}.txt
  echo ${status}
  sleep 5
done