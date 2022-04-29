#!/bin/bash


prettyTime () {
  SECONDS=$(( $1%60 ))
  MINUTES=$(( $1/60%60 ))
  HOURS=$(( $1/3600%24 ))
  DAYS=$(( $1/3600/24 ))
  echo "${DAYS}d ${HOURS}h ${MINUTES}m ${SECONDS}s"
}

statusField () {
  echo ${STATUS} | jq -r ".${1}"
}

STATUS=`curl -s pillbox/status`

IS_LOCKED=$(statusField 'isLocked')

if [ "${IS_LOCKED}" -eq 1 ] ; then
  STATE="LOCKED"
else 
  STATE="UNLOCKED"
fi

READY_TIME=$(statusField 'readyTime')
MINIMUM_UNLOCK_TIME=$(statusField 'minimumUnlockTime')
DEBUG=$(statusField 'debug')


UNLOCK_TIME=$(statusField 'unlockTime')
CURRENT_TIME=$(statusField 'currentTime')

SECONDS_TO_UNLOCK=$(( ${UNLOCK_TIME} - ${CURRENT_TIME} ))
if [ "${SECONDS_TO_UNLOCK}" -lt 0 ]; then
  SECONDS_TO_UNLOCK=0
fi

MINUTES_TO_UNLOCK=$(( ${SECONDS_TO_UNLOCK} / 60 ))
TIME_TO_UNLOCK="$(prettyTime $SECONDS_TO_UNLOCK)"
MININUM_SECONDS_TO_UNLOCK=$(( ${MINIMUM_UNLOCK_TIME} * 60 ))

if [ "${DEBUG}" -eq 1 ]; then
  echo "*** DEBUG IS ON ***"
fi

echo "State: ${STATE}"
echo "Time to unlock: ${MINUTES_TO_UNLOCK}m (${TIME_TO_UNLOCK})"
echo "Minimum Unlock Time: ${MINIMUM_UNLOCK_TIME}m ($(prettyTime $MININUM_SECONDS_TO_UNLOCK))"
