<template>
  <div>
    <choose-task />
    <p>freelancer dashboard</p>
  </div>
</template>
<script>
import ChooseTask from "@/components/choose-task";
export default {
  name: "freelancer-dashboard",
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
  components: { "choose-task": ChooseTask }
};
</script>
<style scoped>
</style>

