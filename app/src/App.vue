<script setup>

import { ref } from 'vue'
import moment from 'moment'

const ready = ref(false);
const isLocked = ref();
const unlockTime = ref();
const currentTime = ref();
const readyTime = ref();
const minimumUnlockTime = ref();
const debug = ref();

setInterval(() => fetch('/status')
  .then(response => response.json())
  .then(data => {
    isLocked.value = data.isLocked === "1";

    unlockTime.value = data.unlockTime*1000;
    currentTime.value = data.currentTime*1000;
    readyTime.value = data.readyTime*1000;

    minimumUnlockTime.value = parseInt(data.minimumUnlockTime);
    debug.value = data.debug === "1"; 
    ready.value = true;
  })
  ,1000);

  function dateFormat(time) {
    return moment(time).format('MMMM Do YYYY, h:mm:ss a')
  }

</script>

<template>
  <main v-if="ready" :class="{ debug: debug }">
    <div id="lock">
      <PadLock :is-locked="isLocked" :debug="debug"/>
    </div>
    <UnlockScheduler :current-time="currentTime" :minimum-unlock-time="minimumUnlockTime"/>
    <div>
      System Time: {{ dateFormat(currentTime) }}
    </div>
    <div v-if="unlockTime > currentTime">
      Unlock Time: {{ dateFormat(unlockTime) }}  
    </div>
    <div v-if="unlockTime > currentTime">
      Unlocks {{ moment(unlockTime).from(currentTime) }}
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
  }
  #lock {
    margin: 5vw 10vw 5vw 10vw;
    width: 80vw;
    height: 87.5vw;
  }
  main > div {
    margin: 0.25rem 0.5rem;
  }

  main.debug {
    border: 0.5rem solid red;
  }

</style>
