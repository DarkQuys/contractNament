pragma solidity ^0.8.9;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
contract NFTcontract is ERC721 {
    event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
    event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);
    event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
    // function balanceOf(address _owner) external view returns (uint256);
    // function ownerOf(uint256 _tokenId) external view returns (address);
    // function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes data) external payable;
    // function safeTransferFrom(address _from, address _to, uint256 _tokenId) external payable;
    // function transferFrom(address _from, address _to, uint256 _tokenId) external payable;
    // function approve(address _approved, uint256 _tokenId) external payable;
    // function setApprovalForAll(address _operator, bool _approved) external;
    // function getApproved(uint256 _tokenId) external view returns (address);
    // function isApprovedForAll(address _owner, address _operator) external view returns (bool);
    mapping(address => uint ) internal _balances ;
    mapping(uint => address) internal _owners; 
    mapping(address=> mapping(address => bool)) private _operatorApprovals ;
    mapping(uint =>address) private _tokenApprovals; 
    // return number NTFs of user 
    function balanceOf(address _owner) external view returns (uint256){
        require(_owner != address(0) , "Address is zero");
        return  _balances[_owner] ;
    }
    // finds owner of an NTF
    function ownerOf(uint256 _tokenId) public view returns (address){
        address owner = _owners[_tokenId] ;
        require(owner != address(0) , "tokenId does not exist") ;
        return owner ;
    }
    function setApprovalForAll(address _operator, bool _approved) external {
        _operatorApprovals[msg.sender][_operator] =  _approved ;
        emit ApprovalForAll(msg.sender, _operator, _approved);
    }
    //check if address is operator for another address
    function isApprovedForAll(address _owner, address _operator) public view returns (bool){
        return _operatorApprovals[_owner][_operator] ;
    }
    //update an approved of NTF 
    function approve(address to , uint256 _tokenId) public payable{
        address owner = ownerOf(_tokenId) ; 
        require(msg.sender==owner || isApprovedForAll(owner , msg.sender) , "msg.sender is not a owner");
        _tokenApprovals[_tokenId] = to ; 
        emit Approval(owner, to , _tokenId);  
    }
    //get approved for NFT 
    function getApproved(uint256 tokenId) public view returns (address){
        require(_owners[tokenId] != address(0) ,"tokenId does not exist");
        return _tokenApprovals[tokenId] ;

    }
    //tranfer ownership of a single NTF
    function transferFrom(address from, address to, uint256 tokenId) public payable{
        address owner = ownerOf(tokenId); 
        require(msg.sender==owner || 
        getApproved(tokenId)==owner ||
        isApprovedForAll(msg.sender ,owner ), "msg.sender is not owner of NTF") ; 
        require(owner ==from , "address from is not a owner");
        require(to!= address(0), "address to is not zero address") ;
        require(_owners[tokenId] != address(0) , "addres is not exist");
        approve(address(0), tokenId);
        _balances[from]-=1 ;
        _balances[to] +=1; 
        _owners[tokenId] = to ;
        emit Transfer(from, to, tokenId);

    }
    function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) external payable{
        transferFrom(from, to, tokenId);
        require( _checkOnERC721Received(), "received is not implemented" );

    }
    function _checkOnERC721Received()internal pure returns(bool){
        return true ;
    }
    function safeTransferFrom(address from, address to, uint256 tokenId) external payable{
        transferFrom(from, to, tokenId);
    }

    function supportInterface(bytes4 interfaceID) public pure virtual returns(bool){
        return interfaceID = 0x80ac58cd ;
    } 
}



