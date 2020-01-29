pragma solidity ^0.5.0;
pragma experimental ABIEncoderV2;

import "FMLTKN.sol";

contract FreelancingMarketplace
{
// ---------- Enums ----------

    enum Role {
        Manager,
        Freelancer,
        Evaluator
    }

    enum TaskStatus {
        WaitingApplications, // dupa creare se asteapta aplicari de la freelanceri
        Working, // dupa ce se alege un freelancer
        Complete, // dupa ce freelancer-ul trimite notificarea catre manager
        WaitingEvaluation, // daca managerul cere evaluare
        Finished // dupa ce managerul da all ok (de la Complete) sau dupa ce evaluatorul da verdict (de la WaitingEvaluation)
    }

// ---------- Structs ----------

    struct User {
        address userAddress;
        string name;
        int256 reputation;
        Role role;
    }

    struct Task{
        uint id;

        address managerAddress;
        address freelancerAddress;
        address evaluatorAddress;

        string title;
        string description;
        string domain;

        TaskStatus status;
        address[] applicants;
        string notification;

        uint estimatedResolveTime;
        uint estimatedEvaluationTime;

        uint freelancerPayout;
        uint evaluatorPayout;
    }

// ---------- Modifiers ----------

    modifier onlyBy(address _account) {
        require(msg.sender == _account,
        "Sender not authorized");
        _;
    }

// ---------- Member variables ----------

    address owner;
    address tokenAddress;

    Token token;

    mapping(address => User) users;
    address[] private userList;

    uint taskIdCounter = 0;

    Task[] activeTasks;
    Task[] inactiveTasks;

// ---------- Constructor ----------

constructor(address _tokenAddress) public {

        owner = msg.sender;
        tokenAddress = _tokenAddress;

        token = Token(tokenAddress);
    }

// ---------- Internal functions  ----------

    function addUser(address userAddress, string memory name, uint role) internal {
        require(role >= 0 && role <= 2, 'Unknown role');
        require(users[userAddress].userAddress == address(0), 'User already exists');
        users[userAddress] = User(userAddress, name, 5, Role(role));
        userList.push(userAddress);
    }

    function getUser(address userAddress) internal view  returns (User memory user) {
        return (users[userAddress]);
    }

    function getTaskId() internal returns (uint) {
        return taskIdCounter++;
    }

    function addTask(
        address managerAddress,
        address evaluatorAddress,
        string memory title,
        string memory description,
        string memory domain,
        uint estResolveTime,
        uint estEvalTime,
        uint freelancerPay,
        uint evaluatorPay
        ) internal {
            require(users[managerAddress].userAddress != address(0), 'User does not exist');
            require(users[managerAddress].role == Role.Manager, 'User is not a manager');
            require(users[evaluatorAddress].userAddress != address(0), 'Evaluator user does not exist');
            require(users[evaluatorAddress].role == Role.Evaluator, 'Evaluator user is not an evaluator');

            Task memory newTask;

            newTask.id = getTaskId();
            newTask.managerAddress = managerAddress;
            newTask.freelancerAddress = address(0);
            newTask.evaluatorAddress = evaluatorAddress;

            newTask.title = title;
            newTask.description = description;
            newTask.domain = domain;

            newTask.status = TaskStatus.WaitingApplications;
            newTask.notification = "";

            newTask.estimatedResolveTime = estResolveTime;
            newTask.estimatedEvaluationTime = estEvalTime;
            newTask.freelancerPayout = freelancerPay;
            newTask.evaluatorPayout = evaluatorPay;

            activeTasks.push(newTask);
        }

    function getTask(uint taskId) internal view returns (Task memory task) {
        require(taskId < activeTasks.length + inactiveTasks.length, 'Task ID out of bounds');
        for (uint i = 0; i < activeTasks.length; i++) {
            if (activeTasks[i].id == taskId) {
                return (activeTasks[i]);
            }
        }
        for (uint i = 0; i < inactiveTasks.length; i++) {
            if (inactiveTasks[i].id == taskId) {
                return (inactiveTasks[i]);
            }
        }
        revert('Task not found');
    }

    function getActiveTaskIndex(uint taskId) internal view returns (uint) {
        require(taskId < activeTasks.length + inactiveTasks.length, 'Task ID out of bounds');
        for (uint i = 0; i < activeTasks.length; i++) {
            if (activeTasks[i].id == taskId) {
                return (i);
            }
        }
        revert('Task not found');
    }

    function userAppliedToTask(address user, uint taskId) public view returns (bool) {
        uint taskIndex = getActiveTaskIndex(taskId);
        for (uint i = 0; i < activeTasks[taskIndex].applicants.length; i++) {
            if (activeTasks[taskIndex].applicants[i] == user) {
                return true;
            }
        }
        return false;
    }

// ---------- External functions  ----------

    // debug

    function debug_myBalance() public view returns (uint) {
        return token.balanceOf(msg.sender);
    }

    function debug_myAllowance() public view returns (uint) {
        return token.allowance(msg.sender, address(this));
    }

    function debug_myRole() public view returns (Role) {
        return users[msg.sender].role;
    }

    function debug_getTask(uint taskId) public view returns (Task memory task) {
        require(taskId < activeTasks.length + inactiveTasks.length, 'Task ID out of bounds');
        for (uint i = 0; i < activeTasks.length; i++) {
            if (activeTasks[i].id == taskId) {
                return (activeTasks[i]);
            }
        }
        for (uint i = 0; i < inactiveTasks.length; i++) {
            if (inactiveTasks[i].id == taskId) {
                return (inactiveTasks[i]);
            }
        }
        revert('Task not found');
    }

    // all users

    function register(string memory name, uint role) public {
        addUser(msg.sender, name, role);
    }

    function getActiveTaskById(uint taskId) public view returns (Task memory) {
        uint taskIndex = getActiveTaskIndex(taskId);
        return activeTasks[taskIndex];
    }

    // manager

    // CALL APPROVE as MANAGER for totalAmount
    function mCreateTask(
        address evaluatorAddress,
        string memory title,
        string memory description,
        string memory domain,
        uint estResolveTime,
        uint estEvalTime,
        uint freelancerPay,
        uint evaluatorPay
    ) public {
        require(users[msg.sender].role == Role.Manager, 'Operation can only be performed by a manager');
        require(users[evaluatorAddress].role == Role.Evaluator, 'Chosen evaluator does not have evaluator role');
        uint totalAmount = freelancerPay + evaluatorPay;
        require(token.balanceOf(msg.sender) > totalAmount, 'Insufficient funds');
        token.transferFrom(msg.sender, address(this), totalAmount);
        addTask(
            msg.sender,
            evaluatorAddress,
            title,
            description,
            domain,
            estResolveTime,
            estEvalTime,
            freelancerPay,
            evaluatorPay
        );
    }

    function mGetActiveTasks() public view returns (uint[] memory) {
        require(users[msg.sender].role == Role.Manager, 'Operation can only be performed by a manager');

        uint numberOfTasks = 0;
        for (uint i = 0; i < activeTasks.length; i++) {
            if (activeTasks[i].managerAddress == msg.sender) {
                numberOfTasks++;
            }
        }

        uint[] memory tasks = new uint[](numberOfTasks);
        uint counter = 0;
        for (uint i = 0; i < activeTasks.length; i++) {
            if (activeTasks[i].managerAddress == msg.sender) {
                tasks[counter++] = activeTasks[i].id;
            }
        }
        return tasks;
    }

    function mGetTaskApplicants(uint taskId) public view returns (address[] memory) {
        require(users[msg.sender].role == Role.Manager, 'Operation can only be performed by a manager');
        uint taskIndex = getActiveTaskIndex(taskId);
        return activeTasks[taskIndex].applicants;
    }

    function mGetEvaluators() public view returns (address[] memory) {
        require(users[msg.sender].role == Role.Manager, 'Operation can only be performed by a manager');
        uint numberOfEvaluators = 0;
        for (uint i = 0; i < userList.length; i++) {
            if (users[userList[i]].role == Role.Evaluator) {
                numberOfEvaluators++;
            }
        }
        address[] memory evaluators = new address[](numberOfEvaluators);
        uint counter = 0;
        for (uint i = 0; i < userList.length; i++) {
            if (users[userList[i]].role == Role.Evaluator) {
                evaluators[counter++] = userList[i];
            }
        }
        return evaluators;
    }

    function mChooseFreelancer(uint taskId, address freelancerAddress) public {
        require(users[msg.sender].role == Role.Manager, 'Operation can only be performed by a manager');
        require(users[freelancerAddress].role == Role.Freelancer, 'Chosen freelancer does not have a freelancer role');
        uint taskIndex = getActiveTaskIndex(taskId);
        require(activeTasks[taskIndex].managerAddress == msg.sender, 'Operation cand only be performed by the task owner');
        require(activeTasks[taskIndex].status == TaskStatus.WaitingApplications, 'Task is past application stages');
        require(activeTasks[taskIndex].freelancerAddress == address(0), 'Freelancer already chosen');
        bool foundApplicant = false;
        for (uint i = 0; i < activeTasks[taskIndex].applicants.length; i++) {
            if (activeTasks[taskIndex].applicants[i] == freelancerAddress) {
                foundApplicant = true;
                break;
            }
        }
        require(foundApplicant, 'Chosen freelancer has not applied for this task');

        for (uint i = 0; i < activeTasks[taskIndex].applicants.length; i++) {
            if (activeTasks[taskIndex].applicants[i] != freelancerAddress) {
                token.transfer(activeTasks[taskIndex].applicants[i], activeTasks[taskIndex].evaluatorPayout);
            }
        }

        activeTasks[taskIndex].freelancerAddress = freelancerAddress;
        activeTasks[taskIndex].status = TaskStatus.Working;
    }

    function mAcceptTask(uint taskId) public {
        require(users[msg.sender].role == Role.Manager, 'Operation can only be performed by a manager');
        uint taskIndex = getActiveTaskIndex(taskId);
        require(activeTasks[taskIndex].status == TaskStatus.Complete, 'Task not completed');
        require(activeTasks[taskIndex].managerAddress == msg.sender, 'Operation cand only be performed by the task owner');
        activeTasks[taskIndex].status = TaskStatus.Finished;
        
        token.transfer(activeTasks[taskIndex].freelancerAddress, activeTasks[taskIndex].freelancerPayout);
        token.transfer(activeTasks[taskIndex].managerAddress, activeTasks[taskIndex].evaluatorPayout);
        
        if (users[activeTasks[taskIndex].managerAddress].reputation < 10) {
            users[activeTasks[taskIndex].managerAddress].reputation += 1;
        }

        if (users[activeTasks[taskIndex].freelancerAddress].reputation < 10) {
            users[activeTasks[taskIndex].freelancerAddress].reputation += 1;
        }

        inactiveTasks.push(activeTasks[taskIndex]);
        activeTasks[taskIndex] = activeTasks[activeTasks.length - 1];
        activeTasks.length--;
    }
    
    function mRequestEvaluation(uint taskId) public {
        require(users[msg.sender].role == Role.Manager, 'Operation can only be performed by a manager');
        uint taskIndex = getActiveTaskIndex(taskId);
        require(activeTasks[taskIndex].status == TaskStatus.Complete, 'Task not completed');
        require(activeTasks[taskIndex].managerAddress == msg.sender, 'Operation cand only be performed by the task owner');
        
        activeTasks[taskIndex].status = TaskStatus.WaitingEvaluation;
    }

    // freelancer

    // CALL APPROVE as FREELANCER for evaluatorPay
    function fApplyForTask(uint taskId) public {
        require(users[msg.sender].role == Role.Freelancer, 'Operation can only be performed by a freelancer');
        uint taskIndex = getActiveTaskIndex(taskId);
        require(!userAppliedToTask(msg.sender, taskId), 'User already applied for the task');
        token.transferFrom(msg.sender, address(this), activeTasks[taskIndex].evaluatorPayout);
        activeTasks[taskIndex].applicants.push(msg.sender);
    }

    function fSetTaskComplete(uint taskId, string memory notificationMessage) public {
        require(users[msg.sender].role == Role.Freelancer, 'Operation can only be performed by a freelancer');
        uint taskIndex = getActiveTaskIndex(taskId);
        require(activeTasks[taskIndex].freelancerAddress == msg.sender, 'Operation can only be performed by the assigned freelancer');
        activeTasks[taskIndex].status = TaskStatus.Complete;
        activeTasks[taskIndex].notification = notificationMessage;
    }

    function fGetActiveTasks() public view returns (uint[] memory) {
        require(users[msg.sender].role == Role.Freelancer, 'Operation can only be performed by a freelancer');

        uint numberOfTasks = 0;
        for (uint i = 0; i < activeTasks.length; i++) {
            if (activeTasks[i].freelancerAddress == msg.sender) {
                numberOfTasks++;
            }
        }

        uint[] memory tasks = new uint[](numberOfTasks);
        uint counter = 0;
        for (uint i = 0; i < activeTasks.length; i++) {
            if (activeTasks[i].freelancerAddress == msg.sender) {
                tasks[counter++] = activeTasks[i].id;
            }
        }
        return tasks;
    }

    function fGetAppliedTasks() public view returns (uint[] memory) {
        require(users[msg.sender].role == Role.Freelancer, 'Operation can only be performed by a freelancer');

        uint numberOfTasks = 0;
        for (uint i = 0; i < activeTasks.length; i++) {
            if (userAppliedToTask(msg.sender, activeTasks[i].id)) {
                numberOfTasks++;
            }
        }

        uint[] memory tasks = new uint[](numberOfTasks);
        uint counter = 0;
        for (uint i = 0; i < activeTasks.length; i++) {
            if (userAppliedToTask(msg.sender, activeTasks[i].id)) {
                tasks[counter++] = activeTasks[i].id;
            }
        }
        return tasks;
    }

    function fGetAvailableTasks() public view returns (uint[] memory) {
        require(users[msg.sender].role == Role.Freelancer, 'Operation can only be performed by a freelancer');

        uint numberOfTasks = 0;
        for (uint i = 0; i < activeTasks.length; i++) {
            if (!userAppliedToTask(msg.sender, activeTasks[i].id)) {
                numberOfTasks++;
            }
        }

        uint[] memory tasks = new uint[](numberOfTasks);
        uint counter = 0;
        for (uint i = 0; i < activeTasks.length; i++) {
            if (!userAppliedToTask(msg.sender, activeTasks[i].id)) {
                tasks[counter++] = activeTasks[i].id;
            }
        }
        return tasks;
    }

    // evaluator

    function eGetActiveTasks() public view returns (uint[] memory) {
        require(users[msg.sender].role == Role.Evaluator, 'Operation can only be performed by an evaluator');

        uint numberOfTasks = 0;
        for (uint i = 0; i < activeTasks.length; i++) {
            if (activeTasks[i].evaluatorAddress == msg.sender && activeTasks[i].status == TaskStatus.WaitingEvaluation) {
                numberOfTasks++;
            }
        }

        uint[] memory tasks = new uint[](numberOfTasks);
        uint counter = 0;
        for (uint i = 0; i < activeTasks.length; i++) {
            if (activeTasks[i].evaluatorAddress == msg.sender && activeTasks[i].status == TaskStatus.WaitingEvaluation) {
                tasks[counter++] = activeTasks[i].id;
            }
        }
        return tasks;
    }

    // freelancer wins
    function eGiveVerdictForFreelancer(uint taskId) public {
        require(users[msg.sender].role == Role.Evaluator, 'Operation can only be performed by an evaluator');
        uint taskIndex = getActiveTaskIndex(taskId);
        require(activeTasks[taskIndex].status == TaskStatus.WaitingEvaluation, 'Task not awaiting evaluation');
        require(activeTasks[taskIndex].evaluatorAddress == msg.sender, 'Operation cand only be performed by the selected evaluator');
        activeTasks[taskIndex].status = TaskStatus.Finished;
        
        token.transfer(activeTasks[taskIndex].freelancerAddress, activeTasks[taskIndex].freelancerPayout);
        token.transfer(activeTasks[taskIndex].freelancerAddress, activeTasks[taskIndex].evaluatorPayout);
        token.transfer(activeTasks[taskIndex].evaluatorAddress, activeTasks[taskIndex].evaluatorPayout);
        
        if (users[activeTasks[taskIndex].managerAddress].reputation > 1) {
            users[activeTasks[taskIndex].managerAddress].reputation -= 1;
        }

        if (users[activeTasks[taskIndex].freelancerAddress].reputation < 10) {
            users[activeTasks[taskIndex].freelancerAddress].reputation += 1;
        }

        inactiveTasks.push(activeTasks[taskIndex]);
        activeTasks[taskIndex] = activeTasks[activeTasks.length - 1];
        activeTasks.length--;
    }

    // manager wins
    function eGiveVerdictForManager(uint taskId) public {
        require(users[msg.sender].role == Role.Evaluator, 'Operation can only be performed by an evaluator');
        uint taskIndex = getActiveTaskIndex(taskId);
        require(activeTasks[taskIndex].status == TaskStatus.WaitingEvaluation, 'Task not awaiting evaluation');
        require(activeTasks[taskIndex].evaluatorAddress == msg.sender, 'Operation cand only be performed by the selected evaluator');
        activeTasks[taskIndex].status = TaskStatus.Finished;
        
        token.transfer(activeTasks[taskIndex].managerAddress, activeTasks[taskIndex].freelancerPayout);
        token.transfer(activeTasks[taskIndex].managerAddress, activeTasks[taskIndex].evaluatorPayout);
        token.transfer(activeTasks[taskIndex].evaluatorAddress, activeTasks[taskIndex].evaluatorPayout);
        
        if (users[activeTasks[taskIndex].managerAddress].reputation < 10) {
            users[activeTasks[taskIndex].managerAddress].reputation += 1;
        }

        if (users[activeTasks[taskIndex].freelancerAddress].reputation > 1) {
            users[activeTasks[taskIndex].freelancerAddress].reputation -= 1;
        }

        inactiveTasks.push(activeTasks[taskIndex]);
        activeTasks[taskIndex] = activeTasks[activeTasks.length - 1];
        activeTasks.length--;
    }

    function() external payable{} //Fallback function



}

