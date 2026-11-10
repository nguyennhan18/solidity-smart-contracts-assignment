// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Crowdfunding {
    address payable public owner; uint256 public goal; uint256 public deadline; uint256 public raised; bool public claimed;
    mapping(address => uint256) public contributions;
    event Contributed(address indexed contributor, uint256 amount); event FundsClaimed(uint256 amount); event Refunded(address indexed contributor, uint256 amount);
    modifier onlyOwner(){ require(msg.sender==owner,"Only owner"); _; }
    constructor(uint256 _goal, uint256 _durationSeconds) { require(_goal > 0 && _durationSeconds > 0,"Invalid campaign"); owner=payable(msg.sender); goal=_goal; deadline=block.timestamp+_durationSeconds; }
    function contribute() external payable { require(block.timestamp < deadline,"Campaign ended"); require(msg.value > 0,"Amount is zero"); contributions[msg.sender]+=msg.value; raised+=msg.value; emit Contributed(msg.sender,msg.value); }
    function getRemainingTime() external view returns(uint256) { return block.timestamp >= deadline ? 0 : deadline-block.timestamp; }
    function claimFunds() external onlyOwner { require(block.timestamp >= deadline,"Campaign active"); require(raised >= goal,"Goal not reached"); require(!claimed,"Already claimed"); claimed=true; uint amount=address(this).balance; (bool ok,)=owner.call{value:amount}(""); require(ok,"Transfer failed"); emit FundsClaimed(amount); }
    function refund() external { require(block.timestamp >= deadline,"Campaign active"); require(raised < goal,"Goal reached"); uint amount=contributions[msg.sender]; require(amount > 0,"Nothing to refund"); contributions[msg.sender]=0; (bool ok,)=payable(msg.sender).call{value:amount}(""); require(ok,"Transfer failed"); emit Refunded(msg.sender,amount); }
}
