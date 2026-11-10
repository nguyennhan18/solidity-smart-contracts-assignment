// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract StakingRewards {
    address payable public owner; uint256 public rewardRatePerSecond; uint256 public totalStaked; uint256 public rewardPool;
    struct Stake { uint256 amount; uint256 startTime; uint256 rewardDebt; }
    mapping(address=>Stake) public stakes;
    event Staked(address indexed user,uint256 amount); event RewardClaimed(address indexed user,uint256 amount); event Unstaked(address indexed user,uint256 principal,uint256 reward);
    modifier onlyOwner(){require(msg.sender==owner,"Only owner");_;}
    constructor(uint256 _rate) payable {owner=payable(msg.sender);rewardRatePerSecond=_rate;rewardPool=msg.value;}
    function stake() external payable {require(msg.value>0,"Amount is zero"); Stake storage user=stakes[msg.sender]; if(user.amount>0) user.rewardDebt=pendingReward(msg.sender); user.amount+=msg.value; totalStaked+=msg.value; user.startTime=block.timestamp; emit Staked(msg.sender,msg.value);}
    function pendingReward(address userAddress) public view returns(uint256){Stake memory user=stakes[userAddress];if(user.amount==0)return user.rewardDebt;return user.rewardDebt+user.amount*rewardRatePerSecond*(block.timestamp-user.startTime);}
    function claimReward() external {_claim(msg.sender);}
    function _claim(address userAddress) internal {Stake storage user=stakes[userAddress];require(user.amount>0,"No stake");uint reward=pendingReward(userAddress);require(reward>0,"No reward yet");require(reward<=rewardPool,"Reward pool empty");user.rewardDebt=0;user.startTime=block.timestamp;rewardPool-=reward;(bool ok,)=payable(userAddress).call{value:reward}("");require(ok,"Reward transfer failed");emit RewardClaimed(userAddress,reward);}
    function unstake() external {Stake storage user=stakes[msg.sender];uint principal=user.amount;require(principal>0,"No stake");uint reward=pendingReward(msg.sender);require(reward<=rewardPool,"Reward pool empty");totalStaked-=principal;rewardPool-=reward;delete stakes[msg.sender];(bool ok,)=payable(msg.sender).call{value:principal+reward}("");require(ok,"Transfer failed");emit Unstaked(msg.sender,principal,reward);}
    function fundRewards() external payable onlyOwner {require(msg.value>0,"Amount is zero");rewardPool+=msg.value;}
    function setRewardRate(uint256 _newRate) external onlyOwner {rewardRatePerSecond=_newRate;}
}
