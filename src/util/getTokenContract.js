import Web3 from 'web3'
import {address, ABI} from './constants/FMLTokenContract'
let getTokenContract = new Promise(function (resolve, reject) {
 let web3 = new Web3(window.web3.currentProvider)
 let TokenContract = web3.eth.contract(ABI)
 let TokenContractInstance = TokenContract.at(address)
 resolve(TokenContractInstance)
})
export default getTokenContract