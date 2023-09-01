<script setup>

import { computed, ref } from 'vue'

const props = defineProps(['isLocked'])

const wrapper = ref(null)

const wrapperWidth = computed(() => `${wrapper?.value?.clientWidth}px`);

</script>

<template>
  <div class="wrapper" ref="wrapper">
  <div class="padlock" :class="{ isLocked }">
    <div class="top"></div>
    <div class="middle"></div>
    <div class="bottom">
      <span class="left"></span>
      <span class="keyhole"></span>
      <span class="right"></span>
    </div>
  </div>
</div>
</template>

<style scoped>
.wrapper {
  width: 100%;
  height: 100%;
}
.padlock {
  --padlock-width: v-bind(wrapperWidth);
  --bar-rad-mult: 0.22;
  --bar-wid-mult: 0.11;
  --bottom-rad-mult: 0.08;
  width: var(--padlock-width);
  height: calc(var(--padlock-width)*1.2);
  padding: 0;
  margin: 0;
  box-sizing: border-box;
  display: flex;
  justify-content: center; 
  align-items: center; 
  flex-direction: column;
  
}

.padlock > .top {
  box-sizing: border-box;
  width: 60%;
  height: 40%;
  display: inline-block;
  border-radius: calc(var(--padlock-width)*var(--bar-rad-mult)) calc(var(--padlock-width)*var(--bar-rad-mult)) 0% 0%;
  border-color: #bdc3c7;
  border-width: calc(var(--padlock-width)*var(--bar-wid-mult))  calc(var(--padlock-width)*var(--bar-wid-mult)) 0  calc(var(--padlock-width)*var(--bar-wid-mult));
  border-style: solid;
  animation-name: unlock;
  animation-duration: 0.5s;
  animation-timing-function: cubic-bezier(0, 0, 0.46, 1.52);
  margin-bottom: 0%;
}
 
.padlock.isLocked > .top  {
  animation-name: lock;
  margin-bottom: -13%;
} 

@keyframes unlock {
  from {margin-bottom: -13%;}
  to {margin-bottom: 0%;}
}

@keyframes lock {
  from {margin-bottom: 0%;}
  to {margin-bottom: -13%;}
}

.padlock > .middle {
  box-sizing: border-box;
  width: 60%;
  height: 15%;
  margin-top: -5%;
  border-width: 0 calc(var(--padlock-width)*var(--bar-wid-mult)) 0 0 ;
  border-color: #bdc3c7;
  border-style: solid;
}


.padlock > .bottom {
  width: 80%;
  height: calc(var(--padlock-width)*0.5);
  position: relative;
}

.padlock > .bottom > span {
  display: inline-block;
}

.padlock > .bottom > .left {
  width: 50%;
  height: calc(var(--padlock-width)*0.5);
  background-color: #f1cf0f;
  border-radius: 0% 0% 0% calc(var(--padlock-width)*var(--bottom-rad-mult));
}

.padlock > .bottom > .right {
  width: 50%;
  height: calc(var(--padlock-width)*0.5);
  background-color: #f39c12;
  border-radius: 0% 0% calc(var(--padlock-width)*var(--bottom-rad-mult)) 0%;
}

.padlock > .bottom > .keyhole {
  width: calc(var(--padlock-width)*0.12);
  height: calc(var(--padlock-width)*0.12);
  background-color: black;
  border-radius: 100%;
  top: 30%;
  margin-left: calc(var(--padlock-width)*0.12/-2);
  position: absolute;
}

.padlock > .bottom > .keyhole::before {
  content: '';
  width: calc(var(--padlock-width)*0.05);
  height: 100%;
  left: calc(var(--padlock-width)*0.035);
  top: 70%;
  background-color: black;
  position: absolute;
}

</style>
