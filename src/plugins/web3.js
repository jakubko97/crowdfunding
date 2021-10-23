import Vue from 'vue'
import App from '../App.vue'

const Web3 = require('web3');
// web3 lib instance
let web3 = null
// Modern dapp browsers...
if (window.ethereum) {
    App.web3Provider = window.ethereum;
    try {
      // Request account access
      window.ethereum.enable();
    } catch (error) {
      // User denied account access...
      console.error("User denied account access")
    }
  }
  // Legacy dapp browsers...
  else if (window.web3) {
    App.web3Provider = window.web3.currentProvider;
  }
  // If no injected web3 instance is detected, fall back to Ganache
  else {
    App.web3Provider = new Web3.providers.HttpProvider('HTTP://127.0.0.1:7545');
  }
  web3 = new Web3(App.web3Provider);

export default web3

Vue.prototype.$web3 = web3