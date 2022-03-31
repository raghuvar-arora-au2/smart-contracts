// SPDX-License-Identifier: MIT

pragma solidity >=0.5.0 <0.9.0;

contract CrowdFunding{
    mapping(address=> uint) public contributors;
    address public manager;
    uint public numberOfContributers;
    uint public minimumContribution;
    uint public deadline;
    uint public goalAmount;
    uint public raisedAmount;

    constructor(uint _goalAmount, uint _deadline, uint _minimumContribution){
        goalAmount=_goalAmount;
        deadline=_deadline;
        manager=msg.sender;
        minimumContribution= _minimumContribution;
    }   
}