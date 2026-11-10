// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title Greeting
/// @notice Stores a greeting that only the deploying account may update.
contract Greeting {
    string private greeting;
    address public owner;

    event GreetingChanged(address changer, string newGreeting);

    /// @param _g The greeting stored when the contract is deployed.
    constructor(string memory _g) {
        greeting = _g;
        owner = msg.sender;
    }

    /// @notice Updates the greeting. Only the contract owner can call this function.
    /// @param _g The replacement greeting.
    function setGreeting(string memory _g) public {
        require(msg.sender == owner, "Only the owner can change the greeting");

        greeting = _g;
        emit GreetingChanged(msg.sender, _g);
    }

    /// @notice Returns the currently stored greeting.
    function greet() public view returns (string memory) {
        return greeting;
    }

    /// @notice Restores the greeting to the assignment default value.
    function resetGreeting() public {
        require(msg.sender == owner, "Only the owner can change the greeting");

        greeting = "Hello, World!";
        emit GreetingChanged(msg.sender, greeting);
    }
}
