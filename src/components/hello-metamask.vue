<template>
  <div>
    <nav class="navbar navbar-dark bg-dark">
      <a class="navbar-brand">Freelancing Marketplace</a>
      <form class="form">
        <b-button
          class="btn btn-sm btn-danger"
          type="button"
          v-on:click="redirectToDashboard('manager')"
        >Manager Dashboard</b-button>
        <b-button
          class="btn btn-sm btn-success"
          type="button"
          v-on:click="redirectToDashboard('freelancer')"
        >Freelancer Dashboard</b-button>
        <b-button
          class="btn btn-sm btn-info"
          type="button"
          v-on:click="redirectToDashboard('evaluator')"
        >Evaluator Dashboard</b-button>
      </form>
    </nav>
    <div class="metamask-info">
      <p v-if="isInjected" id="has-metamask" class="metamask-status">
        <i aria-hidden="true" class="fa fa-check"></i> Metamask installed
      </p>
      <p v-else id="no-metamask">
        <i aria-hidden="true" class="fa fa-times"></i> Metamask not found
      </p>
      <p>Network: {{ network }}</p>
      <p>Account: {{ coinbase }}</p>
      <p>Balance: {{ balance / (10**decimals) }} FMLTKN [{{decimals}} dec]</p>
    </div>
    <b-jumbotron>
      <template v-slot:header>Freelancing Marketplace</template>

      <template v-slot:lead>Using Ropsten Test Network</template>

      <hr class="my-4" />

      <p></p>

      <div class="mt-3">
        <b-button-group>
          <b-button
            v-on:click="registerAsManager(username)"
            variant="danger"
            size="lg"
          >Register as Manager</b-button>
          <b-button
            v-on:click="registerAsFreelancer(username)"
            variant="success"
            size="lg"
          >Register as Freelancer</b-button>
          <b-button
            v-on:click="registerAsEvaluator(username)"
            variant="info"
            size="lg"
          >Register as Evaluator</b-button>
        </b-button-group>
        <div class="mt-2">
          <b-form-input v-model="username" placeholder="Enter your name"></b-form-input>
        </div>
        <hr />
        <div id="txnotification"></div>
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
  data: function() {
    return {
      count: ""
    };
  },
  methods: {
    registerAsManager: function(username) {
      console.log("register as manager: " + username);
      console.log(this.$store.state.contractInstance());
      this.$store.state
        .contractInstance()
        .register(username, 0, function(err, res) {
          console.log(err, res);
          if (err == null) {
            document.getElementById("txnotification").innerHTML =
              "Transaction available at <a href='https://ropsten.etherscan.io/tx/" +
              res
            +"'>https://ropsten.etherscan.io/tx/" + res + "</a>";
          } else {
            document.getElementById("txnotification").innerText =
              "Error: " + err.message;
          }
        });
      document.getElementById;
      //this.$router.push({ path: "/manager" });
    },
    registerAsFreelancer: function(username) {
      console.log("register as freelancer: " + username);
      console.log(this.$store.state.contractInstance());
      this.$store.state
        .contractInstance()
        .register(username, 1, function(err, res) {
          console.log(err, res);
          if (err == null) {
            document.getElementById("txnotification").innerHTML =
              "Transaction available at <a href='https://ropsten.etherscan.io/tx/" +
              res
            +"'>https://ropsten.etherscan.io/tx/" + res + "</a>";
          } else {
            document.getElementById("txnotification").innerText =
              "Error: " + err.message;
          }
        });
      //this.$router.push({ path: "/evaluator" });
    },
    registerAsEvaluator: function(username) {
      console.log("register as evaluator: " + username);
      console.log(this.$store.state.contractInstance());
      this.$store.state
        .contractInstance()
        .register(username, 2, function(err, res) {
          console.log(err, res);
          if (err == null) {
            document.getElementById("txnotification").innerHTML =
              "Transaction available at <a href='https://ropsten.etherscan.io/tx/" +
              res
            +"'>https://ropsten.etherscan.io/tx/" + res + "</a>";
          } else {
            document.getElementById("txnotification").innerText =
              "Error: " + err.message;
          }
        });
    },
    redirectToDashboard: function(dashboard) {
      this.$router.push({ path: "/" + dashboard });
    },
    test: function() {
      console.log("Test");
      
    }
  }
};
</script>

<style scoped>
.metamask-info p {
  font-family: monospace;
  margin: 0;
}

.metamask-info {
  margin: 8px;
  padding: 8px;
  border: solid 1px lightgray;
  text-align: left;
}
#has-metamask {
  color: green;
}
#no-metamask {
  color: red;
}

.metamask-status {
  font-weight: bold;
}
</style>