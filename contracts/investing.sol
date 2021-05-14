pragma solidity ^0.8.0;

import "./Interfaces.sol";

contract Investing is InvestingAPI {
    
    address owner = msg.sender;
    
    struct SupportedTokens {
        string name;
        bool supported;
    }
    
    struct Pool {
        string name;
        string initalToken;
        uint amount;
        uint totalStrategies;
        bool valid;
    }
    
    mapping(string => SupportedTokens) public supportedTokens;
    mapping(address => Pool) public pool;

    modifier onlyOwner() {
        
        require(msg.sender == owner, "Only the owner can call this function");
        _;
        
    }
    
    modifier onlySupportedTokens(string memory tokenName_) {
        
        require(supportedTokens[tokenName_].supported == true, "Sorry this token is not supported.");
        _;
        
    }
    
    function create_pool(string memory _tokenName, uint256 _startingAmount, uint256 _maxAmount, string memory _name)
    external onlySupportedTokens(_tokenName) returns (bool) {
        
        pool[msg.sender] = Pool(_name, _tokenName, _startingAmount, 0, true);
        
        emit PoolCreated(_name, _tokenName, _startingAmount, _maxAmount);
        
        return true;
    }

    function deposit_eth(uint256 _amount, address _poolAddress) external override returns (uint256) {
        transfer()
    }
    function deposit_stn(uint256 _amount) external returns (uint256);
    function depost_dai(uint256 _amount) external returns (uint256);
    
}
