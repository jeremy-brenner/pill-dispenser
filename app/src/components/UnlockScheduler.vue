<script setup>

import { ref, onMounted} from 'vue'
import moment from 'moment'

const props = defineProps(['currentTime', 'minimumUnlockTime'])
const emit = defineEmits(['closeMe'])

const unlockDays = ref();
const input = ref(null);

function submit(e) {
  fetch(`/scheduleUnlock/${getUnlockMinutes()}`)
    .then(() => fetch('/lock'));
  e.target.blur();  
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

onMounted(() => {
  input?.value?.focus();
})

</script>

<template>
  <div>
    Lock for
    <input 
      type="number" 
      @keyup.enter="submit"
      @blur="closeMe"
      v-model="unlockDays"
      ref="input"
    >
    days
  </div>
</template>

<style scoped>
input {
  background-color: #112639;
  color: white;
  width: 2rem;
}
</style>
