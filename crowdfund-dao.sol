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

    struct Request{
        string description;
        address payable recipient;
        uint value;
        bool completed;
        uint noOfVoters;
        uint countOfApprovals;
        mapping(address=> bool)  voted ;
    }

    mapping(uint => Request) requests;
    uint public numRequests;
    constructor(uint _goalAmount, uint _deadline, uint _minimumContribution){
        goalAmount=_goalAmount;
        deadline=block.timestamp+_deadline;
        manager=msg.sender;
        minimumContribution= _minimumContribution;
        currentState=State.onGoing;
        // numRequests=0;
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

    modifier onlyManager(){
        require(msg.sender==manager);
        _;
    }

    function createRequest(string memory _description, address payable _recip, uint _value) public onlyManager{
        Request storage newRequest=requests[numRequests];
        numRequests++;
        newRequest.description=_description;
        newRequest.recipient=_recip;
        newRequest.value=_value;
        newRequest.noOfVoters=0;
        newRequest.completed=false;

    }

    function vote(bool approval,uint requestNumber) public {
        require(contributors[msg.sender]>0);
        require(requests[requestNumber].completed==false);
        require(requests[requestNumber].voted[msg.sender]==false);

        if(approval){
            requests[requestNumber].countOfApprovals++;
            requests[requestNumber].noOfVoters++;
            requests[requestNumber].voted[msg.sender]=true;
        }
    }

    function makePayment(uint requestNumber ) payable public onlyManager{
        require(requests[requestNumber].completed==false);

        require((2*requests[requestNumber].countOfApprovals)>requests[requestNumber].noOfVoters, "voters did not approve" );

        requests[requestNumber].recipient.transfer(requests[requestNumber].value);
        requests[requestNumber].completed=true;

    }

    
}