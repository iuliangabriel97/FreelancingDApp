import Vue from 'vue'
import Vuex from 'vuex'
import state from './state'
import getWeb3 from '../util/getWeb3'
import pollWeb3 from '../util/pollWeb3'
import getContract from '../util/getContract'
import getTokenContract from '../util/getTokenContract'

Vue.use(Vuex)
export const store = new Vuex.Store({
  strict: true,
  state,
  mutations: {
    registerContractInstance(state, payload) {
      console.log('FreelancingMarketplace contract instance:', payload)
      state.contractInstance = () => payload
    },
    registerTokenContractInstance(state, payload) {
      console.log('Token contract instance:', payload)
      state.TokenContractInstance = () => payload
    },
    registerWeb3Instance(state, payload) {
      console.log('registerWeb3instance Mutation being executed', payload)
      let result = payload
      let web3Copy = state.web3
      web3Copy.coinbase = result.coinbase
      web3Copy.networkId = result.networkId
      web3Copy.balance = result.balance
      web3Copy.decimals = result.decimals
      web3Copy.isInjected = result.injectedWeb3
      web3Copy.web3Instance = result.web3
      state.web3 = web3Copy
      pollWeb3()
    },
    registerUserAuth(state, payload) {
      console.log('Payload: ' + payload)
      state.userAuth = payload;
    },
    pollWeb3Instance(state, payload) {
      //console.log('pollWeb3Instance mutation being executed', payload)
      state.web3.coinbase = payload.coinbase
      state.web3.balance = payload.balance
    }
  },
  actions: {
    getContractInstance({ commit }) {
      getContract.then(result => {
        commit('registerContractInstance', result)
      }).catch(e => console.log(e))
    },
    getUserRole({ commit }) {
      store.state.contractInstance().debug_myRole().then(result => {
        commit('registerUserAuth', result)
      }).catch(e => console.log(e));
    },
    getTokenContractInstance({ commit }) {
      getTokenContract.then(result => {
        commit('registerTokenContractInstance', result)
      }).catch(e => console.log(e))
    },
    registerWeb3({ commit }) {
      console.log('registerWeb3 Action being executed')
      getWeb3.then(result => {
        console.log('committing result to registerWeb3Instance mutation')
        commit('registerWeb3Instance', result)
      }).catch(e => {
        console.log('error in action registerWeb3', e)
      })
    },
    pollWeb3({ commit }, payload) {
      //console.log('pollWeb3 action being executed')
      commit('pollWeb3Instance', payload)
    }
  }
})