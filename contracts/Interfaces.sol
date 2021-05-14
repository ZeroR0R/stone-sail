pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface InvestingAPI is IERC20 {
    
    // Deposit to a pool, returns amount deposited  
    function deposit_eth(uint256 _amount) external returns (uint256);
    function deposit_stn(uint256 _amount) external returns (uint256);
    function depost_dai(uint256 _amount) external returns (uint256);
    
    // Withdraw from a pool, returns amount withdrawn 
    function withdraw_eth(uint256 _amount) external returns (uint256);
    function withdraw_stn(uint256 _amount) external returns (uint256);
    function withdraw_dai(uint256 _amount) external returns (uint256);
    
    // Create an investing pool, returns a bool depending on success 
    function create_pool() external returns (bool); // possibly add a delete pool to optimize gas
    
    // Create and modify investing strategies, returns a bool depending on success 
    function create_strategy() external returns (bool);
    function update_strategy() external returns (bool);
    
    // QOl functions
    function total_lenders(address _poolAddress) external returns (uint256);
    function total_assets(address _poolAddress) external returns (uint256);
    function total_gain(address _poolAddress) external returns (uint256);
    function individual_report(address _poolAddress) external returns (uint256, uint256, uint256); // Returns Amount deposited, ammount currently, and total gain
    function name(address _poolAddress) external view returns (string calldata);
    
    // Events
    event PoolCreated(string Name, uint SupportedTokenID, uint StartingAmount, uint MaxAmount);
}

// Interface used to create and operate strategies

interface StrategyAPI {
    
    function name() external view returns (string memory);
    function pool() external view returns (address);
    function valid() external view returns (bool);
    function manager() external view returns (address); // Who controlls the strategy
    
    function controlledAssets() external view returns (uint256); // Assets that the strategy has 
    function wantedAssets() external view returns (uint256); // Assets that the strategy still wants 
    
    function sellAsset() external; // Sells Asset to DAI 
    function tradeAsset() external; // Trades one token for Another
    
    function sellWarning() external view returns (bool); // If an Asset hits too low or High 
    
    event SoldAsset(string Asset, uint amountSold, uint amountReceived);
    event TradedAsset(string AssetTraded, uint amount, string AssetTradedFor, uint amountReceived);
    
}







