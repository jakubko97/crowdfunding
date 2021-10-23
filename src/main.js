import Vue from 'vue'
import App from './App.vue'
import vuetify from './plugins/vuetify'
import i18n from '@/plugins/i18n'

import '@/plugins'

Vue.config.productionTip = false

import web3 from './plugins/web3'

new Vue({
  vuetify,
  i18n,
  render: h => h(App, {props: { web3: web3 }})
}).$mount('#app')
