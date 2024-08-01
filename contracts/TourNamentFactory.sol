pragma solidity ^0.8.9;

// import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
// import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
// import "@openzeppelin/contracts/access/Ownable.sol";
/**
 * @title Storage
 * @dev Store & retrieve value in a variable
 * @custom:dev-run-script ./scripts/deploy_with_ethers.ts
 */
contract TourNamentFactory {
  

    struct TourNament{
        string name ;
        uint startTime ;
        uint endTime ;
    }
    
    mapping(uint => TourNament ) public TourNaments ;
    uint public tourNamentCount = 0  ;
    event createTour(string name , uint startTime , uint endTime);
    event updateTourNament(string name , uint startTime , uint endTime ) ;    
    function createTourNament ( string memory name , uint startTime , uint endTime ) public returns (uint){
        require( startTime < endTime , "loi thoi gian roi ni" );
        tourNamentCount +=1;
        TourNaments[tourNamentCount] = TourNament(name , startTime , endTime) ;
        emit createTour(name, startTime, endTime);
        return tourNamentCount;
    }
    function editTourNament(uint id , string memory name , uint startTime , uint endTime ) public{
        require(startTime < endTime , "start must be endTime") ; 
        require(id>0 && id <= tourNamentCount , "invalid tourNamentd") ;
        // TourNament memory tour  = TourNaments[id] ;
        // tour.name = name ;
        // tour.startTime = startTime ;
        // tour.endTime =  endTime ;
        TourNaments[id].name = name;
        TourNaments[id].startTime = startTime;
        TourNaments[id].endTime = endTime;

        emit updateTourNament(name, startTime, endTime);
    }
    function getTourNament(uint id ) public view returns (string memory , uint , uint ){
        require(id>0 && id<= tourNamentCount , "invalid your id");
        TourNament memory tournament = TourNaments[id] ;
        require(tournament.startTime < tournament.endTime , "Enter err time");
        return (tournament.name , tournament.startTime , tournament.endTime);
    } 
}