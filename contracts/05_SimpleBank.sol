// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleBank {
    mapping(address => uint256) private balances;
    event Deposited(address indexed user, uint256 amount);
    event Withdrawn(address indexed user, uint256 amount);
    function deposit() external payable { require(msg.value > 0, "Deposit must be positive"); balances[msg.sender] += msg.value; emit Deposited(msg.sender, msg.value); }
    function withdraw(uint256 amount) external {
        require(amount > 0 && balances[msg.sender] >= amount, "Insufficient balance");
        balances[msg.sender] -= amount; // effects before interaction
        (bool ok,) = payable(msg.sender).call{value: amount}(""); require(ok, "Transfer failed"); emit Withdrawn(msg.sender, amount);
    }
    function myBalance() external view returns (uint256) { return balances[msg.sender]; }
    function bankTotal() external view returns (uint256) { return address(this).balance; }
}
