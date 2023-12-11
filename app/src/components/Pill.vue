<script setup>
import { computed, ref } from 'vue'
const props = defineProps(['pillsAvailable', 'pillsLeft']);

const wrapper = ref(null)
const wrapperWidth = computed(() => `${wrapper?.value?.clientWidth}px`);

const spin = ref(false);
const shake = computed(() => props.pillsAvailable >= 1 && !spin.value);

const pillsLeftElement = ref(null)
const pillsAvailableElement = ref(null)

function click() {
  if(props.pillsAvailable >= 1) {
    spin.value = true;
    fetch('/api/doDispense');
    setTimeout(() => spin.value = false, 1000);
  }
}

function updateAvailable(e) {
  e.target.blur();
  e.stopPropagation();
  e.preventDefault();
  const val = pillsAvailableElement.value.innerText.trim();

  fetch(`/api/setPillsAvailable/${Math.floor(val * 100)}`);
}

function updateLeft(e) {
  e.target.blur();
  e.stopPropagation();
  e.preventDefault();
  const val = pillsLeftElement.value.innerText.trim();
  fetch(`/api/setPillsLeft/${val}`);
}

</script>

<template>
  <div class="wrapper" ref="wrapper">
    <div 
      @click="click"
      class="pill"
      :class="{ spin, shake }"
    >
      <span></span>
      <span></span>
    </div>
    <div class="available" ref="pillsAvailableElement" contentEditable="true" inputmode=decimal @keydown.enter="updateAvailable"> 
      {{  props.pillsAvailable }}
    </div>
    <div class="left" ref="pillsLeftElement" contentEditable="true" inputmode=decimal @keydown.enter="updateLeft"> 
      {{  props.pillsLeft }}
    </div>
  </div>
</template>

<style scoped>
.wrapper {
  width: 100%;
  height: 100%;
  --wrapper-width: v-bind(wrapperWidth);
  --border-rad: 100%;
  position: relative;
}

.available, .left {
  position: absolute;
  font-size: 1.5em;
  margin: 0.25rem 0.5rem;
  border-radius: 0.75rem;
  background-color: #545463;
  padding: 0.5rem;
}

.available {
  bottom: 8%;
  left: 4%;
}

.left {
  top: 8%;
  right: 4%;
}

.pill {
  display: inline-block;
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%) rotate(45deg);
  white-space: nowrap;
}

.pill.spin {
  animation: spin;
  animation-duration: 1s;
}

@keyframes spin {
  from {transform: translate(-50%, -50%) rotate(45deg);}
  to {transform: translate(-50%, -50%) rotate(405deg);}
}

.pill.shake {
  animation: shake 4s cubic-bezier(.36,.07,.19,.97) both;
  animation-iteration-count: infinite;
}

@keyframes shake {
  2.5%, 22.5% {
    transform: translate(-50%, -50%) rotate(44deg);
  }
  
  5%, 20% {
    transform: translate(-50%, -50%) rotate(46deg); 
  }

  7.5%, 12.5%, 17.5% {
    transform: translate(-50%, -50%) rotate(41deg);
  }

  10%, 15% {
    transform: translate(-50%, -50%) rotate(49deg);
  }
} 

span {
  display: inline-block;
  width: calc(var(--wrapper-width)*0.5);
  height: calc(var(--wrapper-width)*0.45);
}

span:first-of-type {
  background-color: red;
  border-radius: var(--border-rad) 0px 0px var(--border-rad);
  overflow: hidden;
}

span:first-of-type:after {
  content: '';
  width: 100%;
  height: 45%;
  display: inline-block;
  background-color: #d00000;
}

span:last-of-type {
  background-color: blue;
  border-radius: 0px var(--border-rad) var(--border-rad) 0px;
  overflow: hidden;
}

span:last-of-type:after {
  content: '';
  width: 100%;
  height: 48%;
  display: inline-block;
  background-color: #0000d0;
}

</style>