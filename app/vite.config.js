import { fileURLToPath, URL } from 'node:url'

import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
import vueJsx from '@vitejs/plugin-vue-jsx'

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [
    vue(),
    vueJsx(),
  ],
  server: {
    proxy: {
      '/status': 'http://pillboxtest',
      '/lock': 'http://pillboxtest',
      '/unlock': 'http://pillboxtest',
      '/scheduleUnlock': 'http://pillboxtest',
      '/doDispense': 'http://pillboxtest',
      '/canUnlock': 'http://pillboxtest',
      '/doNextDay': 'http://pillboxtest',
      '/resetState': 'http://pillboxtest',
    }
  },
  resolve: {
    alias: {
      '@': fileURLToPath(new URL('./src', import.meta.url))
    }
  },
  build: {
    outDir: '../data'
  }
})
