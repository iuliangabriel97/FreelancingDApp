let state = {
    web3: {
        isInjected: false,
        web3Instance: null,
        networkId: null,
        coinbase: null,
        balance: null,
        error: null
    },
    contractInstance: null,
    TokenContractInstance: null,
    authUser: null,
    requiresRegister: false,
    managerAuth: false,
    freelancerAuth: false,
    evaluatorAuth: false
}
export default state