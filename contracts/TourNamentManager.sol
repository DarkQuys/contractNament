 pragma solidity ^0.8.9;

// import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
// import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
// import "@openzeppelin/contracts/access/Ownable.sol";
import "./TourNamentFactory.sol" ;

contract TourNamentManager{
    TourNamentFactory public tournamentfactory ;
    constructor (address factory){
        tournamentfactory = TourNamentFactory(factory) ;
    }
    function myCreate(string memory name , uint startTime , uint endTime)public returns(uint) {
        return tournamentfactory.createTourNament(name, startTime, endTime);
    }
    function myEdit(uint id  , string memory name , uint startTime , uint endTime) public {
        tournamentfactory.editTourNament(id, name, startTime, endTime);
    }
    function getNament(uint id ) public view returns (string memory , uint startTime, uint endTime){
        return tournamentfactory.getTourNament(id);
    }

}