<template>
  <div>
    <create-task />
  </div>
</template>
<script>

import CreateTask from "@/components/create-task";
import { mapState } from "vuex";
export default {
  name: "Manager",
  beforeCreate() {
    console.log("registerWeb3 Action dispatched from dapp.vue");
    this.$store.dispatch("registerWeb3");
  },
  mounted() {
    console.log("dispatching getContractInstance");
    this.$store.dispatch("getContractInstance");
    console.log("dipactching getTokenContractInstance");
    this.$store.dispatch("getTokenContractInstance");
  },
  components: { "create-task": CreateTask }
};
</script>
<style scoped>
</style>

