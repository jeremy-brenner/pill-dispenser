<script setup>

import { ref, computed } from 'vue'
import moment from 'moment'

const debugEndpoints = ref([
  'doNextDay',
  'canUnlock',
  'resetState',
  'clearDebug',
  'clearSchedule',
  'dispensePill',
  'toggleLock',
  'reset',
]);
const ready = ref(false);
const scheduling = ref(false);
const isLocked = ref();
const canUnlock = ref();
const unlockTime = ref();
const currentTime = ref();
const readyTime = ref();
const pillsAvailable = ref(0);
const pillsLeft = ref(0);
const minimumUnlockTime = ref();
const currentUnlockDays = ref();
const debug = ref();
const lastMessageTime = ref(0);
const elapsed = ref(0);
const hostname = ref(location.hostname);
let ws;

startWebSocket();

setInterval( () => {
    const newElapsed = Date.now() - lastMessageTime.value;
    if(lastMessageTime.value > 0 && elapsed.value < 5000 && newElapsed > 5000 && ws.readyState == 1) {
      ws.close();
    }
    elapsed.value = newElapsed;
  },
  1000
);

const status = computed(() => {
  if(elapsed.value < 2000) {
    return 'ok';
  }
  if(elapsed.value < 5000) {
    return 'warn';
  }
  return 'bad';
});


function startWebSocket() {
  const wsPort = hostname.value == 'localhost' ? window.location.port : 81;

  ws = new WebSocket(`ws://${hostname.value}:${wsPort}/socket`);
  ws.onmessage = (e) => {
    if(e.data == 'Connected') {
      return;
    }
    setData(JSON.parse(e.data));
  }
  ws.onclose = (e) => {
    console.log('ws closed', e);
    startWebSocket();
  }
  ws.onerror = (e) => console.log('ws error', e); 
}


function setData(data) {
  ready.value = true;
  lastMessageTime.value = Date.now();
  isLocked.value = data.isLocked === "1";
  canUnlock.value = data.canUnlock === "1";
  unlockTime.value = data.unlockTime*1000;
  currentTime.value = data.currentTime*1000;
  readyTime.value = data.readyTime*1000;
  pillsAvailable.value = parseFloat(data.pillsAvailable);
  pillsLeft.value = parseInt(data.pillsLeft);
  minimumUnlockTime.value = parseInt(data.minimumUnlockTime);
  currentUnlockDays.value = unlockTime.value ? moment(unlockTime.value).diff(moment(currentTime.value), 'days') + 1 : null;
  debug.value = data.debug === "1"; 
}

function dateFormat(time) {
  return moment(time).format('MMMM Do YYYY, h:mm:ss a')
}

function lockClick() {
  if(isLocked.value && canUnlock.value) {
    fetch('/api/unlock');
  } else {
    scheduling.value = true;
  }
}

function stopSchedulingUnlock() {
  scheduling.value = false;
}

function callFetch(path) {
  fetch(`/api/${path}`);
}

</script>

<template>
  <main>
    <div id="icons">
      <span @click="lockClick">
        <PadLock :is-locked="isLocked" :can-unlock="canUnlock" :debug="debug"/>
      </span>
      <span>
        <Pill :pills-available="pillsAvailable" :pills-left="pillsLeft"/>
      </span>
    </div>
    <UnlockScheduler 
      v-if="scheduling" 
      :current-time="currentTime" 
      :current-unlock-days="currentUnlockDays" 
      :minimum-unlock-time="minimumUnlockTime"
      @close-me="stopSchedulingUnlock"
      class="full"
    />
    <div class="item">
      {{ hostname }} <span class="status" :class="status"></span>
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
    <div class="item debug" v-if="debug">
      DEBUG:
      <span v-for="endpoint in debugEndpoints" @click="callFetch(endpoint)">
        {{  endpoint }}
      </span>  
    </div>
    <div id="spinner" class="full" v-if="!ready">
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
    max-width: 400px;
    margin-left: auto;
    margin-right: auto;
    position: relative;
    overflow: hidden;
  }

  main > .full {
    position: absolute;
    width: 100vw;
    height: 100vh;
    background-color: rgba(0,0,0,0.75);
    max-width: 400px;
    margin-left: auto;
    margin-right: auto;
  }

  #spinner {
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

  .debug > span {
    display: inline-block;
    border-radius: 0.5rem;
    margin: 0.1rem;
    background-color: #4d1e1e;
    padding: 0.25rem;
  }

  main > .item {
    margin: 0.25rem 0.5rem;
    border-radius: 0.75rem;
    background-color: #545463;
    padding: 0.5rem;
  }

  .status {
    width: 0.75rem;
    height: 0.75rem;
    border-radius: 100%;
    display: inline-block;
    border: 1px solid #434355;
  }

  .ok {
    background-color: rgb(13, 94, 13); 
  }

  .warn {
    background-color: rgb(224, 157, 14);
  }

  .bad {
    background-color: rgb(173, 0, 0);
  }

</style>
