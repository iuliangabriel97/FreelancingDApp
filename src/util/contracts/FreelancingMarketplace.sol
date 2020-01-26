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

    function mGetActiveTasksNumber() public view returns (uint) {
        require(users[msg.sender].role == Role.Manager, 'Operation can only be performed by a manager');
        uint number = 0;
        for (uint i = 0; i < activeTasks.length; i++) {
            if (activeTasks[i].managerAddress == msg.sender) {
                number++;
            }
        }
        return number;
    }
    
    function mGetTaskByIndex(uint taskIndex) public view returns (Task memory) {
        require(users[msg.sender].role == Role.Manager, 'Operation can only be performed by a manager');
        uint index = 0;
        for (uint i = 0; i < activeTasks.length; i++) {
            if (activeTasks[i].managerAddress == msg.sender) {
                if (taskIndex == index) {
                    return activeTasks[i];
                }
                index++;
            }
        }
    }

    function mGetTaskApplicants(uint taskId) public view returns (address[] memory) {
        require(users[msg.sender].role == Role.Manager, 'Operation can only be performed by a manager');
        uint taskIndex = getActiveTaskIndex(taskId);
        return activeTasks[taskIndex].applicants;
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
        
        inactiveTasks.push(activeTasks[taskIndex]);
        activeTasks[taskIndex] = activeTasks[activeTasks.length - 1];
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
        for (uint i = 0; i < activeTasks[taskIndex].applicants.length; i++) {
            if (activeTasks[taskIndex].applicants[i] == msg.sender) {
                revert('User already applied for the task');
            }
        }
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

    function fGetActiveTasksNumber() public view returns (uint) {
        require(users[msg.sender].role == Role.Freelancer, 'Operation can only be performed by a freelancer');
        uint number = 0;
        for (uint i = 0; i < activeTasks.length; i++) {
            if (activeTasks[i].freelancerAddress == msg.sender) {
                number++;
            }
        }
        return number;
    }

    function fGetTaskByIndex(uint taskIndex) public view returns (Task memory) {
        require(users[msg.sender].role == Role.Freelancer, 'Operation can only be performed by a freelancer');
        uint index = 0;
        for (uint i = 0; i < activeTasks.length; i++) {
            if (activeTasks[i].freelancerAddress == msg.sender) {
                if (taskIndex == index) {
                    return activeTasks[i];
                }
                index++;
            }
        }
    }

/*
    function setFirstName(address _address, string memory _fName) public {
        Persons[_address]._firstName = _fName;
    }

    function setFirsLastName(address _address, string memory _lName) public {
        Persons[_address]._lastName = _lName;
    }

    function setManagerRole(address _address, bool _bool) public {
        Persons[_address]._managerRole = _bool;
    }

    function setFreelancerRole(address _address, bool _bool) public {
        Persons[_address]._freelancerRole = _bool;
    }

    function setEvaluatorRole(address _address, bool _bool) public {
        Persons[_address]._evaluatorRole = _bool;
    }

    function isManager(address _address) internal returns(bool) {
        return Persons[_address]._managerRole == true;
    }

    function isEvaluator(address _address) internal returns(bool) {
        return Persons[_address]._evaluatorRole == true;
    }

    function isFreelancer(address _address) internal returns(bool) {
        return Persons[_address]._freelancerRole == true;
    }

    function modifyReputation(address _address, int256 _value) internal {
        (string memory _fName, string memory _lName, int256 _currReputation) = getPerson(_address);
        Persons[_address]._reputation = _currReputation + _value;
    }

    function addTask(
        address _address,
        string memory description,
        string memory domain,
        uint estimatedResolveTime,
        uint estimatedEvaluationTime,
        uint rewardAmountFreelancer,
        uint rewardAmountEvaluator)
        public payable {
        require(isManager(_address) == true, 'Only manager can add tasks!');
        require(rewardAmountEvaluator + rewardAmountFreelancer <= msg.value, 'msg.value less than expected');
        Tasks.push(Task(
            address(0),
            address(0),
            TaskStatus.Waiting,
            description,
            domain,
            estimatedResolveTime,
            estimatedEvaluationTime,
            rewardAmountFreelancer,
            rewardAmountEvaluator));
    }

    function getTask(address _address) public view returns(address, address, TaskStatus)
    {
        return (Tasks[_address]._freelancerAddress, Tasks[_address]._evaluatorAddress, Tasks[_address]._taskStatus);
    }

    function isTaskWaiting(address _address) public returns(bool){
        return Tasks[_address]._taskStatus == TaskStatus.Waiting;
    }

    function isTaskRunning(address _address) public returns(bool){
        return Tasks[_address]._taskStatus == TaskStatus.Running;
    }

    function isTaskSolved(address _address) public returns(bool){
        return Tasks[_address]._taskStatus == TaskStatus.Solved;
    }

    function setTaskEvaluator(address _address, address evaluatorrAddress) public {
        Tasks[_address]._evaluatorAddress = evaluatorrAddress;
    }

    function setTaskFreelancer(address _address, address freelancerAddress) public {
        Tasks[_address]._freelancerAddress = freelancerAddress;
    }

    function setTaskWaiting(address _address) public{
        Tasks[_address]._taskStatus = TaskStatus.Waiting;
    }

    function setTaskRunning(address _address) public{
        Tasks[_address]._taskStatus = TaskStatus.Running;
    }

    function setTaskNeedingEvaluation(address _address) public{
        Tasks[_address]._taskStatus = TaskStatus.NeedingEvaluation;
    }

    function setTaskFinished(address _address) public payable{
        require(msg.sender != Tasks[_address]._freelancerAddress, "Freelancer of task cannot mark task as finished");
        Tasks[_address]._taskStatus = TaskStatus.Finished;
    }

    function setTaskSolved(address _address) public{
        Task memory _task = Tasks[_address];
        require(_task._taskStatus == TaskStatus.Running, 'Task should be running before being marked as solved');
        _task._taskStatus = TaskStatus.Successfull;
        Tasks[_address]._taskStatus = TaskStatus.Solved;
    }
    function setTaskSuccessfull(address _address) public payable{
        Task memory _task = Tasks[_address];
        require(_task._evaluatorAddress == _address, 'Only the evaluator can mark the task as Successfull!');
        _task._taskStatus = TaskStatus.Successfull;
        modifyReputation(_task._freelancerAddress, 1);
    }

    function setTaskFail(address _address) public payable{
        Task memory _task = Tasks[_address];
        require(_task._evaluatorAddress == _address, 'Only the evaluator can mark the task as Fail!');
        _task._taskStatus = TaskStatus.Fail;
        modifyReputation(_task._freelancerAddress, -1);
    }
*/

    function() external payable{} //Fallback function



}

