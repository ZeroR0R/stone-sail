pragma solidity ^0.8.0;

import "./Interfaces.sol";

contract Investing is InvestingAPI {
    
    address owner = msg.sender;
    
    struct SupportedTokens {
        uint id;
        bool supported;
    }
    
    struct Pool {
        string name;
        uint initalToken;
        uint amount;
        uint totalStrategies;
        bool valid;
    }
    
    struct Lender {
        address pool;
        uint amount;
        uint tokenType;
    }
    
    mapping(uint => SupportedTokens) public supportedTokens;
    mapping(address => Pool) public pool;
    mapping(address => Lender) public lender;
    
    modifier onlyOwner() {
        
        require(msg.sender == owner, "Only the owner can call this function");
        _;
        
    }
    
    modifier onlySupportedTokens(uint tokenID_) {
        
        require(supportedTokens[tokenID_].supported == true, "Sorry this token is not supported.");
        _;
        
    }
    
    function create_pool(uint _tokenID, uint256 _startingAmount, uint256 _maxAmount, string memory _name)
    external onlySupportedTokens(_tokenID) returns (bool) {
        
        pool[msg.sender] = Pool(_name, _tokenID, _startingAmount, 0, true);
        
        emit PoolCreated(_name, _tokenID, _startingAmount, _maxAmount);
        
        return true;
    }

    function deposit_eth(address _poolAddress) external returns (uint256) {
        require(msg.value>=1e16, 'Your deposit must be at least 0.01 ETH');
        require(pool[_poolAddress].valid == true, 'This pool is not valid');   
        require(pool[_poolAddress].initalToken == 0, 'This pool does not accept ETH');  
        
        pool[_poolAddress].amount = pool[_poolAddress].amount + msg.value;
        lender[msg.sender] = Lender(_poolAddress, lender[msg.sender].amount + msg.value, 0);
        
    }
    
    function deposit_stn(uint256 _amount, address _poolAddress) external returns (uint256) {
        require(_amount >= 1, 'Your deposit must be at least 1 Stone');
        require(pool[_poolAddress].valid == true, 'This pool is not valid');
        require(pool[_poolAddress].initalToken == 1, 'This pool does not accept Stones');  
        
        // token.transferFrom(msg.sender, address(this), _amount);              ADD AFTER Token.sol IS FINISHED
        
        pool[_poolAddress].amount = pool[_poolAddress].amount + _amount;
        lender[msg.sender] = Lender(_poolAddress, lender[msg.sender].amount + msg.value, 0);
        
    }
    
    function depost_dai(uint256 _amount, address _poolAddress) external returns (uint256) {
     
     
        
    }
    
}
