#!/bin/bash

OPEN_HOUR=8

MIN=`date +%M`
HOUR=`date +%k`

MINUTES_TO_MIDNIGHT=$(( ( 24 - ${HOUR#0} ) * 60 - ${MIN#0} ))
MINUTES_TO_OPEN_HOUR=$(( OPEN_HOUR*60 + MINUTES_TO_MIDNIGHT ))
FULL_DAYS=$(( $1 - 1 ))
FULL_DAYS_IN_MINUTES=$(( FULL_DAYS*24*60 ))
MINUTES_TO_OPEN=$(( FULL_DAYS_IN_MINUTES + MINUTES_TO_OPEN_HOUR ))

echo Minutes to open: ${MINUTES_TO_OPEN}

curl pillbox/lock
curl pillbox/scheduleUnlock/${MINUTES_TO_OPEN}
