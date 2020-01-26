<template>
 <hello-metamask/>
</template>
<script>
import HelloMetamask from '@/components/hello-metamask'
export default {
 name: 'app',
 beforeCreate () {
    console.log('registerWeb3 Action dispatched from dapp.vue')
    this.$store.dispatch('registerWeb3')
  },
  mounted () {
 console.log('dispatching getContractInstance')
 this.$store.dispatch('getContractInstance')
 console.log('dipactching getTokenContractInstance')
 this.$store.dispatch('getTokenContractInstance')
 },
 components: {
 'hello-metamask': HelloMetamask
 }
}
</script>
<style scoped>
</style>