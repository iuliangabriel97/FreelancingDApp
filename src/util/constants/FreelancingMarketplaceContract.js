const address = '0x0DCd2F752394c41875e259e00bb44fd505297caF'
const ABI = [
	{
		"constant": false,
		"inputs": [
			{
				"internalType": "uint256",
				"name": "taskId",
				"type": "uint256"
			}
		],
		"name": "fApplyForTask",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"internalType": "uint256",
				"name": "taskId",
				"type": "uint256"
			},
			{
				"internalType": "string",
				"name": "notificationMessage",
				"type": "string"
			}
		],
		"name": "fSetTaskComplete",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"internalType": "uint256",
				"name": "taskId",
				"type": "uint256"
			}
		],
		"name": "mAcceptTask",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"internalType": "uint256",
				"name": "taskId",
				"type": "uint256"
			},
			{
				"internalType": "address",
				"name": "freelancerAddress",
				"type": "address"
			}
		],
		"name": "mChooseFreelancer",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"internalType": "address",
				"name": "evaluatorAddress",
				"type": "address"
			},
			{
				"internalType": "string",
				"name": "title",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "description",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "domain",
				"type": "string"
			},
			{
				"internalType": "uint256",
				"name": "estResolveTime",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "estEvalTime",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "freelancerPay",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "evaluatorPay",
				"type": "uint256"
			}
		],
		"name": "mCreateTask",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"internalType": "uint256",
				"name": "taskId",
				"type": "uint256"
			}
		],
		"name": "mRequestEvaluation",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"internalType": "string",
				"name": "name",
				"type": "string"
			},
			{
				"internalType": "uint256",
				"name": "role",
				"type": "uint256"
			}
		],
		"name": "register",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "_tokenAddress",
				"type": "address"
			}
		],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "constructor"
	},
	{
		"payable": true,
		"stateMutability": "payable",
		"type": "fallback"
	},
	{
		"constant": true,
		"inputs": [
			{
				"internalType": "uint256",
				"name": "taskId",
				"type": "uint256"
			}
		],
		"name": "debug_getTask",
		"outputs": [
			{
				"components": [
					{
						"internalType": "uint256",
						"name": "id",
						"type": "uint256"
					},
					{
						"internalType": "address",
						"name": "managerAddress",
						"type": "address"
					},
					{
						"internalType": "address",
						"name": "freelancerAddress",
						"type": "address"
					},
					{
						"internalType": "address",
						"name": "evaluatorAddress",
						"type": "address"
					},
					{
						"internalType": "string",
						"name": "title",
						"type": "string"
					},
					{
						"internalType": "string",
						"name": "description",
						"type": "string"
					},
					{
						"internalType": "string",
						"name": "domain",
						"type": "string"
					},
					{
						"internalType": "enum FreelancingMarketplace.TaskStatus",
						"name": "status",
						"type": "uint8"
					},
					{
						"internalType": "address[]",
						"name": "applicants",
						"type": "address[]"
					},
					{
						"internalType": "string",
						"name": "notification",
						"type": "string"
					},
					{
						"internalType": "uint256",
						"name": "estimatedResolveTime",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "estimatedEvaluationTime",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "freelancerPayout",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "evaluatorPayout",
						"type": "uint256"
					}
				],
				"internalType": "struct FreelancingMarketplace.Task",
				"name": "task",
				"type": "tuple"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [],
		"name": "debug_myAllowance",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [],
		"name": "debug_myBalance",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [],
		"name": "debug_myRole",
		"outputs": [
			{
				"internalType": "enum FreelancingMarketplace.Role",
				"name": "",
				"type": "uint8"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [],
		"name": "fGetActiveTasksNumber",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [
			{
				"internalType": "uint256",
				"name": "taskIndex",
				"type": "uint256"
			}
		],
		"name": "fGetTaskByIndex",
		"outputs": [
			{
				"components": [
					{
						"internalType": "uint256",
						"name": "id",
						"type": "uint256"
					},
					{
						"internalType": "address",
						"name": "managerAddress",
						"type": "address"
					},
					{
						"internalType": "address",
						"name": "freelancerAddress",
						"type": "address"
					},
					{
						"internalType": "address",
						"name": "evaluatorAddress",
						"type": "address"
					},
					{
						"internalType": "string",
						"name": "title",
						"type": "string"
					},
					{
						"internalType": "string",
						"name": "description",
						"type": "string"
					},
					{
						"internalType": "string",
						"name": "domain",
						"type": "string"
					},
					{
						"internalType": "enum FreelancingMarketplace.TaskStatus",
						"name": "status",
						"type": "uint8"
					},
					{
						"internalType": "address[]",
						"name": "applicants",
						"type": "address[]"
					},
					{
						"internalType": "string",
						"name": "notification",
						"type": "string"
					},
					{
						"internalType": "uint256",
						"name": "estimatedResolveTime",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "estimatedEvaluationTime",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "freelancerPayout",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "evaluatorPayout",
						"type": "uint256"
					}
				],
				"internalType": "struct FreelancingMarketplace.Task",
				"name": "",
				"type": "tuple"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [],
		"name": "mGetActiveTasksNumber",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [
			{
				"internalType": "uint256",
				"name": "taskId",
				"type": "uint256"
			}
		],
		"name": "mGetTaskApplicants",
		"outputs": [
			{
				"internalType": "address[]",
				"name": "",
				"type": "address[]"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [
			{
				"internalType": "uint256",
				"name": "taskIndex",
				"type": "uint256"
			}
		],
		"name": "mGetTaskByIndex",
		"outputs": [
			{
				"components": [
					{
						"internalType": "uint256",
						"name": "id",
						"type": "uint256"
					},
					{
						"internalType": "address",
						"name": "managerAddress",
						"type": "address"
					},
					{
						"internalType": "address",
						"name": "freelancerAddress",
						"type": "address"
					},
					{
						"internalType": "address",
						"name": "evaluatorAddress",
						"type": "address"
					},
					{
						"internalType": "string",
						"name": "title",
						"type": "string"
					},
					{
						"internalType": "string",
						"name": "description",
						"type": "string"
					},
					{
						"internalType": "string",
						"name": "domain",
						"type": "string"
					},
					{
						"internalType": "enum FreelancingMarketplace.TaskStatus",
						"name": "status",
						"type": "uint8"
					},
					{
						"internalType": "address[]",
						"name": "applicants",
						"type": "address[]"
					},
					{
						"internalType": "string",
						"name": "notification",
						"type": "string"
					},
					{
						"internalType": "uint256",
						"name": "estimatedResolveTime",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "estimatedEvaluationTime",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "freelancerPayout",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "evaluatorPayout",
						"type": "uint256"
					}
				],
				"internalType": "struct FreelancingMarketplace.Task",
				"name": "",
				"type": "tuple"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	}
]
export {address, ABI}