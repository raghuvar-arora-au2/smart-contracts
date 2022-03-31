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
    enum State{ Success, onGoing, Failure}
    State public currentState;


    constructor(uint _goalAmount, uint _deadline, uint _minimumContribution){
        goalAmount=_goalAmount;
        deadline=block.timestamp+_deadline;
        manager=msg.sender;
        minimumContribution= _minimumContribution;
        currentState=State.onGoing;
    }

    function contribute() public payable{
        require(msg.value>=minimumContribution);
        require(block.timestamp<deadline);
        if(contributors[msg.sender]==0){
            numberOfContributers++;
        }
        contributors[msg.sender]=contributors[msg.sender]+msg.value;
        raisedAmount+=msg.value;
    }

    receive() payable external{
        contribute();
    }

    function getBalance() public view returns(uint) {
        return raisedAmount;
    }


    function getRefund() public payable{
        require(State.Failure==currentState);
        require(contributors[msg.sender]>0);
        require(block.timestamp>deadline);
        address payable recipient=payable(msg.sender);

        recipient.transfer(contributors[msg.sender]);
        contributors[msg.sender]=0;
        
    }
    
}