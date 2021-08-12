pragma solidity ^0.8.0;

import "./Interfaces.sol";
import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";

contract Strategies is StrategyAPI { 
 
    struct Strategy {
        
        string: name;
        address: pool;
        
    }
    
}
