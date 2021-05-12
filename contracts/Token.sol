pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Main is ERC20 {
    
    uint256 initial_supply = 10000;
    address owner;
    
    constructor() ERC20("Stones", "STN") {
        owner = msg.sender;
        _mint(owner, initial_supply);
    }
    
}
