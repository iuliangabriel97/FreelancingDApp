import Vue from 'vue'
import Router from 'vue-router'
import Dapp from '@/components/dapp'
Vue.use(Router)
export default new Router({
 routes: [
 {
 path: '/',
 name: 'dapp',
 component: Dapp
 }
 ]
})