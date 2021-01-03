pragma solidity 0.7.5;

interface IRebaser {
  function registerVelocity(uint256 amount) external;
  function sEMA() external view returns (uint256); 
  function fEMA() external view returns (uint256); 
}
