// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MultisigWallet {
    address[] public owners; uint256 public required;
    struct Transaction { address to; uint256 value; bool executed; }
    Transaction[] public transactions; mapping(uint256=>mapping(address=>bool)) public confirmed; mapping(address=>bool) public isOwner;
    event Submission(uint256 indexed txId); event Confirmation(address indexed owner,uint256 indexed txId); event Execution(uint256 indexed txId); event Deposit(address indexed sender,uint256 amount);
    modifier onlyOwner(){require(isOwner[msg.sender],"Not an owner");_;} modifier validTx(uint256 txId){require(txId<transactions.length,"Invalid transaction");_;}
    constructor(address[] memory _owners,uint256 _required){require(_owners.length>0 && _required>0 && _required<=_owners.length,"Invalid requirements"); for(uint i;i<_owners.length;i++){require(_owners[i]!=address(0) && !isOwner[_owners[i]],"Invalid owner");isOwner[_owners[i]]=true;owners.push(_owners[i]);}required=_required;}
    receive() external payable {emit Deposit(msg.sender,msg.value);}
    function submitTransaction(address to,uint256 value) external onlyOwner {require(to!=address(0),"Zero recipient");transactions.push(Transaction(to,value,false));emit Submission(transactions.length-1);}
    function confirmTransaction(uint256 txId) external onlyOwner validTx(txId) {require(!transactions[txId].executed,"Already executed");require(!confirmed[txId][msg.sender],"Already confirmed");confirmed[txId][msg.sender]=true;emit Confirmation(msg.sender,txId);if(getConfirmations(txId)>=required)_execute(txId);}
    function executeTransaction(uint256 txId) external onlyOwner validTx(txId) {require(getConfirmations(txId)>=required,"Not enough confirmations");_execute(txId);}
    function _execute(uint256 txId) internal {Transaction storage transaction=transactions[txId];require(!transaction.executed,"Already executed");require(address(this).balance>=transaction.value,"Insufficient wallet balance");transaction.executed=true;(bool ok,)=payable(transaction.to).call{value:transaction.value}("");require(ok,"Execution failed");emit Execution(txId);}
    function getConfirmations(uint256 txId) public view validTx(txId) returns(uint256 count){for(uint i;i<owners.length;i++)if(confirmed[txId][owners[i]])count++;}
}
