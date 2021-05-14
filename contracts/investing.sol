pragma solidity ^0.8.0;

import "./Interfaces.sol";

contract Investing is InvestingAPI {
    
    address owner = msg.sender;
    address DAI = address(0x6B175474E89094C44Da98b954EedeAC495271d0F);
    
    DaiToken daiToken;
    
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
    
    constructor() {
        daiToken = DaiToken(DAI);
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
        require(_amount >= 1, 'Your deposit must be at least 1 DAI');
        require(pool[_poolAddress].valid == true, 'This pool is not valid');
        require(pool[_poolAddress].initalToken == 2, 'This pool does not accept DAI');  
     
        if (daiToken.transferFrom(msg.sender, address(this), _amount)) {
            
        } else {require( 1 == 2, "DAI Transfer Failed");}
        
        pool[_poolAddress].amount = pool[_poolAddress].amount + _amount;
        lender[msg.sender] = Lender(_poolAddress, lender[msg.sender].amount + _amount, 0);
    }
    
    function withdraw_eth(uint256 _amount) external override returns (uint256) {
     require(_amount > 0, "You can't withdraw 0 ether");
     require(pool[lender[msg.sender].pool].valid == true, 'This pool is not valid');
     require(lender[msg.sender].tokenType == 0, 'This pool does not use Ether');
     require(lender[msg.sender].amount >= _amount, 'You do not have that much invested');
     
     address(this).transfer(msg.sender, _amount);
        
    }
    function withdraw_stn(uint256 _amount) external returns (uint256);
    function withdraw_dai(uint256 _amount) external returns (uint256);
    
}
