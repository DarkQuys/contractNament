pragma solidity ^0.8.9;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
contract NTFManager is ERC721 ,Ownable{
    uint private _tokenIds; 
    mapping(uint => string) private _tokenURIs ;
    constructor () ERC721 ("NTFManager" , "NTF"){} 

    function mint(address to , string memory tokenURI ) public onlyOwner returns(uint){
        _tokenIds++ ;
        _mint(to,_tokenIds);
        setTokenURI(_tokenIds , tokenURI) ;
        return _tokenIds ;
    }
    function setTokenURI(uint id , string memory tokenURI )internal{
        _tokenURIs[id] = tokenURI ;
    }
    function approve(address to ,uint tokenId) public override{
        address ownerr = ERC721.ownerOf(tokenId);
        require(ownerr != to , "(ERC721) error address");
        require(
            _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
            "ERC721: approve caller is not owner nor approved for all"
        );
        _approve(to, tokenId);
    }
    function TranferForm (address from , address to , uint tokenId)public  {
        safeTransferFrom(from, to, tokenId,"");
    }
}