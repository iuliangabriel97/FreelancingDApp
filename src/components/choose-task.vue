<template>
  <div>
    <div>
      <b-list-group>
        <b-list-group-item button>Task 1</b-list-group-item>
        <b-list-group-item button>Task 2</b-list-group-item>
        <b-list-group-item button>Task 3</b-list-group-item>
      </b-list-group>
    </div>
  </div>
</template>


<script>
import { NETWORKS } from "../util/constants/networks";
import { mapState } from "vuex";
export default {
  data() {
    return {
      selected: "first",
      options: [
        { text: "Toggle this custom radio", value: "first" },
        { text: "Or toggle this other custom radio", value: "second" },
        { text: "This one is Disabled", value: "third", disabled: true },
        { text: "This is the 4th radio", value: { fourth: 4 } }
      ]
    };
  },
  name: "create-task",
  computed: mapState({
    isInjected: state => state.web3.isInjected,
    network: state => NETWORKS[state.web3.networkId],
    coinbase: state => state.web3.coinbase,
    balance: state => state.web3.balance
  })
};
</script>

<style scoped>
</style>