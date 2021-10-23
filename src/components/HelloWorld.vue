<template>
  <v-container>
    <v-row class="text-center">
      <v-col cols="12">
        <v-img
          :src="require('../assets/crowdfunding.png')"
          class="my-3"
          contain
          height="200"
        />
      </v-col>

      <v-col class="mb-4">
        <h1 class="display-2 font-weight-bold mb-3">
          Crowd Funding
        </h1>
      </v-col>
    </v-row>
      <v-row class="text-center">
      <v-col cols="12"
      md="4">
        <v-text-field
            v-model="amount"
            hint="Minimum is 2 ETH"
            label="Amount"
          ></v-text-field>
           <p>Deadline: {{ $utils.formatDate(deadline) }}</p>
          <p>Cieľová suma: {{ goal }} ETH</p>
           <p>Stav: {{ balance }} ETH</p>
    <p>
      Donated {{ pledgeOf }} ETH
    </p>
      </v-col>
      <v-col cols="12"
       md="4">
      <v-btn
      depressed
      color="primary"
      :loading="isLoading"
      @click="send()"
    >
      Send
    </v-btn>

      </v-col>
            <v-col cols="12" md="4">

          <v-btn
      depressed
      color="primary"
      @click="getRefund()"
    >
      Refund
    </v-btn>
    </v-col>
    <v-row>
      <v-col md="1">
        {{ balance }} ETH
      </v-col>
        <v-col md="10">
   <v-progress-linear height="12" :value="(balance / goal) * 100"></v-progress-linear>
      </v-col>
        <v-col md="1">
          {{ goal  }} ETH
      </v-col>
    </v-row>
    </v-row>
  </v-container>
</template>

<script>
import crowdfundInstance from '../../contracts/crowdFundingContract';

  export default {
    name: 'HelloWorld',
    data: () => ({
      account: null,
      amount: null,
      contract: crowdfundInstance,
      goal: null,
      balance: null,
      deadline: null,
      pledgeOf: null,
      isLoading: false,
      abi: null
    }),
     async mounted() {
    // this code snippet takes the account (wallet) that is currently active
      this.$web3.eth.getAccounts().then((accounts) => {
      [this.account] = accounts;

    });
        await this.contract.methods.deadline().call().then( value =>{
          const milliseconds = value + '000'
          this.deadline = new Date(+milliseconds)
        })
        this.update()
  },
    methods: {
      async update(){
         await this.contract.methods.goal().call().then( value =>{
          this.goal = parseFloat(this.$web3.utils.fromWei(value, 'ether')).toFixed(6)
        })

        await this.$web3.eth.getBalance(this.contract.options.address).then( value => {
          this.balance = parseFloat(this.$web3.utils.fromWei(value, 'ether')).toFixed(6)
        })

        await this.contract.methods.pledgeOf(this.account).call().then( value =>{
          this.pledgeOf = parseFloat(this.$web3.utils.fromWei(value, 'ether')).toFixed(6)
        })
      },
      send() {
        if(this.amount != null){
          this.isLoading = true;
          let val = this.$web3.utils.toWei(this.amount, 'ether')
           this.contract.methods.contribute(this.contract.options.address, val).send(
             {
             from: this.account,
             to: this.contract.options.address,
             value: val,
             }
            ).then(() => {
              this.update()
              this.isLoading = false;
            }
            ).catch(() => {
              this.isLoading = false;
            });
        }
      },
     getRefund() {
       this.contract.methods.getRefund().send({
         from: this.account
       })
      }
    }
  }
</script>
