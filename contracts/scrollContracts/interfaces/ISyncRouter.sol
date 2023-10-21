// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

interface ISyncRouter {
    struct TokenAmount {
        address token;
        uint amount;
    }

     struct TokenInput {
        address token;
        uint amount;
    }

     struct SwapStep {
        address pool;
        bytes data;
        address callback;
        bytes callbackData;
    }

    struct SwapPath {
        SwapStep[] steps;
        address tokenIn;
        uint amountIn;
    }

    function swap(
        SwapPath[] memory paths,
        uint amountOutMin,
        uint deadline
    ) external payable returns (TokenAmount memory amountOut);

    function wETH() external view returns(address);

    function addLiquidity(
        address pool,
        TokenInput[] calldata inputs,
        bytes calldata data,
        uint minLiquidity,
        address callback,
        bytes calldata callbackData
    ) external payable returns (uint liquidity);

    function burn(
        bytes calldata data,
        address sender,
        address callback,
        bytes calldata callbackData
    ) external returns (TokenAmount[] memory tokenAmounts);

}
