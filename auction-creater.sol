import "auction.sol";

// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.9.0;

contract AuctionCreater{
    Auction[] public auctions;

    function createAuction() public{
        Auction newAuction =new Auction(msg.sender);
        auctions.push(newAuction);
    }
}