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


    constructor(address eoa){
        owner=payable(eoa);
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

    modifier onlyOwner(){
        require(msg.sender==owner);
        _;
    }

    modifier afterStart(){
        require(block.number>=startBlock);
        _;
    }

    modifier beforeEnd() {
        require(block.number<=endBlock);
        _;
    }

    function placeBid(uint bid) public payable notOwner afterStart beforeEnd{
        require(auctionState==State.Running);
        require(msg.value>bidIncrement);

        highestBidder=payable(msg.sender);
        highestBindingBid=bid+highestBindingBid;
        bids[msg.sender]=highestBindingBid;
        
    }

    function cancelAuction() public onlyOwner {
        auctionState=State.Canceled;
    }

    // complete this 
    function finalizeAuction() public {
        require(auctionState==State.Canceled || block.number>endBlock);
        require(msg.sender==owner || bids[msg.sender]>0 );
        
        if(auctionState==State.Canceled){
            if(bids[msg.sender]>0){
                payable(msg.sender).transfer(bids[msg.sender]);
                bids[msg.sender]=0;
            }
        }else{
            if(msg.sender==owner ){
                payable(highestBidder).transfer(highestBindingBid);
                bids[highestBidder]=0;
            }
            else{
                payable(msg.sender).transfer(bids[msg.sender]);
                bids[msg.sender]=0;
            }
        }

    }


}