<script setup>

import { computed } from 'vue'
import padlockOpen from '../assets/padlock_open.png?url'
import padlockClosed from '../assets/padlock_closed.png?url'

const props = defineProps(['isLocked', 'debug'])

const imgUrl = computed(() => {
  return props.isLocked ? padlockClosed : padlockOpen;
});

function click() {
  if(props.debug) {
    fetch(props.isLocked ? '/unlock' : '/lock');
  }
}


</script>

<template>
  <div 
    id="padlockImage"
    @click="click"
    v-bind:style="{ 'background-image': 'url(' + imgUrl + ')'  }" 
  >
  </div>
</template>

<style scoped>
  #padlockImage {
    width:100%;
    height:100%;
    background-size: cover;
  }
</style>
