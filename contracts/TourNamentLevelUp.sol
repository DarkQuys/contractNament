
pragma solidity ^0.8.9;
import "node_modules/@chainlink/contracts/src/v0.8/vrf/VRFConsumerBase.sol";
contract TourNamentLevelUp is VRFConsumerBase {
    bytes32 internal keyHash;
    uint256 internal fee;
    uint256 public randomResult;

    constructor() 
        VRFConsumerBase(
            0xAA77729D3466CA35AE8D28CEED6A09A9AAB0C56F153691C8AD1B38C1B7041B15, 
            0x514910771AF9Ca656af840dff83E8264EcF986CA  
        )
    {
        keyHash = 0xAA77729D3466CA35AE8D28CEED6A09A9AAB0C56F153691C8AD1B38C1B7041B15; // Example keyHash, replace with actual one
        fee = 0.1 * 10 ** 18; //phi cho link 
    }
    struct Tournament{
        string name ;
        uint startTime ;
        uint endTime ;
        uint entryFee ; 
        uint players  ;
        address winner;
        bool ended ; 
    }
    mapping(uint => Tournament) public tournaments ;
    uint public tournamentCount ;
    mapping(address => bool) public admins;
    mapping(address => bool) public referees;
    mapping(address => uint) public balances; 
    constructor() {
        admins[msg.sender] = true ;
    }
    modifier onlyAdmin() {
        require(admins[msg.sender], "Only admins can perform this action");
        _;
    }
    modifier onlyReferee (){
        require(referees[msg.sender] , "Not a referee");
        _;
    }
    function addAdmin( address adminn) external onlyAdmin{
        admins[adminn]= true ;
    }
    function removeAdmin(address adminn) external onlyAdmin{
        admins[adminn] =false ;

    }
    function addReferee(address referee) external onlyAdmin {
        referees[referee] = true;
    }
     function removeReferee(address referee) external onlyAdmin {
        referees[referee] = false;
    }
    event created(uint indexed id , string name , uint startTime , uint endTime ,uint entryFee ) ;
    event edited(uint indexed id , string name , uint startTime , uint endTime ,uint entryFee) ;
    event joined(uint indexed id) ;
    event setwin(uint indexed id , address winner  );
    function createTournament(string memory name, uint256 startTime, uint256 endTime, uint256 entryFee) external onlyAdmin {
        require(startTime < endTime, "Start time must be before end time");
        tournamentCount++;
        tournaments[tournamentCount] =Tournament({
            name: name,
            startTime: startTime,
            endTime: endTime,
            entryFee: entryFee,
            players : 0 ,
            winner: address(0),
            ended: false
        }
        );
        emit created(tournamentCount , name, startTime, endTime, entryFee);
    }
    function editTournament(uint256 id, string memory name, uint256 startTime, uint256 endTime, uint256 entryFee) external onlyAdmin {
        require(id > 0 && id <= tournamentCount, "Invalid tournament ID");
        require(startTime < endTime, "Start time must be before end time");
        tournaments[id].name = name;
        tournaments[id].startTime = startTime;
        tournaments[id].endTime = endTime;
        tournaments[id].entryFee = entryFee;
        emit edited(id , name, startTime, endTime, entryFee);
    }
    function joinTournament(uint256 id) external payable {
        require(id > 0 && id <= tournamentCount, "Invalid tournament ID");
        require(block.timestamp < tournaments[id].startTime, "Tournament has already started");
        require(msg.value == tournaments[id].entryFee, "Incorrect entry fee");
        tournaments[id].players++;
        balances[address(this)] += msg.value;
        emit joined(id);
    }
    function withdrawPrize() external {
        uint256 balance = balances[msg.sender];
        require(balance > 0, "No balance to withdraw");
        balances[msg.sender] = 0;
        (bool success, ) = msg.sender.call{value: balance}("");
        require(success, "Transfer failed");
    }
    function setWinner(uint id , address winner) external onlyReferee(){
        require(id >0 && id < tournamentCount ,  "idex invalid");
        require(!tournaments[id].ended , "giai dau da ket thucs");
        tournaments[id].winner = winner ;
        balances[winner] = tournaments[id].entryFee * tournaments[id].players ;
        emit setwin(id, winner);
    }
    // Request a random number 
    function requestRandomNumber() public returns (bytes32 requestId) {
        require(LINK.balanceOf(address(this)) >= fee, "Not enough LINK - fill contract with faucet");
        return requestRandomness(keyHash, fee);
    }

    // Callback function used by Chainlink VRF to return the random number
    function fulfillRandomness(bytes32 requestId, uint256 randomness) internal override {
        randomResult = randomness;
    }

    // Function to get a random position 
    function getRandomPosition(uint256 id) external view returns (uint256) {
        require(id > 0 && id <= tournamentCount, "Invalid tournament ID");
        require(block.timestamp >= tournaments[id].startTime, "Tournament has not started yet");
        require(randomResult > 0, "Random number not generated yet");
        return randomResult % tournaments[id].players;
    }
    
}