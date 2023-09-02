<script setup>

import { ref } from 'vue'
import moment from 'moment'

const ready = ref(false);
const scheduling = ref(false);
const isLocked = ref();
const canUnlock = ref();
const unlockTime = ref();
const currentTime = ref();
const readyTime = ref();
const pillsAvailable = ref(0);
const minimumUnlockTime = ref();
const debug = ref();
const hostname = ref(location.hostname);

setInterval(() => fetch('/status')
  .then(response => response.json())
  .then(data => {
    isLocked.value = data.isLocked === "1";
    canUnlock.value = data.canUnlock === "1";
    unlockTime.value = data.unlockTime*1000;
    currentTime.value = data.currentTime*1000;
    readyTime.value = data.readyTime*1000;
    pillsAvailable.value = parseFloat(data.pillsAvailable);
    minimumUnlockTime.value = parseInt(data.minimumUnlockTime);
    debug.value = data.debug === "1"; 
    ready.value = true;
  })
  ,1000);

function dateFormat(time) {
  return moment(time).format('MMMM Do YYYY, h:mm:ss a')
}

function lockClick() {
  if(isLocked.value && canUnlock.value) {
    fetch('/unlock');
  } else {
    scheduling.value = true;
  }
}

function stopSchedulingUnlock() {
  scheduling.value = false;
}

</script>

<template>
  <main>
    <div id="icons">
      <span @click="lockClick">
        <PadLock :is-locked="isLocked" :can-unlock="canUnlock" :debug="debug"/>
      </span>
      <span>
        <Pill :pills-available="pillsAvailable"/>
      </span>
    </div>
    <UnlockScheduler 
      v-if="scheduling" 
      :current-time="currentTime" 
      :minimum-unlock-time="minimumUnlockTime"
      @close-me="stopSchedulingUnlock"
      class="item"
    />
    <div class="item">
      <span>
        {{ hostname }}
      </span>
      <span v-if="debug">
        -- DEBUG MODE
      </span>
    </div>
    <div class="item">
      System Time: {{ dateFormat(currentTime) }}
    </div>
    <div class="item" v-if="unlockTime > currentTime">
      Unlock Time: {{ dateFormat(unlockTime) }}  
    </div>
    <div class="item" v-if="unlockTime > currentTime">
      Unlocks {{ moment(unlockTime).from(currentTime) }}
    </div>  
    <div id="spinner" v-if="!ready">
      Loading...
    </div>
  </main>
</template>

<style scoped>
  main {
    display: flex;
    flex-direction: column;
    box-sizing: border-box;
    width: 100vw;
    height: 100vh;
    font-size:1rem;
    background-color: #222233;
    color: white;
    user-select: none;
  }

  main > #spinner {
    position: absolute;
    width: 100vw;
    height: 100vh;
    background-color: rgba(0,0,0,0.75);
    font-size: 2em;
    line-height: 100vh;
    text-align: center;
  }

  #icons {
    display: grid;
    grid-template-columns: 50% 50%;
  }

  #icons > span {
    position: relative;
  }

  main > .item {
    margin: 0.25rem 0.5rem;
    border-radius: 0.75rem;
    background-color: #545463;
    padding: 0.5rem;
  }

</style>
