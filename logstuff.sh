#!/bin/bash

while `true`; do 
  ds=`date -Idate`
  curl -sS -m 2 -w "\n" pillbox/status 2>&1 | tee -a log-${ds}.txt
  sleep 5
done