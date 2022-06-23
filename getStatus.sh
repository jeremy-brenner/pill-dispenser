#!/bin/bash

if [ "x${1}x" != "xx" ]; then
  HOSTNAME="${1}"
else
  HOSTNAME="pillbox"
fi

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

dateStamp () {
  echo `date --date=@${1}`
}

STATUS=`curl -s ${HOSTNAME}/status`

if [ ! $STATUS ] ; then
  echo "ERROR"
  exit
fi

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
LOCAL_TIME=`date +%s`

READY_DATESTAMP=$(dateStamp $READY_TIME)
CURRENT_DATESTAMP=$(dateStamp $CURRENT_TIME) 
UNLOCK_DATESTAMP=$(dateStamp $UNLOCK_TIME)

SECONDS_TO_UNLOCK=$(( ${UNLOCK_TIME} - ${CURRENT_TIME} ))
if [ "${SECONDS_TO_UNLOCK}" -lt 0 ]; then
  SECONDS_TO_UNLOCK=0
fi


MINUTES_TO_UNLOCK=$(( ${SECONDS_TO_UNLOCK} / 60 ))
TIME_TO_UNLOCK="$(prettyTime $SECONDS_TO_UNLOCK)"
MININUM_SECONDS_TO_UNLOCK=$(( ${MINIMUM_UNLOCK_TIME} * 60 ))
MINIMUM_TIME_TO_UNLOCK="$(prettyTime $MININUM_SECONDS_TO_UNLOCK)"

MINIMUM_UNLOCK_TIMESTAMP=$(( ${MININUM_SECONDS_TO_UNLOCK} + ${CURRENT_TIME} ))
MINIMUM_UNLOCK_DATESTAMP=$(dateStamp $MINIMUM_UNLOCK_TIMESTAMP)

TIME_DIFF=$(( ${CURRENT_TIME} - ${LOCAL_TIME} ))
ALLOWED_DIFF=5

PFS="%-20s %-31s %10s %-20s\n"

if [ "${DEBUG}" -eq 1 ]; then
  echo "*** DEBUG IS ON ***"
fi

if [ ${TIME_DIFF} -gt ${ALLOWED_DIFF} -o ${TIME_DIFF} -lt -${ALLOWED_DIFF} ]; then
  echo "TIME MORE THAN ${ALLOWED_DIFF} SECONDS OFF!!!"
  printf "${PFS}" "LOCAL TIME:" "${LOCAL_TIME}"
  printf "${PFS}" "SYSTEM TIME:" "${CURRENT_TIME}"
  printf "${PFS}" "DIFFERENCE:" "${TIME_DIFF}"
fi

printf "${PFS}" "State:" "${STATE}"
printf "${PFS}" "Ready time:" "${READY_DATESTAMP}"
printf "${PFS}" "System time:" "${CURRENT_DATESTAMP}"
printf "${PFS}" "Time to unlock:" "${UNLOCK_DATESTAMP}" "${MINUTES_TO_UNLOCK}m" "(${TIME_TO_UNLOCK})"
printf "${PFS}" "Minimum Unlock Time:" "${MINIMUM_UNLOCK_DATESTAMP}" "${MINIMUM_UNLOCK_TIME}m" "(${MINIMUM_TIME_TO_UNLOCK})"


