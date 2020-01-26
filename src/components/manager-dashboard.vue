<template>
  <p>manager dashboard</p>
</template>
<script>
export default {
  name: "manager-dashboard",
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
  components: {}
};
</script>
<style scoped>
</style>

