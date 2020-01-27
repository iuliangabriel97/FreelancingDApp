import Vue from 'vue'
import Router from 'vue-router'
import Dapp from '@/components/dapp'
import ManagerDashboard from '@/components/manager-dashboard'
import FreelancerDashboard from '@/components/freelancer-dashboard'
import EvaluatorDashboard from '@/components/evaluator-dashboard'
import { mapState } from "vuex";
import { store } from '../store/'

Vue.use(Router)
const router = new Router({
    routes: [
        {
            path: '/',
            name: 'dapp',
            component: Dapp,
            meta: { requiresRegister: false }
        },
        {
            path: '/manager',
            name: 'manager-dashboard',
            component: ManagerDashboard,
            meta: { requiresRegister: true, managerAuth: true , name : null}
        },
        {
            path: '/freelancer',
            name: 'freelancer-dashboard',
            component: FreelancerDashboard,
            meta: { requiresRegister: true, freelancerAuth: true }
        },
        {
            path: '/evaluator',
            name: 'evaluator-dashboard',
            component: EvaluatorDashboard,
            meta: { requiresRegister: true, evaluatorAuth: true }
        }
    ]
})

router.beforeEach((to, from, next) => {
    console.log(to.meta.requiresRegister);
    console.log('store.state.authUser :' + store.state.authUser)
    if (to.meta.requiresRegister) {
        if (to.meta.managerAuth) {
            if (store.state.authUser === '0') {
                next('/manager')
            }
            else {
                console.log('Im in manager')
                next()
            }
        }
        else
            if (to.meta.freelancerAuth) {
                if (store.state.authUser === '1') {
                    next('/freelancer')
                } else {
                    console.log('Im in freelancer')
                    next()
                }
            }
            else
                if (to.meta.evaluatorAuth)
                    if (store.state.authUser === '2') {
                        next('/evaluator')
                    } else {
                        console.log('Im in evaluator')
                        next()
                    }

    }
    else {
        next();
    }
})

export default router;