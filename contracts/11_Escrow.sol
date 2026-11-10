// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Escrow {
    enum State { AwaitingPayment, AwaitingDelivery, Complete, Refunded, Disputed }
    address payable public buyer; address payable public seller; address payable public arbiter; State public state;
    event StateChanged(State newState); event Released(address indexed recipient,uint256 amount);
    modifier onlyBuyer(){require(msg.sender==buyer,"Only buyer");_;} modifier onlyArbiter(){require(msg.sender==arbiter,"Only arbiter");_;} modifier onlyArbiterOrSeller(){require(msg.sender==arbiter||msg.sender==seller,"Only arbiter or seller");_;} modifier onlyBuyerOrSeller(){require(msg.sender==buyer||msg.sender==seller,"Only buyer or seller");_;} modifier stateCheck(State expected){require(state==expected,"Invalid state");_;}
    constructor(address payable _seller,address payable _arbiter) payable { require(_seller != address(0) && _arbiter != address(0),"Zero address"); require(msg.value>0,"Payment required"); buyer=payable(msg.sender); seller=_seller; arbiter=_arbiter; state=State.AwaitingDelivery; emit StateChanged(state); }
    function confirmDelivery() external onlyBuyer stateCheck(State.AwaitingDelivery) { state=State.Complete; uint amount=address(this).balance; (bool ok,)=seller.call{value:amount}(""); require(ok,"Transfer failed"); emit Released(seller,amount); emit StateChanged(state); }
    function refundBuyer() external onlyArbiterOrSeller stateCheck(State.AwaitingDelivery) { state=State.Refunded; uint amount=address(this).balance; (bool ok,)=buyer.call{value:amount}(""); require(ok,"Transfer failed"); emit Released(buyer,amount); emit StateChanged(state); }
    function raiseDispute() external onlyBuyerOrSeller stateCheck(State.AwaitingDelivery) { state=State.Disputed; emit StateChanged(state); }
    function resolveToSeller() external onlyArbiter stateCheck(State.Disputed) { state=State.Complete; uint amount=address(this).balance; (bool ok,)=seller.call{value:amount}(""); require(ok,"Transfer failed"); emit Released(seller,amount); emit StateChanged(state); }
    function resolveToBuyer() external onlyArbiter stateCheck(State.Disputed) { state=State.Refunded; uint amount=address(this).balance; (bool ok,)=buyer.call{value:amount}(""); require(ok,"Transfer failed"); emit Released(buyer,amount); emit StateChanged(state); }
}
