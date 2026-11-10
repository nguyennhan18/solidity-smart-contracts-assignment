// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Counter {
    uint256 public count;
    uint256 public constant MAX = 100;
    event Incremented(address indexed by, uint256 newCount);
    event Decremented(address indexed by, uint256 newCount);
    event Reset(address indexed by);
    function increment() external { require(count < MAX, "Max limit reached"); count++; emit Incremented(msg.sender, count); }
    function decrement() external { require(count > 0, "Count is zero"); count--; emit Decremented(msg.sender, count); }
    function reset() external { count = 0; emit Reset(msg.sender); }
}
