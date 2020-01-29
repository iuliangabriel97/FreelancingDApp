<template>
  <div class="metamask-info">
    <div>
      <p v-if="isInjected" id="has-metamask">
        <i aria-hidden="true" class="fa fa-check"></i> Metamask installed
      </p>
      <p v-else id="no-metamask">
        <i aria-hidden="true" class="fa fa-times"></i> Metamask not found
      </p>
      <p>Network: {{ network }}</p>
      <p>Account: {{ coinbase }}</p>
      <p>Balance: {{ balance / (10**decimals) }} FMLTKN</p>
    </div>
    <b-jumbotron>
      <template v-slot:header>Freelancing Marketplace</template>

      <template v-slot:lead>Using Ropsten Test Network</template>

      <hr class="my-4" />

      <p></p>

      <div class="mt-3">
        <b-button-group>
          <b-button
            v-on:click="redirectToManagerPage"
            variant="success"
            size="lg"
          >Register as Manager</b-button>
          <b-button
            v-on:click="redirectToFreelancerPage"
            variant="info"
            size="lg"
          >Register as Freelancer</b-button>
          <b-button
            v-on:click="redirectToEvaluatorPage"
            variant="warning"
            size="lg"
          >Register as Evaluator</b-button>
        </b-button-group>

        <div class="mt-2">
          <b-form-input placeholder="Enter your name"></b-form-input> <!-- v-model="username"-->
        </div>
      </div>
    </b-jumbotron>
  </div>
</template>


<script>
import { NETWORKS } from "../util/constants/networks";
import { mapState } from "vuex";
export default {
  name: "hello-metamask",
  computed: mapState({
    isInjected: state => state.web3.isInjected,
    network: state => NETWORKS[state.web3.networkId],
    coinbase: state => state.web3.coinbase,
    balance: state => state.web3.balance,
    decimals: state => state.web3.decimals
  }),
  methods: {
    redirectToManagerPage: function(event) {
      this.$router.push({ path: "/manager" });
      this.$store.contractInstance.register(username, function(err, res) {
        console.log(err, res);
      });
    },
    redirectToFreelancerPage: function(event) {
      this.$router.push("/freelancer");
    },
    redirectToEvaluatorPage: function(event) {
      this.$router.push("/evaluator");
    }
  }
};
</script>

<style scoped>
.metamask-info {
  text-align: center;
}
#has-metamask {
  color: green;
}
#no-metamask {
  color: red;
}
</style>