<script setup>

import { ref } from 'vue'
import moment from 'moment'

const props = defineProps(['currentTime', 'currentUnlockDays', 'minimumUnlockTime'])
const emit = defineEmits(['closeMe'])

const unlockDays = ref(props.currentUnlockDays);
const unlockDate = ref();

if(props.currentUnlockDays) {
  gotNum();
}


function submit(e) {
  fetch(`/api/scheduleUnlock/${getUnlockMinutes()}`)
    .then(() => fetch('/api/lock'))
    .then(() => closeMe());
}

function gotDate(e) {
  const mmt = moment(props.currentTime);
  const unlockDate = moment(e.target.value);
  const days = unlockDate.diff(mmt, 'days') + 1;
  unlockDays.value = days;
}

function gotNum() {
  const mmt = moment(props.currentTime);
  const newUnlockDate = mmt.add(unlockDays.value, 'days');
  unlockDate.value = newUnlockDate.format('YYYY-MM-DD');
}

function getUnlockMinutes() {
  if(!unlockDays.value) {
    return 0;
  }

  const fullDaysMinutes = (unlockDays.value-1)*24*60;

  const mmt = moment(props.currentTime);
  const mmtNextMorning = mmt.clone().endOf('day').add(8, 'hours');
  const partialDaysMinutes = mmtNextMorning.diff(mmt, 'minutes');

  const totalMinutes = fullDaysMinutes+partialDaysMinutes;
  const unlockMinutes = (totalMinutes > props.minimumUnlockTime) ? totalMinutes : props.minimumUnlockTime;
  return unlockMinutes;
}

function closeMe() {
  emit('closeMe');
}

</script>

<template>
  <div>
    <div id="modal">
      <div>
        Lock for
        <input 
          type="number" 
          class="days"
          v-model="unlockDays"
          @keyup.enter="gotNum"
          @change="gotNum"
        >
        days
      </div>
      <div>
        Lock until
        <input 
          type="date"
          @change="gotDate"
          v-model="unlockDate"
        >
      </div>
      <div class="buttons">
        <span class="button check" @click="submit"></span>
        <span class="button x" @click="closeMe"></span>
      </div>
    </div>
  </div>
</template>

<style scoped>
#modal {
    margin-left:5%;
    margin-top:5%;
    width:90%;
    border-radius: 0.75rem;
    background-color: #545463;
    padding: 0.5rem;
    display: inline-block;
    box-sizing: border-box;
    line-height: 2rem;
}

input {
  background-color: #112639;
  color: white;
}

input.days {
  width: 2rem;
}

.buttons {
  margin-top: 0.75rem;
  margin-bottom: 0.75rem;
  display: flex;
  justify-content: space-around;
}

.button {
  display: inline-block;
  position: relative;
  border-radius: 100%;
  width: min(20vw, calc(400px*0.20));
  height: min(20vw, calc(400px*0.20));
}

.button:before, .button:after {
  content: "";
  display: inline-block;
  position: absolute;
  background-color: white;
}

.check {
  background-color:green;
  transform: rotate(-135deg);
}

.check:after {
  width: 40%;
  height: 15%;
  top:24%;
  left:33%;
}

.check:before {
  width: 15%;
  height: 60%;
  top:24%;
  left:33%;
}

.x {
  background-color:red;
  transform: rotate(45deg);
}

.x:after {
  width: 70%;
  height: 15%;
  top: 42.5%;
  left:15%;
}

.x:before {
  height: 70%;
  width: 15%;
  left: 42.5%;
  top:15%;
}

</style>
