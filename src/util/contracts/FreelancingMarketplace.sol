pragma solidity ^0.5.0;

import "FMLTKN.sol";

contract FreelancingMarketplace
{
    
// ---------- Structs ----------
    
    address public owner = msg.sender; 
    modifier onlyBy(address _account) {
        require(msg.sender == _account,
        "Sender not authorized");
        _;
    }
    struct Person {
        string _firstName;
        string _lastName;
        int256 _reputation;
        bool _managerRole;
        bool _freelancerRole;
        bool _evaluatorRole;
    }
    
    enum TaskStatus {Waiting, Running, Solved, NeedingEvaluation, Successfull, Fail,  Finished}
    
    struct Task{
        address _freelancerAddress;
        address _evaluatorAddress;
        TaskStatus _taskStatus;
        string _description;
        string _domain;
        uint256 _estimatedResolveTime;
        uint256 _estimatedEvaluationTime;
        uint256 _rewardAmountFreelancer;
        uint256 _rewardAmountEvaluator;
    }
    
    mapping(address => Person) Persons;
    uint256 personsCount = 0;
    mapping(address => Task) Tasks;
    uint256 tasksCount = 0;
    address[] public personAccts;

// ---------- Setters / Getters  ----------

    function addPerson(address _address, string memory _fName, string memory _lName) public {
        Persons[_address] = Person(_fName, _lName, 5, false, false, false);
        personAccts.push(_address);
    }

    function getPerson(address _address) public view  returns (string memory, string memory, int256) {
        return (Persons[_address]._firstName, Persons[_address]._lastName, Persons[_address]._reputation);
    }

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
    
    function addTask(address _address, string memory description, string memory domain, uint256 estimatedResolveTime, uint256 estimatedEvaluationTime, uint256 rewardAmountFreelancer, uint256 rewardAmountEvaluator) public payable{
        require(isManager(_address) == true, 'Only manager can add tasks!');
        require(rewardAmountEvaluator + rewardAmountFreelancer <= msg.value);
        Tasks[_address] = Task(address(0), address(0), TaskStatus.Waiting, description, domain, estimatedResolveTime, estimatedEvaluationTime, rewardAmountFreelancer, rewardAmountEvaluator);
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
    

    function() external payable{} //Fallback function

}

