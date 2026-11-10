// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Storage {
    uint256 private storedData;
    event ValueSet(address indexed who, uint256 newValue);
    constructor(uint256 _init) { storedData = _init; }
    function set(uint256 _value) external { storedData = _value; emit ValueSet(msg.sender, _value); }
    function get() external view returns (uint256) { return storedData; }
}
