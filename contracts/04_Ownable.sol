// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Ownable {
    address public owner;
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    constructor() { owner = msg.sender; emit OwnershipTransferred(address(0), msg.sender); }
    modifier onlyOwner() { require(msg.sender == owner, "Not the owner"); _; }
    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0), "Zero address");
        emit OwnershipTransferred(owner, newOwner); owner = newOwner;
    }
}

contract ProtectedVault is Ownable {
    uint256 private treasure;
    event Deposited(address indexed from, uint256 amount);
    event Withdrawn(address indexed to, uint256 amount);
    function deposit() external payable { require(msg.value > 0, "Amount is zero"); treasure += msg.value; emit Deposited(msg.sender, msg.value); }
    function withdraw(address payable to, uint256 amt) external onlyOwner {
        require(to != address(0), "Zero address"); require(amt <= address(this).balance, "Insufficient vault balance");
        treasure -= amt; (bool ok,) = to.call{value: amt}(""); require(ok, "Transfer failed"); emit Withdrawn(to, amt);
    }
    function contractBalance() external view returns (uint256) { return address(this).balance; }
}
