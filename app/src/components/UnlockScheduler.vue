<script setup>

import { ref } from 'vue'
import moment from 'moment'

const props = defineProps(['currentTime', 'minimumUnlockTime'])

const unlockDays = ref(1);

function submit(e) {
  const fullDaysMinutes = (unlockDays.value-1)*24*60;

  const mmt = moment(props.currentTime);
  const mmtNextMorning = mmt.clone().endOf('day').add(8, 'hours');
  const partialDaysMinutes = mmtNextMorning.diff(mmt, 'minutes');

  const totalMinutes = fullDaysMinutes+partialDaysMinutes;
  const unlockMinutes = (totalMinutes > props.minimumUnlockTime) ? totalMinutes : props.minimumUnlockTime;

  fetch(`/scheduleUnlock/${unlockMinutes}`)
    .then(() => fetch('/lock'));
  e.target.blur()
}

</script>

<template>
  <div>
    Lock for
    <input 
      type="number" 
      @keyup.enter="submit"
      v-model="unlockDays"
    >
    days
  </div>
</template>

<style scoped>

</style>
