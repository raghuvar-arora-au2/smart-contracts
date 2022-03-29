// SPDX-License-Identifier: MIT

pragma solidity >=0.5.0 <0.9.0;

contract Auction{
    address payable public owner;
    uint public startBlock;
    uint public endBlock;
    string public ipfsHash;
    enum State{Started, Running, Ended, Canceled}
    State public auctionState;

    uint public highestBindingBid;
    address payable public highestBidder;

    mapping(address => uint) public bids;

    uint public bidIncrement;


    constructor(){
        owner=payable(msg.sender);
        auctionState=State.Running;
        startBlock=block.number;
        endBlock=startBlock+(604800/50);
        bidIncrement=100;
        highestBindingBid=0;
    }

    modifier notOwner(){
        require(msg.sender!=owner);
        _;
    }

    modifier afterStart(){
        require(block.number>=startBlock);
        _;
    }

    modifier beforeEnd(){
        require(block.number<=endBlock);
        _;
    }

    function placeBid(uint bid) public payable notOwner afterStart beforeEnd{
        require(auctionState==State.Running);

    }

    function placeBindingBid(uint bid) public payable notOwner afterStart beforeEnd{
        require(auctionState==State.Running);
        require(highestBindingBid+bidIncrement<bid, "bid not high enough");
        highestBidder=payable(msg.sender);
        highestBindingBid=msg.value;
    }
}