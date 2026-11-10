// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TimeLockVault {
    address payable public beneficiary; uint256 public unlockTime;
    event Deposited(address indexed from,uint256 amount,uint256 newUnlockTime); event Withdrawn(address indexed to,uint256 amount);
    modifier onlyBeneficiary(){ require(msg.sender==beneficiary,"Only beneficiary"); _; }
    constructor(address payable _beneficiary,uint256 _lockSeconds){ require(_beneficiary != address(0),"Zero beneficiary"); beneficiary=_beneficiary; unlockTime=block.timestamp+_lockSeconds; }
    function deposit() external payable { require(msg.value>0,"Amount is zero"); emit Deposited(msg.sender,msg.value,unlockTime); }
    function extendLock(uint256 _extraSeconds) external onlyBeneficiary { require(_extraSeconds>0,"Extension is zero"); unlockTime += _extraSeconds; }
    function withdraw() external onlyBeneficiary { require(block.timestamp >= unlockTime,"Vault is still locked"); uint amount=address(this).balance; require(amount>0,"Vault is empty"); (bool ok,)=beneficiary.call{value:amount}(""); require(ok,"Transfer failed"); emit Withdrawn(beneficiary,amount); }
    function timeRemaining() external view returns(uint256){ return block.timestamp >= unlockTime ? 0 : unlockTime-block.timestamp; }
}
