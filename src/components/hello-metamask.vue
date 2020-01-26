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
      <p>Balance: {{ balance }} FMLTKN</p>
    </div>
    <b-jumbotron>
      <template v-slot:header>BootstrapVue</template>

      <template v-slot:lead>
        This is a simple hero unit, a simple jumbotron-style component for calling extra attention to
        featured content or information.
      </template>

      <hr class="my-4" />

      <p>
        It uses utility classes for typography and spacing to space content out within the larger
        container.
      </p>

      <div class="mt-3">
        <b-button-group>
          <b-button
            v-on:click="redirectToManagerPage"
            variant="success"
            size="lg"
          >Register as Manager</b-button>
          <b-button
            v-on:click="redirectToManagerPage"
            variant="info"
            size="lg"
          >Register as Freelancer</b-button>
          <b-button
            v-on:click="redirectToManagerPage"
            variant="warning"
            size="lg"
          >Register as Evaluator</b-button>
        </b-button-group>
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
    balance: state => state.web3.balance
  }),
  methods: {
    redirectToManagerPage: function(event) {
      this.$router.push("/manager");
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