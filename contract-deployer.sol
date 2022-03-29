// SPDX-License-Identifier: MIT

pragma solidity >=0.5.0 <0.9.0;

contract A{
    address public ownerA;
    constructor(address eoa){
        ownerA=eoa;
    }
}

contract Initializer{
    address public ownerInitializer;
    A[] public deployedA;
    constructor(){
        ownerInitializer=msg.sender;
    }

    function deployA() public {
        A new_A_address=new A(msg.sender);
        deployedA.push(new_A_address);
    }
}