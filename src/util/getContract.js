import Web3 from 'web3'
import {address, ABI} from './constants/FreelancingMarketplaceContract'
let getContract = new Promise(function (resolve, reject) {
 let web3 = new Web3(window.web3.currentProvider)
 let FreelancingMarketplaceContract = web3.eth.contract(ABI)
 let FreelancingMarketplaceInstance = FreelancingMarketplaceContract.at(address)
 // casinoContractInstance = () => casinoContractInstance
 resolve(FreelancingMarketplaceInstance)
})
export default getContract