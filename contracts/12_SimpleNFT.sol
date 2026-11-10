// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleNFT {
    string public name; string public symbol; uint256 public nextTokenId; uint256 public constant MAX_SUPPLY=100; uint256 public mintPrice=0.01 ether; address public owner;
    mapping(uint256=>address) public ownerOf; mapping(address=>uint256) public balances; mapping(uint256=>address) public approvals;
    event Minted(address indexed to,uint256 indexed tokenId); event TransferNFT(address indexed from,address indexed to,uint256 indexed tokenId); event Approval(address indexed owner,address indexed spender,uint256 indexed tokenId);
    modifier onlyOwner(){require(msg.sender==owner,"Only owner");_;}
    constructor(string memory _name,string memory _symbol){name=_name;symbol=_symbol;owner=msg.sender;}
    function mint() external payable returns(uint256) { require(msg.value==mintPrice,"Send exact mint price"); require(nextTokenId<MAX_SUPPLY,"Max supply reached"); uint id=nextTokenId++; ownerOf[id]=msg.sender; balances[msg.sender]++; emit Minted(msg.sender,id); emit TransferNFT(address(0),msg.sender,id); return id; }
    function transferNFT(address to,uint256 tokenId) external { require(ownerOf[tokenId]==msg.sender,"Not token owner"); _transfer(msg.sender,to,tokenId); }
    function approve(address spender,uint256 tokenId) external { require(ownerOf[tokenId]==msg.sender,"Not token owner"); approvals[tokenId]=spender; emit Approval(msg.sender,spender,tokenId); }
    function transferFrom(address from,address to,uint256 tokenId) external { require(ownerOf[tokenId]==from,"Wrong owner"); require(approvals[tokenId]==msg.sender,"Not approved"); _transfer(from,to,tokenId); }
    function _transfer(address from,address to,uint256 tokenId) internal { require(to!=address(0),"Zero recipient"); ownerOf[tokenId]=to; balances[from]--; balances[to]++; delete approvals[tokenId]; emit TransferNFT(from,to,tokenId); }
    function withdrawPayments() external onlyOwner { uint amount=address(this).balance; (bool ok,)=payable(owner).call{value:amount}(""); require(ok,"Transfer failed"); }
}
