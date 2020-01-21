pragma solidity ^0.5.0;

contract FreelancingMarketplace
{
    address public owner = msg.sender;
    
    modifier onlyBy(address _account) {
        require(msg.sender == _account);
        _;
    }
    
    struct Person {
        string _firstName;
        string _lastName;
        uint256 _reputation;
        bool managerRole;
        bool freelancerRole;
        bool evalautorRole;
    }
    
    struct Task{
        address _managerAddress;
        address _freelancerAddress;
        address _evaluatorAddress;
    }
    
    mapping(address => Person) Persons;
    uint256 personsCount = 0;
    mapping(uint256 => Task) Tasks;
    uint256 tasksCount = 0;
    address[] public personAccts;

    function addPerson(string memory _fName, string memory _lName) public {
        Persons[msg.sender] = Person(_fName, _lName, 5, false, false, false);
        personAccts.push(msg.sender);
    }

    function getPerson(address _address) view public returns (string memory, string memory,uint256) {
        return (Persons[_address]._firstName, Persons[_address]._lastName, Persons[_address]._reputation);
    }
    
    function getActivePerson() view public returns (string memory, string memory,uint256) {
        return (Persons[msg.sender]._firstName, Persons[msg.sender]._lastName, Persons[msg.sender]._reputation);
    }

    function setFirstName(string memory _fName) public{
        Persons[msg.sender]._firstName = _fName;
    }

    function setFirsLasttName(string memory _lName) public{
        Persons[msg.sender]._lastName = _lName;
    }
    
    function getReputation() view public returns (uint256){
        return Persons[msg.sender]._reputation;
    }
    
    function incrementReputation() public{
        uint256 _currReputation = getReputation();
        Persons[msg.sender]._reputation = _currReputation + 1;
    }    

}

