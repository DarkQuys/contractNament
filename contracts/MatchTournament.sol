pragma solidity ^0.8.9; 

contract MatchTournament {
    struct MatchResult {
        address winner ;
        address loser ; 
        uint timestamp;
    }
    struct Tournament {
        uint id ;
        string name ; 
        MatchResult[] matchResults ;
    }

    mapping(uint => Tournament) public tournaments ;
    uint public TournamentCounts  ;

    event createdTournament (uint indexed id , string name ) ; 
    event recorded(uint indexed id , address winner , address loser) ; 

    function createTournament( string memory name ) external {
        TournamentCounts++ ;
        tournaments[TournamentCounts].id  =  TournamentCounts ; 
        tournaments[TournamentCounts].name = name ; 
        emit createdTournament(TournamentCounts, name);
    }
    function recordMatch( uint id ,address _winner ,  address _loser )external {
        require(id > 0 && id<= TournamentCounts , "ID invalid") ;
        require(_winner!=address(0) && _loser!=address(0) , " address invalid");
        require(_winner != _loser , "winner and loser can not same" ) ;
        MatchResult memory matchResult = MatchResult(_winner, _loser, block.timestamp);
        tournaments[id].matchResults.push(matchResult);
        emit recorded(id, _winner, _loser);
    }   

    function getRecordMatchTournament(uint idTournament)external view returns(MatchResult[] memory ){
        require(idTournament > 0 && idTournament<= TournamentCounts ,"ID invalid") ;
        return tournaments[idTournament].matchResults ;
    }
    function getTournament(uint id ) external view returns(Tournament memory){
        require(id>0 && id <=TournamentCounts ,"ID invalid");
        return tournaments[id] ; 
    }
}