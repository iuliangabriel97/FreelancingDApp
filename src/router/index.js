import Vue from 'vue'
import Router from 'vue-router'
import Dapp from '@/components/dapp'
import ManagerDashboard from '@/components/manager-dashboard'
Vue.use(Router)
export default new Router({
    routes: [
        {
            path: '/',
            name: 'dapp',
            component: Dapp
        },
        {
            path: '/manager',
            name: 'manager-dashboard',
            component: ManagerDashboard
        },
        {
            path: '/freelancer',
            name: 'freelancer-dashboard',
            component: ManagerDashboard
        },
        {
            path: '/evaluator',
            name: 'evaluator-dashboard',
            component: ManagerDashboard
        }
    ]
})