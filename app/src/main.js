import './assets/reset.css'

import { createApp } from 'vue'
import App from './App.vue'
import PadLock from './components/PadLock.vue'
import UnlockScheduler from './components/UnlockScheduler.vue'


createApp(App)
  .component('PadLock', PadLock)
  .component('UnlockScheduler', UnlockScheduler)
  .mount('#app')
