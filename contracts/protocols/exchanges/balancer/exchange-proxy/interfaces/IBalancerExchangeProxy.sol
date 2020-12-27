/**
 *Submitted for verification at Etherscan.io on 2020-08-25
*/

// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.

pragma solidity 0.7.6;
pragma experimental ABIEncoderV2;

interface ExchangeProxy is Ownable {

    using SafeMath for uint256;

    struct Pool {
        address pool;
        uint    tokenBalanceIn;
        uint    tokenWeightIn;
        uint    tokenBalanceOut;
        uint    tokenWeightOut;
        uint    swapFee;
        uint    effectiveLiquidity;
    }

    struct Swap {
        address pool;
        address tokenIn;
        address tokenOut;
        uint    swapAmount; // tokenInAmount / tokenOutAmount
        uint    limitReturnAmount; // minAmountOut / maxAmountIn
        uint    maxPrice;
    }

    // constructor(address _weth) public {
    //     weth = TokenInterface(_weth);
    // }

    function setRegistry(address _registry) external onlyOwner;

    function batchSwapExactIn( Swap[] memory swaps, TokenInterface tokenIn, TokenInterface tokenOut, uint totalAmountIn, uint minTotalAmountOut ) public payable returns (uint totalAmountOut);

    function batchSwapExactOut( Swap[] memory swaps, TokenInterface tokenIn, TokenInterface tokenOut, uint maxTotalAmountIn );

    function multihopBatchSwapExactIn( Swap[][] memory swapSequences, TokenInterface tokenIn, TokenInterface tokenOut, uint totalAmountIn, uint minTotalAmountOut ) public payable returns (uint totalAmountOut);

    function multihopBatchSwapExactOut( Swap[][] memory swapSequences, TokenInterface tokenIn, TokenInterface tokenOut, uint maxTotalAmountIn ) public payable returns (uint totalAmountIn);

    function smartSwapExactIn( TokenInterface tokenIn, TokenInterface tokenOut, uint totalAmountIn, uint minTotalAmountOut, uint nPools ) public payable returns (uint totalAmountOut);

    function smartSwapExactOut( TokenInterface tokenIn, TokenInterface tokenOut, uint totalAmountOut, uint maxTotalAmountIn, uint nPools ) public payable returns (uint totalAmountIn);

    function viewSplitExactIn( address tokenIn, address tokenOut, uint swapAmount, uint nPools ) public view returns (Swap[] memory swaps, uint totalOutput);

    function viewSplitExactOut( address tokenIn, address tokenOut, uint swapAmount, uint nPools ) public view returns (Swap[] memory swaps, uint totalOutput);

    function getPoolData( address tokenIn, address tokenOut, address poolAddress ) internal view returns (Pool memory);

    function calcEffectiveLiquidity( uint tokenWeightIn, uint tokenBalanceOut, uint tokenWeightOut ) internal pure returns (uint effectiveLiquidity);

    function calcTotalOutExactIn( uint[] memory bestInputAmounts, Pool[] memory bestPools ) internal pure returns (uint totalOutput);

    function calcTotalOutExactOut( uint[] memory bestInputAmounts, Pool[] memory bestPools) internal pure returns (uint totalOutput);

    function transferFromAll(TokenInterface token, uint amount) internal returns(bool);

    function getBalance(TokenInterface token) internal view returns (uint);

    function transferAll(TokenInterface token, uint amount) internal returns(bool);

    function isETH(TokenInterface token) internal pure returns(bool);

    receive() external payable;
}